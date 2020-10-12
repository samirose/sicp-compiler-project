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
(assert-equal
 #t
 (definition? '(define x 42))
 "Variable definition with variable and simple value is valid")

(assert-equal
 #t
 (definition? '(define x (+ 1 2)))
 "Variable definition with variable and combination value is valid")

(assert-equal
 #t
 (definition? '(define (zero) 0))
 "Procedure definition with zero arguments and simple body is valid")

(assert-equal
 #t
 (definition? '(define (one) (+ 0 1)))
 "Procedure definition with zero arguments and combination body is valid")

(assert-equal
 #t
 (definition? '(define (one) (display "one:") (+ 0 1)))
 "Procedure definition with multi-expression body is valid")

(assert-equal
 #t
 (definition? '(define (square x) (* x x)))
 "Procedure definition with single parameter and body is valid")

(assert-equal
 #t
 (definition? '(define (sum-of-squares x y) (+ (* x x) (* y y))))
 "Procedure definition with multiple parameters and body is valid")

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