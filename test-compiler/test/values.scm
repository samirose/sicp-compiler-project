(import (compiler-test)
	(values))

(compiler-test-begin "values")

(compiler-test-eq
 "a number equals the same number"
 42 (number))

(compiler-test-eq
 "a quoted number equals the number"
 53 (quoted-number))

(compiler-test-eq
 "quoted number is a number"
 #t (quoted-number-is-number?))

(compiler-test-eq
 "true value equals true"
 #t (boolean-true))

(compiler-test-eq
 "false value equals false"
 #f (boolean-false))

(compiler-test-eq
 "quoted true value equals true"
 #t (quoted-boolean-true))

(compiler-test-eq
 "quoted false value equals false"
 #f (quoted-boolean-false))

(compiler-test-eq
 "quoted boolean is a boolean"
 #t (quoted-boolean-is-boolean?))

(compiler-test-end "values")
