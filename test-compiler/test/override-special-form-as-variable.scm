(import (compiler-test)
	(override-special-form-as-variable))

(compiler-test-begin "override-special-form-as-variable")

(compiler-test-eq
 "let binding can override quote"
 42 (override-quote-let))

(compiler-test-eq
 "procedure parameter can override quote"
 43 (override-quote-arg 42))

(compiler-test-eq
 "let binding can override define"
 42 (override-define-let))

(compiler-test-eq
 "procedure parameter can override define"
 43 (override-define-arg 42))

(compiler-test-eq
 "let binding can override lambda"
 42 (override-lambda-let))

(compiler-test-eq
 "procedure parameter can override lambda"
 43 (override-lambda-arg 42))

(compiler-test-eq
 "let* bindings can override special symbols"
 42 (override-special-symbols-let*))

(compiler-test-end "override-special-form-as-variable")
