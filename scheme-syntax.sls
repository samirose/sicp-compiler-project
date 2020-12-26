#!r6rs
;; Adapted from SICP ch5-syntax.scm

(library
 (scheme-syntax)

 (export
         variable?
         definition? definition-variable
         let? let*? let-bindings binding-variable binding-value let-body
         not? not-expression and? and-expressions or? or-expressions
         begin? begin-actions last-exp? first-exp rest-exps
         application? operator operands
         check-all-identifiers check-syntax-errors)

 (import (rnrs base)
         (rnrs lists)
         (pattern-match)
         (compilation-error))

(define (raise-error-on-match pat exp message object)
  (if (pattern-match? pat exp)
      (raise-compilation-error message object)
      #f))

;; assignment
(define (variable? exp) (symbol? exp))
(define (not-variable? exp) (not (variable? exp)))

;; syntax errors
(define (check-syntax-errors exp)
  ;; quote
  (raise-error-on-match
   '(quote) exp "Too few operands" exp)
  (raise-error-on-match
   `(quote ,?? ,?? ,??*) exp "Too many operands" exp)
  ;; assignment
  (raise-error-on-match
   '(set!) exp "Variable and value missing from assignment" exp)
  (raise-error-on-match
   `(set! ,??) exp "Variable or value missing from assignment" exp)
  (raise-error-on-match
   `(set! ,?? ,?? ,?? ,??*) exp "Too many operands to assignment" exp)
  (raise-error-on-match
   `(set! ,not-variable? ,??) exp "Invalid variable in assignment" exp)
  ;: lambda expression
  (raise-error-on-match
   `(lambda) exp "Arguments and body missing from lambda expression" exp)
  (raise-error-on-match
   `(lambda ,??) exp "Body missing from lambda expression" exp)
  (raise-error-on-match
   `(lambda ,?? ,??) exp "Arguments list missing from lambda expression" exp)
  ;: definition
  (raise-error-on-match
   '(define) exp "Variable and value missing from definition" exp)
  (raise-error-on-match
   `(define (,?? ,??*)) exp "Empty body in procedure definition" exp)
  (raise-error-on-match
   `(define ,??) exp "Variable or value missing from definition" exp)
  (raise-error-on-match
   `(define ,variable? ,?? ,?? ,??*) exp "Too many operands to variable definition" exp)
  (raise-error-on-match
   `(define () ,??*) exp "Variable missing from procedure definition" exp)
  (raise-error-on-match
   `(define (,?? ,??*) ,??*) exp "Not an identifier in variable position" exp)
  (raise-error-on-match
   `(define ,?? ,??) exp "Not an identifier in variable position" exp)
  (raise-error-on-match
   `(define ,?? ,?? ,?? ,??*) exp "Not a variable or procedure definition" exp)
  ;; if expression
  (raise-error-on-match
    '(if) exp "Test and consequent missing from if expression" exp)
  (raise-error-on-match
   `(if ,??) exp "Consequent missing from if expression" exp)
  (raise-error-on-match
   `(if ,?? ,?? ,?? ,??*) exp "Too many subexpressions in if expression" exp))

(define (check-all-identifiers exps)
  (cond ((null? exps))
        ((variable? (car exps)) (check-all-identifiers (cdr exps)))
        (else (raise-compilation-error "Not an identifier" (car exps)))))

;; definition
(define (definition? exp)
  (or (pattern-match? `(define ,variable? ,??*) exp)
      (pattern-match? `(define (,variable? ,??*) ,??*) exp)))

(define (definition-variable exp)
  (if (pattern-match? `(define ,variable? ,??) exp)
      (cadr exp)
      (caadr exp)))

;; let expression
(define (check-binding exp)
  (cond ((pattern-match? `(,variable? ,??) exp))
        ((not (pattern-match? `(,??*) exp))
         (raise-compilation-error "Not a binding" exp))
        ((raise-error-on-match
          `(,?? ,??) exp "Not an identifier" (car exp)))
        ((raise-error-on-match
          `(,variable?) exp "Value missing from binding" exp))
        ((raise-error-on-match
          `(,variable? ,?? ,?? ,??*) exp "Too many operands in binding" exp))
        ((raise-error-on-match
          '() exp "Empty binding" exp))
        (else (raise-compilation-error "Not a binding" exp))))

(define (let-form? keyword exp)
  (if (not (pattern-match? `(,keyword ,??*) exp))
      #f
      (let ((args (cdr exp)))
        (cond
          ((pattern-match? `((,?? ,??*) ,?? ,??*) args)
           (for-all check-binding (car args)))
          ((raise-error-on-match
            `(() ,?? ,??*) args "Empty bindings in let expression" exp))
          ((raise-error-on-match
            `(,?? ,?? ,??*) args "Bindings missing from let expression" exp))
          ((raise-error-on-match
            `(,??) args "Bindings or body missing from let expression" exp))
          ((raise-error-on-match
            `() args "Bindings and body missing from let expression" exp))
          (else (error "Internal compiler error: unexhaustive let syntax check" exp))))))

(define (let? exp)
  (let-form? 'let exp))

(define (let*? exp)
  (let-form? 'let* exp))

(define (let-bindings exp) (cadr exp))
(define (binding-variable b) (car b))
(define (binding-value b) (cadr b))
(define (let-body exp) (cddr exp))

;; not expression
(define (not? exp)
  (cond ((not (pattern-match? `(not ,??*) exp)) #f)
        ((pattern-match? `(not ,??) exp))
        ((raise-error-on-match
          `(not ,?? ,??*) exp "Too many arguments in not expression" exp))))

(define (not-expression exp)
  (cadr exp))

;; and expression
(define (and? exp)
  (pattern-match? `(and ,??*) exp))

(define (and-expressions exp)
  (cdr exp))

;; or expression
(define (or? exp)
  (pattern-match? `(or ,??*) exp))

(define (or-expressions exp)
  (cdr exp))

;; sequence
(define (begin? exp)
  (cond ((not (pattern-match? `(begin ,??*) exp)) #f)
        ((pattern-match? `(begin ,?? ,??*) exp))
        ((raise-error-on-match
          '(begin) exp "Empty sequence" exp))
        (else (error "Internal compiler error: unexhaustive sequence syntax check" exp))))

(define (begin-actions exp) (cdr exp))
(define (last-exp? seq) (null? (cdr seq)))
(define (first-exp seq) (car seq))
(define (rest-exps seq) (cdr seq))

;; application
(define (application? exp)
  (cond ((not (pattern-match? `(,??*) exp)) #f)
        ((pattern-match? `(,?? ,??*) exp))
        ((raise-error-on-match
          '() exp "No operator in application" exp))
        (else (error "Internal compiler error: unexhaustive application syntax check"))))

(define (operator exp) (car exp))
(define (operands exp) (cdr exp))

)
