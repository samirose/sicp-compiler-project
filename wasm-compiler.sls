#!r6rs
(library (wasm-compiler)
         (export compile-r7rs-library-to-wasm-module
                 compile-single-exp-to-wasm-module)
         (import (rnrs base)
                 (rnrs lists)
                 (rnrs io simple)
                 (lists)
                 (scheme-syntax)
                 (scheme-r7rs-syntax)
                 (lexical-env)
                 (compiled-program)
                 (wasm-module-definitions)
                 (wasm-syntax))

;;;; SCHEME to WAT (WebAssembly Text format) compiler written in R6RS
;;;; BASED ON COMPILER FROM SECTION 5.5 OF
;;;; STRUCTURE AND INTERPRETATION OF COMPUTER PROGRAMS

(define (compile-r7rs-library-to-wasm-module exp)
  (if (r7rs-library? exp)
      (let*
          ((exps
            (or (library-decl 'begin exp)
                (error "No begin declaration in library" exp)))
           (exp-sequence
            (begin-actions exps))
           (definitions
             (filter definition? exp-sequence))
           (non-definitions
            (reject definition? exp-sequence))
           (lexical-env
            (add-new-lexical-frame
             (map definition-variable definitions)
             (make-empty-lexical-env)))
           (definitions-program
             (if (not (null? definitions))
                 (compile-sequence definitions
                                   (make-empty-compiled-program)
                                   lexical-env
                                   compile)
                 (make-empty-compiled-program)))
           (program
            (compile-sequence non-definitions definitions-program lexical-env compile))
           (module-definitions
            (compiled-program-module-definitions program))
           (get-module-definitions
            (lambda (type)
              (wasm-module-get-definitions module-definitions 'elem)))
           (elem-defs
            (get-module-definitions 'elem))
           (elem-func-indices
            (map wasm-elem-definition-func-index elem-defs))
           (table-definition
            (if (null? elem-func-indices)
                '()
                `((table ,scheme-procedures-table-id ,(length elem-func-indices) funcref))))
           (elem-definition
            (if (null? elem-func-indices)
                '()
                `((elem ,scheme-procedures-table-id (i32.const 0) func ,@elem-func-indices))))
           (global-init-defs
            (map cdr (get-module-definitions 'global-init)))
           (global-init-func
            (if (null? global-init-defs)
                '()
                `((func $global-init
                        ,@(flatten-n 2 global-init-defs))
                  (start $global-init))))
           (top-level-code
            (compiled-program-value-code program)))
        `(module
           ,@(get-module-definitions 'type)
           ,@(get-module-definitions 'func)
           (func $main (result i32)
                 ,@top-level-code)
           ,@table-definition
           ,@(get-module-definitions 'global)
           ,@global-init-func
           (export "main" (func $main))
           ,@elem-definition))
      (error "Invalid R7RS library" exp)))

(define (compile-single-exp-to-wasm-module exp)
  (let* ((sequence (if (begin? exp) exp `(begin ,exp)))
         (library `(define-library ,sequence)))
    (compile-r7rs-library-to-wasm-module library)))

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
         (compile-lambda exp program lexical-env compile))
        ((begin? exp)
         (compile-sequence (begin-actions exp) program lexical-env compile))
        ((cond? exp)
         (compile (cond->if exp) lexical-env))
        ((open-coded-primitive-application? exp)
         (compile-open-coded-primitive exp program lexical-env compile))
        ((application? exp)
         (compile-application exp program lexical-env compile))
        (else
         (error "Unknown expression type -- COMPILE" exp))))

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
          (error "Unsupported value" exp)))))

(define (compile-quoted exp program)
  (error "Quote not supported yet" exp))

(define (compile-variable exp program lexical-env)
  (let* ((lexical-address
          (find-variable exp lexical-env))
         (get-instr
          (cond ((eq? lexical-address 'not-found)
                 (error "Lexically unbound variable" exp))
                ((global-address? lexical-address) 'get_global)
                ((= (frame-index lexical-address) 0) 'get_local)
                (else
                 (error "Variables in immediate enclosing scope or top-level only supported" exp)))))
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
            ((eq? lexical-address 'not-found)
             (error "Lexically unbound variable" exp))
            ((global-address? lexical-address) 'set_global)
            ((= (frame-index lexical-address) 0) 'set_local)
            (else
             (error "Variables in immediate enclosing scope or top-level only supported" exp)))))
    (compiled-program-append-value-code
     program-with-value-computing-code
     `(,set-instr ,(var-index lexical-address) ,@unspecified-value))))

(define (compile-definition exp program lexical-env compile)
  (if (global-lexical-env? lexical-env)
      (let* ((program-with-value-computing-code
              (compile (definition-value exp) program lexical-env))
             (value-code
              (compiled-program-value-code program-with-value-computing-code))
             (const-value?
              (and (= (length value-code) 2)
                   (eq? (car value-code) 'i32.const)))
             (init-expr
              (if const-value? value-code uninitialized-value))
             (global-index
              (wasm-module-definitions-count
               (compiled-program-module-definitions program-with-value-computing-code)
               'global))
             (global-definition
              `((global (mut i32) ,init-expr)))
             (definitions
              (if const-value?
                  global-definition
                  (append
                   global-definition
                   `((global-init
                      (,@value-code (set_global ,global-index))))))))
        (compiled-program-with-definitions-and-value-code
         program-with-value-computing-code
         definitions
         unspecified-value))
      (error "Only top-level define is supported" exp)))

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
  (let ((op (cadr (assoc (operator exp) open-coded-primitives-to-machine-ops))))
    (define (compile-rest-arguments program operands)
      (let ((program-with-next-value-computing-code
             (compiled-program-append-value-code
              (compile (car operands) program lexical-env) op)))
         (if (null? (cdr operands))
             program-with-next-value-computing-code
             (compiled-program-append-value-code
              program-with-next-value-computing-code
              (compiled-program-value-code
               (compile-rest-arguments program-with-next-value-computing-code (cdr operands)))))))
    (let* ((operands (operands exp))
           (program-with-next-value-computing-code
            (compile (car operands) program lexical-env)))
      (compiled-program-append-value-code
       program-with-next-value-computing-code
       (compiled-program-value-code
        (compile-rest-arguments program-with-next-value-computing-code (cdr operands)))))))

;;;ids

(define id-counter 0)

(define (new-id-number)
  (set! id-counter (+ 1 id-counter))
  id-counter)

(define (make-id name number)
  (string->symbol
    (string-append "$" (symbol->string name)
                   (number->string number))))

;;;conditional expressions

(define (compile-if exp module lexical-env compile)
  (let ((p-code (compile (if-predicate exp) module lexical-env))
        (c-code (compile (if-consequent exp) module lexical-env))
        (a-code
         (if (if-alternative exp)
             (compile (if-alternative exp) module lexical-env)
             unspecified-value)))
    `(,@p-code
      if (result i32)
      ,@c-code
      else
      ,@a-code
      end)))

;;; sequences

(define (compile-sequence seq module lexical-env compile)
  (if (last-exp? seq)
      (compile (first-exp seq) module lexical-env)
      `(,@(compile (first-exp seq) module lexical-env)
        drop ; Drop the results of the intermediate expressions
        ,@(compile-sequence (rest-exps seq) module lexical-env compile))))

;;;lambda expressions

(define (make-scheme-procedure-type-id arity)
  (make-id 'scm-procedure arity))

(define scheme-procedure-param-type 'i32)

(define (add-scheme-procedure-type-definition module arity)
  (let* ((type-id (make-scheme-procedure-type-id arity))
         (param-types
          (if (= 0 arity)
              '()
              (list
               (cons 'param
                     (make-list scheme-procedure-param-type arity)))))
         (type-definition
          `(type ,type-id (func ,@param-types (result i32)))))
    (if (not ((module 'definition-index) type-definition))
        ((module 'add-definition!) type-definition))
    type-id))

(define scheme-procedures-table-id '$scm-procedures)

(define (compile-lambda exp module lexical-env compile)
  (let* ((func-index
          ; Generate id for the lambda function's type based on number of parameters
          (let* ((formals (lambda-parameters exp))
                 (func-type-id
                  (add-scheme-procedure-type-definition module (length formals)))
                 (body-code
                   (compile-sequence
                    (lambda-body exp) module (add-new-lexical-frame formals lexical-env) compile)))
            ; Add function to the module and keep its index in func-index
            ((module 'add-definition!)
             `(func (type ,func-type-id) ,@body-code))))
         ; Add table element for the function for indirect calling.
         ; The module post-processing will combine the elem items to a single item and add a
         ; table element of correct size.
         (elem-index
          ((module 'add-definition!)
           `(elem ,scheme-procedures-table-id ,func-index))))
         ; Lambda expression's value is the function's index in the table
         `(i32.const ,elem-index)))

;;;combinations

(define (compile-application exp module lexical-env compile)
  (let ((proc-code
         (compile (operator exp) module lexical-env))
        (operand-codes
         (map (lambda (operand) (compile operand module lexical-env))
              (operands exp)))
        (func-type-id
         (add-scheme-procedure-type-definition module (length (operands exp)))))
    (append
     (construct-arglist operand-codes)
     proc-code
     `(call_indirect (type ,func-type-id)))))

(define (construct-arglist operand-codes)
  (if (null? operand-codes)
      '()
      (append
       (car operand-codes)
       (construct-arglist (cdr operand-codes)))))

'(COMPILER LOADED)
)
