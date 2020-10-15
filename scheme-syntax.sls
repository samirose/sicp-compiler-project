#!r6rs
;; Adapted from SICP ch5-syntax.scm

(library (scheme-syntax)
  (export self-evaluating?
          quoted? text-of-quotation
          variable?
          assignment? assignment-variable assignment-value
          definition? definition-variable definition-value
          lambda? lambda-formals lambda-body
          if? if-predicate if-consequent if-alternative
          begin? begin-actions last-exp? first-exp rest-exps
          application? operator operands)
  (import (rnrs base)
          (compilation-error)
          (pattern-match))

(define (self-evaluating? exp)
  (cond ((number? exp) #t)
        ((boolean? exp) #t)
        ((string? exp) #t)
        (else #f)))

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

(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      #f))

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
  (cond
    ((not (pattern-match? `(define ,??*) exp)) #f)
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

(define (if? exp) (tagged-list? exp 'if))

(define (if-predicate exp) (cadr exp))

(define (if-consequent exp) (caddr exp))

(define (if-alternative exp)
  (if (not (null? (cdddr exp)))
      (cadddr exp)
      #f))


(define (begin? exp) (tagged-list? exp 'begin))
(define (begin-actions exp) (cdr exp))

(define (last-exp? seq) (null? (cdr seq)))
(define (first-exp seq) (car seq))
(define (rest-exps seq) (cdr seq))

(define (application? exp) (pair? exp))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))

(define (no-operands? ops) (null? ops))
(define (first-operand ops) (car ops))
(define (rest-operands ops) (cdr ops))

)
