(import (compiler-test)
	(exported-procedure))

(compiler-test-begin "exported-procedure")

(compiler-test-eq
 "procedure with a single argument can be exported and called"
 9 (square 3))

(compiler-test-eq
 "procedure with two arguments can be exported and called"
 -2 (minus 3 5))

(compiler-test-end "exported-procedure")
