#!r6rs
(library
 (expression-compiler)
 (export compile
         compile-sequence)
 (import (rnrs base)
         (rnrs lists)
         (lists)
         (scheme-syntax)
         (lexical-env)
         (compiled-program)
         (compilation-error)
         (wasm-syntax)
         (wasm-module-definitions))

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
                ((global-address? lexical-address) 'get_global)
                ((= (frame-index lexical-address) 0) 'get_local)
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
            ((global-address? lexical-address) 'set_global)
            ((= (frame-index lexical-address) 0) 'set_local)
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
       (const-value?
        (wasm-const-value? value-code))
       (init-instr
        (if const-value? value-code uninitialized-value))
       (global-definition
        `(global (mut i32) ,init-instr))
       (global-init
        (if const-value?
            '()
            `((global-init
               (,@value-code set_global ,global-index)))))
       (definitions
         (cons global-definition global-init)))
    (compiled-program-with-definitions-and-value-code
     program-with-value-computing-code
     definitions
     unspecified-value)))

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

(define (lambda-body-env lambda-exp lambda-lexical-env formals)
  (let ((duplicate-param (first-duplicate formals)))
    (if (null? duplicate-param)
        (add-new-lexical-frame lambda-lexical-env formals '())
        (raise-compilation-error "Duplicate parameter in lambda" lambda-exp))))

(define (compile-lambda exp program lexical-env current-binding compile)
  (let*
      ((formals (lambda-formals exp))
       ; Compile the lambda procedure body
       (body-program
        (compile-sequence
         (lambda-body exp)
         program
         (lambda-body-env exp lexical-env formals)
         compile))
       ; Add function type, if needed and look up its index
       (func-type (scheme-procedure-type-definition (length formals)))
       (type-program
        (if (compiled-program-contains-definition body-program func-type)
            body-program
            (compiled-program-add-definition body-program func-type)))
       (type-index
        (compiled-program-definition-index type-program func-type))
       ; Add function to the module and look up its index
       (func-definition
        `(func (type ,type-index)
               ,@(compiled-program-value-code body-program)))
       (func-program
        (if (compiled-program-contains-definition type-program func-definition)
            type-program
            (compiled-program-add-definition type-program func-definition)))
       (func-index
        (compiled-program-definition-index func-program func-definition))
       ; Add export definition for the function if there is an active export binding
       (export-program
        (let ((exported-name
               (cond ((assq 'export (env-get-additional-info current-binding lexical-env)) => cadr)
                     (else #f))))
          (if exported-name
              (compiled-program-add-definition
               func-program
               `(export ,exported-name (func ,func-index)))
              func-program)))
       ; Add table element for the function for indirect calling.
       ; The module compilation procedure compile-r7rs-library-to-wasm-module will combine the elem
       ; items to a single item and add a table element of correct size.
       (elem-definition
        `(elem ,func-index))
       (elem-program
        (if (compiled-program-contains-definition export-program elem-definition)
            export-program
            (compiled-program-add-definition export-program elem-definition)))
       (elem-index
        (compiled-program-definition-index elem-program elem-definition)))
       ; Lambda expression's value is the function's index in the table
    (compiled-program-with-value-code
     elem-program
     `(i32.const ,elem-index))))

;;;combinations

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
        (if (null? operands)
            (compiled-program-with-value-code type-program '())
            (let ((first-operand-program
                   (compile (car operands) type-program lexical-env)))
              (fold-left
               (lambda (program operand)
                 (compiled-program-append-value-codes
                  program
                  (compile operand program lexical-env)))
               first-operand-program
               (cdr operands)))))
       (operands-and-operator-program
        (compiled-program-append-value-codes
         operands-program
         (compile (operator exp) operands-program lexical-env))))
    (compiled-program-append-value-code
     operands-and-operator-program
     `(call_indirect (type ,type-index)))))

'(COMPILER LOADED)
)