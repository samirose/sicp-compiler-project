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
