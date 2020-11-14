#!r6rs
(library
 (expression-compiler)
 (export compile
         compile-values
         compile-procedure-body
         compile-proc-to-func)
 (import (rnrs base)
         (rnrs lists)
         (lists)
         (scheme-syntax)
         (lexical-env)
         (compiled-program)
         (compilation-error)
         (wasm-syntax)
         (wasm-module-definitions)
         (pattern-match))

;;;; SCHEME to WAT (WebAssembly Text format) compiler written in R6RS
;;;; BASED ON COMPILER FROM SECTION 5.5 OF
;;;; STRUCTURE AND INTERPRETATION OF COMPUTER PROGRAMS

(define (compile exp program lexical-env)
  (cond ((self-evaluating? exp)
         (compile-self-evaluating exp program))
        ((quoted? exp)
         (compile-quoted exp program))
        ((variable? exp)
         (compile-variable exp program lexical-env))
        ((assignment? exp)
         (compile-assignment exp program lexical-env compile))
        ((definition? exp)
         (compile-definition exp program lexical-env compile))
        ((if? exp)
         (compile-if exp program lexical-env compile))
        ((lambda? exp)
         (compile-lambda exp program lexical-env '() compile))
        ((let? exp)
         (compile-let exp program lexical-env compile))
        ((begin? exp)
         (compile-sequence (begin-actions exp) program lexical-env compile))
        ((open-coded-primitive-application? exp)
         (compile-open-coded-primitive exp program lexical-env compile))
        ((application? exp)
         (compile-application exp program lexical-env compile))
        (else
         (raise-compilation-error "Unknown expression type -- COMPILE" exp))))

;;;special values

; Uninitialized value should be distinguishable from valid values.
; Use zero for now until typing of primitive values is implemented.
(define uninitialized-value '(i32.const 0))

; Result of expressions for which Scheme defines an unspecified result
(define unspecified-value '(i32.const 0))

;;;simple expressions

(define (compile-self-evaluating exp program)
  (compiled-program-with-value-code
   program
   (cond ((integer? exp)
          `(i32.const ,exp))
         ((boolean? exp)
          `(i32.const ,(if exp 1 0)))
         (else
          (raise-compilation-error "Unsupported value" exp)))))

(define (compile-quoted exp program)
  (raise-compilation-error "Quote not supported yet" exp))

(define (compile-variable exp program lexical-env)
  (let* ((lexical-address
          (find-variable exp lexical-env))
         (get-instr
          (cond ((not lexical-address)
                 (raise-compilation-error "Lexically unbound variable" exp))
                ((global-address? lexical-address) 'global.get)
                ((= (frame-index lexical-address) 0) 'local.get)
                (else
                 (raise-compilation-error "Variables in immediate enclosing scope or top-level only supported" exp)))))
    (compiled-program-with-value-code
     program
     `(,get-instr ,(var-index lexical-address)))))

(define (compile-assignment exp program lexical-env compile)
  (let* ((lexical-address
          (find-variable (assignment-variable exp) lexical-env))
         (program-with-value-computing-code
          (compile (assignment-value exp) program lexical-env))
         (set-instr
          (cond
            ((not lexical-address)
             (raise-compilation-error "Lexically unbound variable" exp))
            ((global-address? lexical-address) 'global.set)
            ((= (frame-index lexical-address) 0) 'local.set)
            (else
             (raise-compilation-error "Variables in immediate enclosing scope or top-level only supported" exp)))))
    (compiled-program-append-value-code
     program-with-value-computing-code
     `(,set-instr ,(var-index lexical-address) ,@unspecified-value))))

(define (compile-definition exp program lexical-env compile)
  (let*
      ((variable (definition-variable exp))
       (global-index
        (begin
          (if (not (global-lexical-env? lexical-env))
              (raise-compilation-error "Only top-level define is supported" exp))
          (let ((address (find-variable variable lexical-env)))
            (if (not address)
                (raise-compilation-error "Internal compiler error: global binding missing from global lexical env"
                       (list variable lexical-env)))
            (var-index address))))
       (value (definition-value exp))
       (program-with-value-computing-code
        (if (lambda? value)
            (compile-lambda value program lexical-env variable compile)
            (compile value program lexical-env)))
       (value-code
        (compiled-program-value-code program-with-value-computing-code))
       (init-instr
        (if (wasm-const-value? value-code)
            value-code
            uninitialized-value))
       (global-definition
        `(global (mut i32) ,init-instr))
       (init-code
        (if (wasm-const-value? value-code)
            '()
            `(,@value-code global.set ,global-index))))
    (compiled-program-with-definition-and-value-code
     program-with-value-computing-code
     global-definition
     init-code)))

;;;open-coded primitives

(define open-coded-primitives-to-machine-ops
  '((+ (i32.add))
    (- (i32.sub))
    (* (i32.mul))
    (/ (i32.div_s))
    (= (i32.eq))
    (< (i32.lt_s))
    (> (i32.gt_s))))

(define (open-coded-primitive-application? exp)
  (and (application? exp)
       (assoc (operator exp) open-coded-primitives-to-machine-ops)))

(define (compile-open-coded-primitive exp program lexical-env compile)
  (let ((op-code (cadr (assoc (operator exp) open-coded-primitives-to-machine-ops))))
    (define (compile-rest-arguments program operands)
      (let ((program-with-next-value-computing-code
             (compiled-program-append-value-code
              (compile (car operands) program lexical-env)
              op-code)))
         (if (null? (cdr operands))
             program-with-next-value-computing-code
             (compiled-program-append-value-codes
              program-with-next-value-computing-code
              (compile-rest-arguments program-with-next-value-computing-code (cdr operands))))))
    (let* ((operands (operands exp))
           (program-with-next-value-computing-code
            (compile (car operands) program lexical-env)))
      (compiled-program-append-value-codes
       program-with-next-value-computing-code
       (compile-rest-arguments program-with-next-value-computing-code (cdr operands))))))

;;;conditional expressions

(define (compile-if exp program lexical-env compile)
  (let* ((t-prog (compile (if-test exp) program lexical-env))
         (c-prog (compile (if-consequent exp) t-prog lexical-env))
         (a-prog
          (if (if-alternate exp)
              (compile (if-alternate exp) c-prog lexical-env)
              (compiled-program-with-value-code c-prog unspecified-value))))
    (compiled-program-with-value-code
     a-prog
     `(,@(compiled-program-value-code t-prog)
       if (result i32)
       ,@(compiled-program-value-code c-prog)
       else
       ,@(compiled-program-value-code a-prog)
       end))))

;;; sequences

(define (compile-sequence seq program lexical-env compile)
  (let ((program-with-next-exp
         (compile (first-exp seq) program lexical-env)))
    (if (last-exp? seq)
        program-with-next-exp
        (let ((program-with-next-exp-result-discarded
               (compiled-program-append-value-code
                program-with-next-exp
                '(drop))))
          (compiled-program-append-value-codes
           program-with-next-exp-result-discarded
           (compile-sequence
            (rest-exps seq)
            program-with-next-exp-result-discarded
            lexical-env
            compile))))))

;;;lambda expressions

(define scheme-procedure-param-type 'i32)

(define (scheme-procedure-type-definition arity)
  (let ((param-types
         (if (= 0 arity)
             '()
             (list
              (cons 'param
                    (make-list scheme-procedure-param-type arity))))))
    `(type (func ,@param-types (result i32)))))

(define (compile-procedure-body seq program lexical-env compile)
  (let*
      ((body-program
        (compile-sequence seq program lexical-env compile))
       (body-code
        (wasm-local-definitions-to-top
         (compiled-program-value-code body-program))))
    (compiled-program-with-value-code body-program body-code)))

(define (compile-proc-to-func context-exp formals body program lexical-env exported-name compile)
   (let*
       ; Compile the procedure body
       ((body-env
         (let ((duplicate-param (first-duplicate formals)))
           (if (null? duplicate-param)
               (add-new-lexical-frame lexical-env formals '())
               (raise-compilation-error "Duplicate parameter in" context-exp))))
        (body-program
         (compile-procedure-body body program body-env compile))
        ; Add function type, if needed, and look up its index
        (func-type (scheme-procedure-type-definition (length formals)))
        (type-program
         (if (compiled-program-contains-definition body-program func-type)
             body-program
             (compiled-program-add-definition body-program func-type)))
        (type-index
         (compiled-program-definition-index type-program func-type))
        ; Add function definition and look up its index
        (func-definition
         `(func (type ,type-index)
                ,@(compiled-program-value-code body-program)))
        (func-index
         (compiled-program-definitions-count type-program 'func))
        (func-program
         (compiled-program-with-definition-and-value-code
          type-program
          func-definition
          '())))
     ; Add export definition for the function if exported name is defined
     (if exported-name
         (compiled-program-add-definition
          func-program
          `(export ,exported-name (func ,func-index)))
         func-program)))

(define (compile-lambda exp program lexical-env current-binding compile)
  (let*
      ((formals (lambda-formals exp))
       (exported-name
        (cond ((assq 'export (env-get-additional-info current-binding lexical-env)) => cadr)
              (else #f)))
       (func-program
        (compile-proc-to-func
         exp
         formals
         (lambda-body exp)
         program
         lexical-env
         exported-name
         compile))
       ; Add table element for the function for indirect calling
       (func-index
        (- (compiled-program-definitions-count func-program 'func) 1))
       (elem-definition
        `(elem ,func-index))
       (elem-index
        (compiled-program-definitions-count func-program 'elem))
       (elem-program
        (compiled-program-add-definition func-program elem-definition)))
       ; Lambda expression's value is the function's index in the table
    (compiled-program-with-value-code
     elem-program
     `(i32.const ,elem-index))))

;;;let expression
(define (compile-compute-and-assign exps program lexical-env compile assign-code)
  (let loop ((es exps)
             (n 0)
             (p program))
    (if (null? es)
        p
        (loop (cdr es)
              (+ n 1)
              (compiled-program-append-value-codes
               p
               (compiled-program-append-value-code
                (compile (car es) p lexical-env)
                (assign-code n)))))))

(define (compile-let exp program lexical-env compile)
  (let*
      ((bindings (let-bindings exp))
       (variables
        (let* ((vars (map binding-variable bindings))
               (duplicate-var (first-duplicate vars)))
          (if (null? duplicate-var)
              vars
              (raise-compilation-error "Duplicate variable in let expression" exp))))
       (values (map binding-value bindings))
       (body (let-body exp))
       (local-defs-program
        (compiled-program-with-value-code
         program
         (list (wasm-define-locals 'i32 (length variables)))))
        (body-env
         (add-new-local-frame lexical-env variables '()))
       (var-index-offset (env-var-index-offset body-env))
       (compute-and-assign-values-program
        (compile-compute-and-assign
         values
         local-defs-program
         lexical-env
         compile
         (lambda (n)
           `(local.set ,(+ var-index-offset n)))))
        (body-program
         (compile-sequence body compute-and-assign-values-program body-env compile)))
    (compiled-program-append-value-codes
     compute-and-assign-values-program
     body-program)))

;;;combinations

(define (compile-values exps program lexical-env compile)
  (if (null? exps)
      (compiled-program-with-value-code program '())
      (let ((first-operand-program
             (compile (car exps) program lexical-env)))
        (fold-left
         (lambda (program exp)
           (compiled-program-append-value-codes
            program
            (compile exp program lexical-env)))
         first-operand-program
         (cdr exps)))))

(define (compile-application exp program lexical-env compile)
  (let*
      ((operands (operands exp))
       (func-type (scheme-procedure-type-definition (length operands)))
       (type-program
        (if (compiled-program-contains-definition program func-type)
            program
            (compiled-program-add-definition program func-type)))
       (type-index
        (compiled-program-definition-index type-program func-type))
       (operands-program
        (compile-values operands type-program lexical-env compile))
       (operands-and-operator-program
        (compiled-program-append-value-codes
         operands-program
         (compile (operator exp) operands-program lexical-env))))
    (compiled-program-append-value-code
     operands-and-operator-program
     `(call_indirect (type ,type-index)))))

'(COMPILER LOADED)
)
