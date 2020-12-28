#!r6rs
;; Adapted from SICP ch5-syntax.scm

(library
 (scheme-syntax)

 (export
         variable?
         definition? definition-variable
         check-binding
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
(define syntax-error-patterns
  (list
   ;; quote
   (list '(quote) "Too few operands")
   (list `(quote ,?? ,?? ,??*) "Too many operands")
   ;; assignment
   (list '(set!) "Variable and value missing from assignment")
   (list `(set! ,??) "Variable or value missing from assignment")
   (list `(set! ,?? ,?? ,?? ,??*) "Too many operands to assignment")
   (list `(set! ,not-variable? ,??) "Invalid variable in assignment")
   ;: lambda expression
   (list `(lambda) "Arguments and body missing from lambda expression")
   (list `(lambda ,??) "Body missing from lambda expression")
   (list `(lambda ,?? ,??) "Arguments list missing from lambda expression")
   ;: definition
   (list '(define) "Variable and value missing from definition")
   (list `(define (,?? ,??*)) "Empty body in procedure definition")
   (list `(define ,??) "Variable or value missing from definition")
   (list `(define ,variable? ,?? ,?? ,??*) "Too many operands to variable definition")
   (list `(define () ,??*) "Variable missing from procedure definition")
   (list `(define (,not-variable? ,??*) ,??*) "Not an identifier in variable position")
   (list `(define ,not-variable? ,??) "Not an identifier in variable position")
   (list `(define ,?? ,?? ,?? ,??*) "Not a variable or procedure definition")
   ;; if expression
   (list '(if) "Test and consequent missing from if expression")
   (list `(if ,??) "Consequent missing from if expression")
   (list `(if ,?? ,?? ,?? ,??*) "Too many subexpressions in if expression")
   ;; not expression
   (list `(not) "Argument missing from not expression")
   (list `(not ,?? ,??*) "Too many arguments in not expression")
   ;; let expressions
   (list `(let () ,?? ,??*) "Empty bindings in let expression")
   (list `(let ,?? ,?? ,??*) "Bindings missing from let expression")
   (list `(let ,??) "Bindings or body missing from let expression")
   (list `(let) "Bindings and body missing from let expression")
   (list `(let* () ,?? ,??*) "Empty bindings in let* expression")
   (list `(let* ,?? ,?? ,??*) "Bindings missing from let* expression")
   (list `(let* ,??) "Bindings or body missing from let* expression")
   (list `(let*) "Bindings and body missing from let* expression")
   (list '(begin) "Empty sequence")))

(define (check-syntax-errors exp)
  (for-each
   (lambda (pattern-and-message)
     (raise-error-on-match (car pattern-and-message) exp (cadr pattern-and-message) exp))
   syntax-error-patterns)
  #f)

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
