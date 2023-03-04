(import (compiler-test)
	(recursive-definition))

(compiler-test-begin "recursive-definition")

(compiler-test-eq
 "gcd of 42 and 0 is 42"
 42 (gcd-test 42 0))

(compiler-test-eq
 "gcd of -42 and 0 is 42"
 42 (gcd-test -42 0))

(compiler-test-eq
 "gcd of 0 and 42 is 42"
 42 (gcd-test 0 42))

(compiler-test-eq
 "gcd of 0 and -42 is 42"
 42 (gcd-test 0 -42))

(compiler-test-eq
 "gcd of 480 and 28 is 4"
 4 (gcd-test 480 28))

(compiler-test-eq
 "gcd of -480 and 28 is 4"
 4 (gcd-test -480 28))

(compiler-test-eq
 "gcd of 480 and -28 is 4"
 4 (gcd-test 480 -28))

(compiler-test-eq
 "gcd of -480 and -28 is 4"
 4 (gcd-test -480 -28))

(compiler-test-eq
 "gcd of 28 and 480 is 4"
 4 (gcd-test 28 480))

(compiler-test-end "recursive-definition")
