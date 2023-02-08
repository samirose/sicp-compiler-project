(import (compiler-test)
	(local-let))

(compiler-test-begin "local-let")

(compiler-test-eq
 "let bound to a constant expression evaluates to the constant's value"
 42 (constant-let))

(compiler-test-eq
 "let bound to an expression evaluates to the expression's value"
 30 (expression-let))

(compiler-test-eq
 "let can bind multiple variables"
 6 (multi-variable-let))

(compiler-test-eq
 "let can be nested"
 6 (nested-let))

(compiler-test-eq
 "inner let body can refer outer let bindings"
 6 (nested-let-referring-outer-let))

(compiler-test-eq
 "inner let bindings shadow outer let bindings"
 10 (let-shadowing-let))

(compiler-test-eq
 "let can be used in lambda body"
 10 (let-in-lambda))

(compiler-test-eq
 "let in lambda body can use lambda parameter bindings"
 18 (let-value-referring-lambda-arg))

(compiler-test-eq
 "let binding in lambda body shadows lambda parameter binding with the same name"
 36 (let-value-shadowing-lambda-arg))

(compiler-test-eq
 "let can bind a lambda expression"
 12 (lambda-as-let-value))

(compiler-test-eq
 "set! can be used to mutate let binding values"
 9 (mutate-locals))

(compiler-test-eq
 "let expression's value can be bound to a top-level binding"
 5 (get-global-with-let-value))

(compiler-test-eq
 "top-level set! can use a let expression value to mutate a top-level binding's value"
 9 (get-global-assigned-with-let-value))

(compiler-test-end "local-let")
