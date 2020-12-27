#!r6rs
(import
 (rnrs base)
 (rnrs lists)
 (scheme-syntax)
 (assert))

(install-test-compilation-error-handler!)

;; definition
(let ((exp '(define x 42)))
  (assert-equal
   #t
   (definition? exp)
   "Variable definition with variable and simple value is valid")

  (assert-equal
   'x
   (definition-variable exp)
   "definition-variable returns the variable of variable definition"))

(let ((exp '(define x (+ 1 2))))
  (assert-equal
   #t
   (definition? exp)
   "Variable definition with variable and combination value is valid")

  (assert-equal
   'x
   (definition-variable exp)
   "definition-variable returns the variable of variable definition"))

(let ((exp '(define (zero) 0)))
  (assert-equal
   #t
   (definition? exp)
   "Procedure definition with zero parameters and simple body is valid")

  (assert-equal
   'zero
   (definition-variable exp)
   "definition-variable returns the variable for procedure definition"))

(let ((exp '(define (one) (+ 0 1))))
  (assert-equal
   #t
   (definition? exp)
   "Procedure definition with zero parameters and combination body is valid")

  (assert-equal
   'one
   (definition-variable exp)
   "definition-variable returns the variable for procedure definition"))

(let ((exp '(define (one) (display "one:") (+ 0 1))))
  (assert-equal
   #t
   (definition? exp)
   "Procedure definition with multi-expression body is valid")

  (assert-equal
   'one
   (definition-variable exp)
   "definition-variable returns the variable for procedure definition"))

(let ((exp '(define (square x) (* x x))))
  (assert-equal
   #t
   (definition? exp)
   "Procedure definition with single parameter and body is valid")

  (assert-equal
   'square
   (definition-variable exp)
   "definition-variable returns the variable for procedure definition"))

(let ((exp '(define (sum-of-squares x y) (+ (* x x) (* y y)))))
  (assert-equal
   #t
   (definition? exp)
   "Procedure definition with multiple parameters and body is valid")

  (assert-equal
   'sum-of-squares
   (definition-variable exp)
   "definition-variable returns the variable for procedure definition"))

;; sequence
(let ((exp '(begin 42)))
  (assert-equal
   #t
   (begin? exp)
   "Sequence with one simple expression is valid")

  (let ((seq (begin-actions exp)))
    (assert-equal
     '(42)
     seq
     "begin-actions returns begin form's expression sequence")

    (assert-equal
     42
     (first-exp seq)
     "first-exp returns begin form sequence's first expression")

    (assert-equal
     '()
     (rest-exps seq)
     "rest-exps returns begin form sequence's expressions after the first")

    (assert-equal
     #t
     (last-exp? seq)
     "last-exp? returns true for begin form sequence's last expression")))

(let ((exp '(begin (+ 1 2) 4 5)))
  (assert-equal
   #t
   (begin? exp)
   "Sequence with multiple expressions is valid")

  (let ((seq (begin-actions exp)))
    (assert-equal
     '(+ 1 2)
     (first-exp seq)
     "first-exp returns begin form sequence's first expression")

    (assert-equal
     '(4 5)
     (rest-exps seq)
     "rest-exps returns begin form sequence's expressions after the first")

    (assert-equal
     #f
     (last-exp? seq)
     "last-exp? returns true for begin form sequence's last expression")

    (let ((seq (rest-exps seq)))
      (assert-equal
       4
       (first-exp seq)
       "first-exp returns begin form sequence's first expression")

      (assert-equal
       '(5)
       (rest-exps seq)
       "rest-exps returns begin form sequence's expressions after the first")

      (assert-equal
       #f
       (last-exp? seq)
       "last-exp? returns true for begin form sequence's last expression")

      (let ((seq (rest-exps seq)))
        (assert-equal
         5
         (first-exp seq)
         "first-exp returns begin form sequence's first expression")

        (assert-equal
         '()
         (rest-exps seq)
         "rest-exps returns begin form sequence's expressions after the first")

        (assert-equal
         #t
         (last-exp? seq)
         "last-exp? returns true for begin form sequence's last expression")))))

(assert-raises-compilation-error
 (lambda () (begin? '(begin)))
 "Empty sequence" '(begin)
 "Sequence without expressions is invalid")

;; application
(let ((exp '(proc)))
  (assert-equal
   #t
   (application? exp)
   "Procedure application without parameters is valid")

  (assert-equal
   'proc
   (operator exp)
   "operator returns procedure application's operator")

  (assert-equal
   '()
   (operands exp)
   "operands returns procedure application's operands"))

(let ((exp '(proc 1)))
  (assert-equal
   #t
   (application? exp)
   "Procedure application with one simple parameter is valid")

  (assert-equal
   'proc
   (operator exp)
   "operator returns procedure application's operator")

  (assert-equal
   '(1)
   (operands exp)
   "operands returns procedure application's operands"))

(let ((exp '(proc (+ x 1))))
  (assert-equal
   #t
   (application? exp)
   "Procedure application with one combination parameter is valid")

  (assert-equal
   'proc
   (operator exp)
   "operator returns procedure application's operator")

  (assert-equal
   '((+ x 1))
   (operands exp)
   "operands returns procedure application's operands"))

(let ((exp '(m-proc 1 (+ x 1) 3)))
  (assert-equal
   #t
   (application? exp)
   "Procedure application with multiple parameters is valid")

  (assert-equal
   'm-proc
   (operator exp)
   "operator returns procedure application's operator")

  (assert-equal
   '(1 (+ x 1) 3)
   (operands exp)
   "operands returns procedure application's operands"))

(assert-raises-compilation-error
 (lambda () (application? '()))
 "No operator in application" '()
 "Application must contain at least an operator")
