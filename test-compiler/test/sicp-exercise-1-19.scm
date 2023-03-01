(import (compiler-test)
	(sicp-exercise-1-19))

(compiler-test-begin "sicp-exercise-1-19")

(compiler-test-eq
  "fib 0 is 0"
  0 (fib 0))

(compiler-test-eq
  "fib 1 is 1"
  1 (fib 1))

(compiler-test-eq
  "fib 2 is 1"
  1 (fib 2))

(compiler-test-eq
  "fib 3 is 2"
  2 (fib 3))

(compiler-test-eq
  "fib 4 is 3"
  3 (fib 4))

(compiler-test-eq
  "fib 5 is 5"
  5 (fib 5))

(compiler-test-eq
  "fib 30 is 832040"
  832040 (fib 30))

(compiler-test-end "sicp-exercise-1-19")
