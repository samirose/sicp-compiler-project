(import (compiler-test)
	(types))

(compiler-test-begin "types")

(compiler-test-eq
 "0 is number"
 #t (is-number? 0))

(compiler-test-eq
 "1 is number"
 #t (is-number? 1))

(compiler-test-eq
 "-1 is number"
 #t (is-number? -1))

(compiler-test-eq
 "0 is zero"
 #t (is-zero? 0))

(compiler-test-eq
 "1 is not zero"
 #f (is-zero? 1))

(compiler-test-eq
 "-1 is not zero"
 #f (is-zero? -1))

(compiler-test-eq
 "0 is eq to 0"
 #t (is-eq? 0 0))

(compiler-test-eq
 "1 is eq to 1"
 #t (is-eq? 1 1))

(compiler-test-eq
 "-1 is eq to -1"
 #t (is-eq? -1 -1))

(compiler-test-eq
 "0 is not eq to 1"
 #f (is-eq? 0 1))

(compiler-test-eq
 "1 is not eq to 0"
 #f (is-eq? 1 0))

(compiler-test-end "types")
