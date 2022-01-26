#!r6rs
(import
 (rnrs base)
 (rnrs lists)
 (scheme-syntax)
 (assert))

(install-test-compilation-error-handler!)

;; definition
(assert-equal
 #f
 (definition? '(+ 1 2))
 "Non-definition is not a definition")

(assert-equal
 #f
 (definition? '(define x))
 "Variable definition without a value is not a definition")

(assert-equal
 #f
 (definition? '(define x))
 "Variable definition without a value is not a definition")

(assert-equal
 #f
 (definition? '(define x 1 1))
 "Variable definition with multiple values a value is not a definition")

(assert-equal
 #f
 (definition? '(define (f x)))
 "Procedure definition without a body is not a definition")

(let ((exp '(define x 42)))
  (assert-equal
   #t
   (definition? exp)
   "Variable definition with variable and simple value is valid")

  (assert-equal
   'x
   (definition-variable exp)
   "definition-variable returns the variable of variable definition")

  (assert-equal
   42
   (definition-value exp)
   "definition-value returns the value of variable definition"))

(let ((exp '(define x (+ 1 2))))
  (assert-equal
   #t
   (definition? exp)
   "Variable definition with variable and combination value is valid")

  (assert-equal
   'x
   (definition-variable exp)
   "definition-variable returns the variable of variable definition")

  (assert-equal
   '(+ 1 2)
   (definition-value exp)
   "definition-value returns the value expression of variable definition"))

(let ((exp '(define (zero) 0)))
  (assert-equal
   #t
   (definition? exp)
   "Procedure definition with zero parameters and simple body is valid")

  (assert-equal
   'zero
   (definition-variable exp)
   "definition-variable returns the variable of procedure definition")

  (assert-equal
   '(lambda () 0)
   (definition-value exp)
   "definition-value returns the body of procedure definition"))

(let ((exp '(define (one) (+ 0 1))))
  (assert-equal
   #t
   (definition? exp)
   "Procedure definition with zero parameters and combination body is valid")

  (assert-equal
   'one
   (definition-variable exp)
   "definition-variable returns the variable of procedure definition")

  (assert-equal
   '(lambda () (+ 0 1))
   (definition-value exp)
   "definition-value returns the body of procedure definition"))

(let ((exp '(define (one) (display "one:") (+ 0 1))))
  (assert-equal
   #t
   (definition? exp)
   "Procedure definition with multi-expression body is valid")

  (assert-equal
   'one
   (definition-variable exp)
   "definition-variable returns the variable for procedure definition")

  (assert-equal
   '(lambda () (display "one:") (+ 0 1))
   (definition-value exp)
   "definition-value returns the body of procedure definition"))

(let ((exp '(define (square x) (* x x))))
  (assert-equal
   #t
   (definition? exp)
   "Procedure definition with single parameter and body is valid")

  (assert-equal
   'square
   (definition-variable exp)
   "definition-variable returns the variable for procedure definition")

  (assert-equal
   '(lambda (x) (* x x))
   (definition-value exp)
   "definition-value returns the body of procedure definition"))

(let ((exp '(define (sum-of-squares x y) (+ (* x x) (* y y)))))
  (assert-equal
   #t
   (definition? exp)
   "Procedure definition with multiple parameters and body is valid")

  (assert-equal
   'sum-of-squares
   (definition-variable exp)
   "definition-variable returns the variable for procedure definition")

    (assert-equal
   '(lambda (x y) (+ (* x x) (* y y)))
   (definition-value exp)
   "definition-value returns the body of procedure definition"))
