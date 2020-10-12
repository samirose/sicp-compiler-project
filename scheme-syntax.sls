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

(define (match-or-error pat exp message object)
  (cond ((pattern-match pat exp) #t)
        (else (raise-compilation-error message object))))

(define (raise-error-on-match pat exp message)
  (if (pattern-match pat exp)
      (raise-compilation-error message exp)
      #t))

;; quote
(define (quoted? exp)
  (and (pattern-match `(quote ,??*) exp)
       (raise-error-on-match
        '(quote) exp "Too few operands")
       (raise-error-on-match
        `(quote ,?? ,?? ,??*) exp "Too many operands")))

(define (text-of-quotation exp) (cadr exp))

(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      #f))

;; assignment
(define (variable? exp) (symbol? exp))

(define (assignment? exp)
  (and (pattern-match `(set! ,??*) exp)
       (raise-error-on-match
        '(set!) exp "Variable and value missing from assignment")
       (raise-error-on-match
        `(set! ,??) exp "Variable or value missing from assignment")
       (raise-error-on-match
        `(set! ,?? ,?? ,?? ,??*) exp "Too many operands to assignment")
       (match-or-error
        `(set! ,variable? ,??) exp
        "Not an identifier" (assignment-variable exp))))

(define (assignment-variable exp) (cadr exp))

(define (assignment-value exp) (caddr exp))


(define (definition? exp)
  (tagged-list? exp 'define))

(define (definition-variable exp)
  (if (symbol? (cadr exp))
      (cadr exp)
      (caadr exp)))

(define (definition-value exp)
  (if (symbol? (cadr exp))
      (caddr exp)
      (make-lambda (cdadr exp)
                   (cddr exp))))

(define (lambda? exp) (tagged-list? exp 'lambda))

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
