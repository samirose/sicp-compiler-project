(import (compiler-test)
	(re-export))

(compiler-test-begin "re-export")

(compiler-test-expect-fail-host
 "Redefined number? is accessible and behaves like defined")

(compiler-test-eq
 "Redefined number? is accessible and behaves like defined"
 42 (number? 0))

(compiler-test-eq
 "Re-exported zero? is accessible and behaves like the built-in"
 #t (zero? 0))

(compiler-test-eq
 "Re-exported zero? is accessible and behaves like the built-in"
 #f (zero? 1))

(compiler-test-end "re-export")
