#!r6rs
;; Adapted from SICP ch5-syntax.scm

(library
 (scheme-syntax)

 (export
         quoted? text-of-quotation
         variable?
         assignment? assignment-variable assignment-value
         definition? definition-variable definition-value
         let? let*? let-bindings binding-variable binding-value let-body
         lambda? lambda-formals lambda-body
         if? if-test if-consequent if-alternate
         not? not-expression and? and-expressions or? or-expressions
         begin? begin-actions last-exp? first-exp rest-exps
         application? operator operands)

 (import (rnrs base)
         (rnrs lists)
         (pattern-match)
         (compilation-error))

(define (raise-error-on-match pat exp message object)
  (if (pattern-match? pat exp)
      (raise-compilation-error message object)
      #f))

;; quote
(define (quoted? exp)
  (cond ((not (pattern-match? `(quote ,??*) exp)) #f)
        ((pattern-match? `(quote ,??) exp))
        ((raise-error-on-match '(quote) exp "Too few operands" exp))
        ((raise-error-on-match `(quote ,?? ,?? ,??*) exp "Too many operands" exp))
        (else (error "Internal compiler error: unexhaustive quote syntax check" exp))))

(define (text-of-quotation exp) (cadr exp))

;; assignment
(define (variable? exp) (symbol? exp))
(define (not-variable? exp) (not (variable? exp)))

(define (assignment? exp)
  (cond ((not (pattern-match? `(set! ,??*) exp)) #f)
        ((pattern-match? `(set! ,variable? ,??) exp))
        ((raise-error-on-match
          '(set!) exp "Variable and value missing from assignment" exp))
        ((raise-error-on-match
          `(set! ,??) exp "Variable or value missing from assignment" exp))
        ((raise-error-on-match
          `(set! ,?? ,?? ,?? ,??*) exp "Too many operands to assignment" exp))
       ((raise-error-on-match
         `(set! ,not-variable? ,??) exp
         "Not an identifier" (assignment-variable exp)))
       (else (error "Internal compiler error: unexhaustive assignment syntax check" exp))))

(define (assignment-variable exp) (cadr exp))
(define (assignment-value exp) (caddr exp))

;; definition
(define (variable-definition? exp)
  (pattern-match? `(define ,variable? ,??) exp))

(define (check-all-identifiers exps)
  (cond ((null? exps))
        ((variable? (car exps)) (check-all-identifiers (cdr exps)))
        (else (raise-compilation-error "Not an identifier" (car exps)))))

(define (definition? exp)
  (cond ((not (pattern-match? `(define ,??*) exp)) #f)
        ((variable-definition? exp))
        ((pattern-match? `(define (,?? ,??*) ,?? ,??*) exp)
         (check-all-identifiers (cadr exp)))
        ((raise-error-on-match
          '(define) exp "Variable and value missing from definition" exp))
        ((raise-error-on-match
          `(define (,?? ,??*)) exp "Empty body in procedure definition" exp))
        ((raise-error-on-match
          `(define ,??) exp "Variable or value missing from definition" exp))
        ((raise-error-on-match
          `(define ,variable? ,?? ,?? ,??*) exp "Too many operands to variable definition" exp))
        ((raise-error-on-match
          `(define () ,??*) exp "Variable missing from procedure definition" exp))
        ((raise-error-on-match
          `(define ,?? ,??) exp "Not an identifier" (cadr exp)))
        ((raise-error-on-match
          `(define ,?? ,?? ,?? ,??*) exp "Not a variable or procedure definition" exp))
        (else (error "Internal compiler error: unexhaustive definition syntax check" exp))))

(define (definition-variable exp)
  (if (variable-definition? exp)
      (cadr exp)
      (caadr exp)))

(define (definition-value exp)
  (if (variable-definition? exp)
      (caddr exp)
      (make-lambda (cdadr exp)
                   (cddr exp))))

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

;; lambda expression
(define (lambda? exp)
  (cond ((not (pattern-match? `(lambda ,??*) exp)) #f)
        ((pattern-match? `(lambda (,??*) ,?? ,??*) exp)
         (check-all-identifiers (lambda-formals exp)))
        ((raise-error-on-match
          `(lambda) exp "Arguments and body missing from lambda expression" exp))
        ((raise-error-on-match
          `(lambda ,??) exp "Body missing from lambda expression" exp))
        ((raise-error-on-match
          `(lambda ,?? ,??) exp "Arguments list missing from lambda expression" exp))
        (else (error "Internal compiler error: unexhaustive lambda syntax check" exp))))

(define (lambda-formals exp) (cadr exp))
(define (lambda-body exp) (cddr exp))

(define (make-lambda parameters body)
  (cons 'lambda (cons parameters body)))

;; if expression
(define (if? exp)
  (cond ((not (pattern-match? `(if ,??*) exp)) #f)
        ((pattern-match? `(if ,?? ,?? ,??) exp))
        ((pattern-match? `(if ,?? ,??) exp))
        ((raise-error-on-match
          '(if) exp "Test and consequent missing from if expression" exp))
        ((raise-error-on-match
          `(if ,??) exp "Consequent missing from if expression" exp))
        ((raise-error-on-match
          `(if ,?? ,?? ,?? ,??*) exp "Too many subexpressions in if expression" exp))
        (else (error "Internal compiler error: unexhaustive if expression syntax check" exp))))

(define (if-test exp) (cadr exp))
(define (if-consequent exp) (caddr exp))
(define (if-alternate exp)
  (if (pattern-match? `(if ,?? ,?? ,??) exp)
      (cadddr exp)
      #f))

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
