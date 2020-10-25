#!r6rs
(import
 (rnrs base)
 (scheme-syntax)
 (assert))

(install-test-compilation-error-handler!)

;; quoted
(assert-equal
 #t
 (quoted? '(quote x))
 "Quote with single value is valid")

(assert-equal
 #t
 (quoted? '(quote (a b)))
 "Quote with single list is valid")

(assert-equal
 'x
 (text-of-quotation '(quote x))
 "text-of-quotation returns a single value")

(assert-equal
 '(a b)
 (text-of-quotation '(quote (a b)))
 "text-of-quotation returns a single list value")

(assert-raises-compilation-error
 (lambda () (quoted? '(quote)))
 "Too few operands" '(quote)
 "Quote without values raises an error")

(assert-raises-compilation-error
 (lambda () (quoted? '(quote x y)))
 "Too many operands" '(quote x y)
 "Quote with multiple values raises an error")

;; assignment
(assert-equal
 #t
 (assignment? '(set! x 1))
 "Assignment with variable and simple expression is valid")

(assert-equal
 #t
 (assignment? '(set! x (+ 1 x)))
 "Assignment with variable and combination expression is valid")

(assert-equal
 'x
 (assignment-variable '(set! x 1))
 "assignment-variable variable returns the assignment's variable")

(assert-equal
 '1
 (assignment-value '(set! x 1))
 "assignment-value returns assignment's simple value")

(assert-equal
 '(+ 1 x)
 (assignment-value '(set! x (+ 1 x)))
 "assignment-value returns assignment's combination value")

(assert-raises-compilation-error
 (lambda () (assignment? '(set! x)))
 "Variable or value missing from assignment" '(set! x)
 "Assignment without value raises an error")

(assert-raises-compilation-error
 (lambda () (assignment? '(set! 1 2)))
 "Not an identifier" 1
 "Assignment's second operand must be an identifier")

(assert-raises-compilation-error
 (lambda () (assignment? '(set! x 1 2)))
 "Too many operands to assignment" '(set! x 1 2)
 "Assignment with too many operands raises an error")

;; definition
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
   "definition-value returns the value of variable definition"))

(let ((exp '(define (zero) 0)))
  (assert-equal
   #t
   (definition? exp)
   "Procedure definition with zero parameters and simple body is valid")

  (assert-equal
   'zero
   (definition-variable exp)
   "definition-variable returns the variable for procedure definition")

  (assert-equal
   '(lambda () 0)
   (definition-value exp)
   "definition-value returns a lambda of procedure definition body"))

(let ((exp '(define (one) (+ 0 1))))
  (assert-equal
   #t
   (definition? exp)
   "Procedure definition with zero parameters and combination body is valid")

  (assert-equal
   'one
   (definition-variable exp)
   "definition-variable returns the variable for procedure definition")

  (assert-equal
   '(lambda () (+ 0 1))
   (definition-value exp)
   "definition-value returns a lambda of procedure definition body"))

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
   "definition-value returns a lambda of procedure definition body"))

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
   "definition-value returns a lambda of procedure definition body"))

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
   "definition-value returns a lambda of procedure definition body"))

(assert-raises-compilation-error
 (lambda () (definition? '(define)))
 "Variable and value missing from definition" '(define)
 "Definition without variable and value raises an error")

(assert-raises-compilation-error
 (lambda () (definition? '(define x)))
 "Variable or value missing from definition" '(define x)
 "Definition only one operand raises an error")

(assert-raises-compilation-error
 (lambda () (definition? '(define 1 42)))
 "Not an identifier" 1
 "Variable definition's first operand must be an identifier")

(assert-raises-compilation-error
 (lambda () (definition? '(define x 1 2)))
 "Too many operands to variable definition" '(define x 1 2)
 "Variable definition should have only variable and value operands")

(assert-raises-compilation-error
 (lambda () (definition? '(define x '(a b) 1)))
 "Too many operands to variable definition" '(define x '(a b) 1)
 "Variable definition should have only variable and value operands")

(assert-raises-compilation-error
 (lambda () (definition? '(define () 42)))
 "Variable missing from procedure definition" '(define () 42)
 "Procedure definition should specify variable for the procedure")

(assert-raises-compilation-error
 (lambda () (definition? '(define () 42)))
 "Variable missing from procedure definition" '(define () 42)
 "Procedure definition should specify variable for the procedure")

(assert-raises-compilation-error
 (lambda () (definition? '(define (x))))
 "Empty body in procedure definition" '(define (x))
 "Procedure definition should specify a body for the procedure")

(assert-raises-compilation-error
 (lambda () (definition? '(define (1) 42)))
 "Not an identifier" 1
 "Procedure variable should be an identifier")

(assert-raises-compilation-error
 (lambda () (definition? '(define (x y 2) (+ x y 2))))
 "Not an identifier" 2
 "Procedure formal parameters should be identifiers")

(assert-raises-compilation-error
 (lambda () (definition? '(define 1 2 3)))
 "Not a variable or procedure definition" '(define 1 2 3)
 "Definition's first operand should be an identifier or an identifier list")

;; lambda expression
(assert-equal
 #t
 (lambda? '(lambda () 42))
 "Lambda expression with empty arguments list and single-expression body is valid")

(assert-equal
 #t
 (lambda? '(lambda () (+ 1 2)))
 "Lambda expression with empty arguments list and combination body is valid")

(assert-equal
 #t
 (lambda? '(lambda () 1 2))
 "Lambda expression with empty arguments list and multi-expression body is valid")

(assert-equal
 #t
 (lambda? '(lambda (x) x))
  "Lambda expression with one argument and single-expression body is valid")

(assert-equal
 #t
 (lambda? '(lambda (x) (+ x 1)))
  "Lambda expression with one argument and combination body is valid")

(assert-equal
 #t
 (lambda? '(lambda (a b) (set! a (+ a 1)) (+ a b)))
  "Lambda expression with one argument and multi-expression body is valid")

(assert-raises-compilation-error
 (lambda () (lambda? '(lambda ())))
 "Body missing from lambda expression" '(lambda ())
 "Lambda expression must define a body")

(assert-raises-compilation-error
 (lambda () (lambda? '(lambda (x))))
 "Body missing from lambda expression" '(lambda (x))
 "Lambda expression must define a body")

(assert-raises-compilation-error
 (lambda () (lambda? '(lambda x)))
 "Body missing from lambda expression" '(lambda x)
 "Lambda expression must define a body")

(assert-raises-compilation-error
 (lambda () (lambda? '(lambda a a)))
 "Arguments list missing from lambda expression" '(lambda a a)
 "Lambda expressions must define an argument list (list argument forms are not yet supported)")

(assert-raises-compilation-error
 (lambda () (lambda? '(lambda (x 1) (+ x 1))))
 "Not an identifier" 1
 "Lambda arguments must be identifiers")

;; if expression
(assert-equal
 #t
 (if? '(if 1 #t))
 "If with simple test and consequent is valid")

(assert-equal
 #t
 (if? '(if 1 #t #f))
 "If with simple test, consequent and alternative is valid")

(assert-equal
 #t
 (if? '(if (< x 0) (set! x (+ x 1))))
 "If with composite test and consequent is valid")

(assert-equal
 #t
 (if? '(if (< x 0) (begin (set! y x) (+ x 1)) (- x 1)))
 "If with composite test, consequent and alternative is valid")

(assert-raises-compilation-error
 (lambda () (if? '(if)))
 "Test and consequent missing from if expression" '(if)
 "If expression must contain at least test and consequent subexpressions")

(assert-raises-compilation-error
 (lambda () (if? '(if (= x 0))))
 "Consequent missing from if expression" '(if (= x 0))
 "If expression must contain at least test and consequent subexpressions")

(assert-raises-compilation-error
 (lambda () (if? '(if (= x 0) 1 2 3)))
 "Too many subexpressions in if expression" '(if (= x 0) 1 2 3)
 "If expression must not contain more subexpressions than test, consequent and alternative")

(assert-raises-compilation-error
 (lambda () (if? '(if (= x 0) 1 2 3 4)))
 "Too many subexpressions in if expression" '(if (= x 0) 1 2 3 4)
 "If expression must not contain more subexpressions than test, consequent and alternative")

;; sequence
(assert-equal
 #t
 (begin? '(begin 42))
 "Sequence with one simple expression is valid")

(assert-equal
 #t
 (begin? '(begin (+ 1 2) 4 5))
 "Sequence with multiple expressions is valid")

(assert-raises-compilation-error
 (lambda () (begin? '(begin)))
 "Empty sequence" '(begin)
 "Sequence without expressions is invalid")

;; application
(assert-equal
 #t
 (application? '(proc))
 "Procedure application without parameters is valid")

(assert-equal
 #t
 (application? '(proc 1))
 "Procedure application with one simple parameter is valid")

(assert-equal
 #t
 (application? '(proc (+ x 1)))
 "Procedure application with one combination parameter is valid")

(assert-equal
 #t
 (application? '(proc 1 (+ x 1) 3))
 "Procedure application with multiple parameters is valid")

(assert-raises-compilation-error
 (lambda () (application? '()))
 "No operator in application" '()
 "Application must contain at least an operator")
