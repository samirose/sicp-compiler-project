(import (compiler-test)
	(assignment))

(compiler-test-begin "assignment")

(compiler-test-eq
 "set! assigns new value to lambda argument"
 13 (set!-local-lambda))

(compiler-test-eq
 "set! assigns new value to let binding"
 13 (set!-local-let))

(compiler-test-eq
 "set! assigns new value to top-level binding"
 13 (set!-global))

(compiler-test-eq
 "top-level set! assgins value to top-level binding"
 5 (get-global))

(compiler-test-invoke increment-global!)
(compiler-test-eq
 "incrementing set! of top-level binding increments the binding's value"
 6 (get-global))

(compiler-test-invoke increment-global!)
(compiler-test-eq
 "each incrementing set! of top-level binding increments the binding's value"
 7 (get-global))

(compiler-test-eq
 "top-level set! value can be computed with a lambda"
 22 (get-lambda-computed-global))

(compiler-test-end "assignment")
