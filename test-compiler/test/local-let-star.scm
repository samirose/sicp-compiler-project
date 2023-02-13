(import (compiler-test)
	(local-let-star))

(compiler-test-begin "local-let-star")

(compiler-test-eq
 "let* bound to a constant expression evaluates to the constant's value"
 42 (constant-let*))

(compiler-test-eq
 "let* bound to an expression evaluates to the expression's value"
 30 (expression-let*))

(compiler-test-eq
 "later let* bindings shadow earlier bindings with the same name"
 10 (let*-shadowing))

(compiler-test-eq
 "let* can be used in lambda body"
 10 (let*-in-lambda))

(compiler-test-eq
 "let* in lambda body can use lambda parameter bindings"
 18 (let*-value-referring-lambda-arg))

(compiler-test-eq
 "let* binding in lambda body shadows lambda parameter binding with the same name"
 36 (let*-value-shadowing-lambda-arg))

(compiler-test-eq
 "let* can bind a lambda expression"
 12 (lambda-as-let*-value))

(compiler-test-eq
 "set! can be used to mutate let* binding values"
 13 (mutate-locals))

(compiler-test-eq
 "let* expression's value can be bound to a top-level binding"
 5 (get-global-with-let*-value))

(compiler-test-eq
 "top-level set! can use a let expression value to mutate a top-level binding's value"
 9 (get-global-assigned-with-let*-value))

(compiler-test-end "local-let-star")
