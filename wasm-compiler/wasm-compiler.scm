#lang sicp
(#%require "scheme-syntax.scm")
(#%require "wasm-definitions-table.scm")
(#%require "wasm-syntax.scm")
(#%require "lists.scm")
(#%provide compile-to-wasm-module)

;;;; SCHEME to WAT (WebAssembly Text format) compiler written in Racket

;; Currently supports compilation of:
;; * 32-bit integer values
;; * Open-coded compilation of application of + - * / = operators

;;;; BASED ON COMPILER FROM SECTION 5.5 OF
;;;; STRUCTURE AND INTERPRETATION OF COMPUTER PROGRAMS

(define (compile-to-wasm-module exp)
  (let* ((module (make-wasm-definitions-table))
         (top-level-code (compile exp module '()))
         (elem-def? (lambda (def) (wasm-definition-type? 'elem def)))
         (elem-defs (filter elem-def? (module 'definitions)))
         (non-elem-defs (reject elem-def? (module 'definitions)))
         (elem-func-indices (map wasm-elem-definition-func-index elem-defs)))
    `(module
       ,@non-elem-defs
       (table ,scheme-procedures-table-id ,(length elem-func-indices) funcref)
       (elem ,scheme-procedures-table-id (i32.const 0) func ,@elem-func-indices)
       (func $main (result i32)
             ,@top-level-code)
       (export "main" (func $main)))))

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

; From solution exercise 5.39
(define (make-lexical-address frame-index var-index)
  (cons frame-index var-index))

(define (frame-index lexical-address)
  (car lexical-address))

(define (var-index lexical-address)
  (cdr lexical-address))

; From solution to exercise 5.41
(define (find-variable var lexical-env)
  (define (scan env frame frame-index var-index)
    (if (null? frame)
        (if (null? (cdr env))
            'not-found
            (scan (cdr env) (cadr env) (+ frame-index 1) 0))
        (if (eq? (car frame) var)
            (make-lexical-address frame-index var-index)
            (scan env (cdr frame) frame-index (+ var-index 1)))))
  (if (null? lexical-env)
      'not-found
      (scan lexical-env (car lexical-env) 0 0)))

(define (compile-variable exp lexical-env)
  (let ((lexical-address (find-variable exp lexical-env)))
    (if (eq? lexical-address 'not-found)
        (error "Lexically unbound variable" exp)
        (if (> (frame-index lexical-address) 0)
            (error "Variables in immediate enclosing frame only supported" exp)
            `(get_local ,(var-index lexical-address))))))

(define (compile-assignment exp module lexical-env compile)
  (let ((lexical-address (find-variable (assignment-variable exp))))
    (if (eq? lexical-address 'not-found)
        (error "Lexically unbound variable" exp)
        (if (> (frame-index lexical-address) 0)
            (error "Variables in immediate enclosing frame only supported" exp)
            (append
             (compile (assignment-value exp) module lexical-env)
             `(set_local ,(var-index lexical-address)))))))

(define (compile-definition exp module lexical-env compile)
  (error "Definitions not supported yet" exp))

;;;open-coded primitives

(define open-coded-primitives-to-machine-ops
  '((+ (i32.add))
    (- (i32.sub))
    (* (i32.mul))
    (/ (i32.div))
    (= (i32.eq))))

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

(define (make-scheme-procedure-param-list arity)
  (if (= 0 arity)
      '()
      (cons 'param
            (make-list scheme-procedure-param-type arity))))

(define (add-scheme-procedure-type-definition module arity)
  (let* ((type-id (make-scheme-procedure-type-id arity))
         (type-definition
          `(type ,type-id (func ,(make-scheme-procedure-param-list arity) (result i32)))))
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
                    (lambda-body exp) module (cons formals lexical-env) compile)))
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
