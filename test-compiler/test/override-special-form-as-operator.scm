(import (compiler-test)
	(override-special-form-as-operator))

(compiler-test-begin "override-special-form-as-operator")

(compiler-test-eq
 "let binding can override quote"
 42 (override-quote-let))

(compiler-test-eq
 "procedure parameter can override quote"
 42 (override-quote-arg))

(compiler-test-eq
 "let binding can override define"
 42 (override-define-let))

(compiler-test-eq
 "procedure parameter can override define"
 42 (override-define-arg))

(compiler-test-eq
 "let binding can override lambda"
 42 (override-lambda-let))

(compiler-test-eq
 "procedure parameter can override lambda"
 42 (override-lambda-arg))

(compiler-test-eq
 "let* bindings can override special symbols"
 42 (override-special-symbols-let*))

(compiler-test-end "override-special-form-as-operator")
