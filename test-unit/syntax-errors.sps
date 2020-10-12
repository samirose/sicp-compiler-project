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
 "Assignment with variable and expression is valid")

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
