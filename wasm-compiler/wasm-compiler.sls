#!r6rs
(library (wasm-compiler)
         (export compile-r7rs-library-to-wasm-module
                 compile-single-exp-to-wasm-module)
         (import (rnrs base)
                 (rnrs lists)
                 (lists)
                 (scheme-syntax)
                 (scheme-r7rs-syntax)
                 (lexical-env)
                 (wasm-definitions-table)
                 (wasm-syntax))

;;;; SCHEME to WAT (WebAssembly Text format) compiler written in R6RS
;;;; BASED ON COMPILER FROM SECTION 5.5 OF
;;;; STRUCTURE AND INTERPRETATION OF COMPUTER PROGRAMS

(define (compile-r7rs-library-to-wasm-module exp)
  (if (r7rs-library? exp)
      (let*
          ((module (make-wasm-definitions-table))
           (exps
            (or (library-decl 'begin exp)
                (error "No begin declaration in library" exp)))
           (exp-sequence (begin-actions exps))
           (definitions (filter definition? exp-sequence))
           (lexical-env
            (add-new-lexical-frame
             (map definition-variable definitions)
             (make-empty-lexical-env)))
           (non-definitions (reject definition? exp-sequence))
           (top-level-code
            (begin
              (if (not (null? definitions))
                  (compile-sequence definitions module lexical-env compile))
              (compile-sequence non-definitions module lexical-env compile)))
           (elem-def? (lambda (def) (wasm-definition-type? 'elem def)))
           (elem-defs (filter elem-def? (module 'definitions)))
           (non-elem-defs (reject elem-def? (module 'definitions)))
           (elem-func-indices (map wasm-elem-definition-func-index elem-defs))
           (table-definition
            (if (null? elem-func-indices)
                '()
                `((table ,scheme-procedures-table-id ,(length elem-func-indices) funcref))))
           (elem-definition
            (if (null? elem-func-indices)
                '()
                `((elem ,scheme-procedures-table-id (i32.const 0) func ,@elem-func-indices)))))
           `(module
              ,@non-elem-defs
              ,@table-definition
              ,@elem-definition
              (func $main (result i32)
                    ,@top-level-code)
              (export "main" (func $main))))
      (error "Invalid R7RS library" exp)))

(define (compile-single-exp-to-wasm-module exp)
  (let* ((sequence (if (begin? exp) exp `(begin ,exp)))
         (library `(define-library ,sequence)))
    (compile-r7rs-library-to-wasm-module library)))

(define (compile exp module lexical-env)
  (cond ((self-evaluating? exp)
         (compile-self-evaluating exp))
        ((quoted? exp) (compile-quoted exp))
        ((variable? exp)
         (compile-variable exp lexical-env))
        ((assignment? exp)
         (compile-assignment exp module lexical-env compile))
        ((definition? exp)
         (compile-definition exp module lexical-env compile))
        ((if? exp) (compile-if exp module lexical-env compile))
        ((lambda? exp) (compile-lambda exp module lexical-env compile))
        ((begin? exp)
         (compile-sequence (begin-actions exp) module lexical-env compile))
        ((cond? exp) (compile (cond->if exp) lexical-env))
        ((open-coded-primitive-application? exp)
         (compile-open-coded-primitive exp module lexical-env compile))
        ((application? exp)
         (compile-application exp module lexical-env compile))
        (else
         (error "Unknown expression type -- COMPILE" exp))))

;;;simple expressions

(define (compile-self-evaluating exp)
  (cond ((integer? exp)
         `(i32.const ,exp))
        (else
         (error "Unsupported value" exp))))

(define (compile-quoted exp)
  (error "Quote not supported yet" exp))

(define (compile-variable exp lexical-env)
  (let*
      ((lexical-address (find-variable exp lexical-env))
       (get-instr
        (cond
          ((eq? lexical-address 'not-found)
           (error "Lexically unbound variable" exp))
          ((global-address? lexical-address) 'get_global)
          ((= (frame-index lexical-address) 0) 'get_local)
          (else
           (error "Variables in immediate enclosing scope or top-level only supported" exp)))))
    `(,get-instr ,(var-index lexical-address))))

(define (compile-assignment exp module lexical-env compile)
  (let*
      ((lexical-address (find-variable (assignment-variable exp) lexical-env))
       (value-code
        (compile (assignment-value exp) module lexical-env))
       (set-instr
        (cond
          ((eq? lexical-address 'not-found)
           (error "Lexically unbound variable" exp))
          ((global-address? lexical-address) 'set_global)
          ((= (frame-index lexical-address) 0) 'set_local)
          (else
           (error "Variables in immediate enclosing scope or top-level only supported" exp)))))
    (append
     value-code
     `(,set-instr ,(var-index lexical-address)))))

(define (compile-definition exp module lexical-env compile)
  (if (global-lexical-env? lexical-env)
      (let ((value-code
             (compile (definition-value exp) module lexical-env)))
        ((module 'add-definition!)
         `(global (mut i32) ,value-code))
        ; Definition does not generate any value
        '())
      (error "Only top-level define is supported" exp)))

;;;open-coded primitives

(define open-coded-primitives-to-machine-ops
  '((+ (i32.add))
    (- (i32.sub))
    (* (i32.mul))
    (/ (i32.div_s))
    (= (i32.eq))
    (< (i32.lt_s))))

(define (open-coded-primitive-application? exp)
  (and (application? exp)
       (assoc (operator exp) open-coded-primitives-to-machine-ops)))

(define (compile-open-coded-primitive exp module lexical-env compile)
  (let ((op (cadr (assoc (operator exp) open-coded-primitives-to-machine-ops))))
    (define (compile-rest-arguments operands)
      (let ((code-to-compute-next-operand-to-stack
             (compile (car operands) module lexical-env)))
        (append
         code-to-compute-next-operand-to-stack
         (if (null? (cdr operands))
             op
             (append op (compile-rest-arguments (cdr operands)))))))
    (let ((operands (operands exp)))
      (append
       (compile (car operands) module lexical-env)
       (compile-rest-arguments (cdr operands))))))

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
        (a-code (compile (if-alternative exp) module lexical-env)))
    (append
     p-code
     '(if (result i32))
     c-code
     '(else)
     a-code
     '(end))))

;;; sequences

(define (compile-sequence seq module lexical-env compile)
  (if (last-exp? seq)
      (compile (first-exp seq) module lexical-env)
      (append
       (compile (first-exp seq) module lexical-env)
       (compile-sequence (rest-exps seq) module lexical-env compile))))

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
