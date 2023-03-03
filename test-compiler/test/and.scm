(import (compiler-test)
	(and))

(compiler-test-begin "and")

(compiler-test-eq
 "and without arguments is true"
 #t (empty-and-is-true))

(compiler-test-eq
 "and single false is false"
 #f (and-one-false-is-false))

(compiler-test-eq
 "and single non-false value is the value"
 42 (and-one-non-false-value-is-value))

(compiler-test-eq
 "and of two non-false values is the last value"
 2 (and-two-non-false-values-is-last-value))

(compiler-test-eq
 "and with any false value is false"
 #f (and-any-false-is-false))

(compiler-test-eq
 "and with comples non-false expressions is the last expression's value"
 2 (and-with-complex-expressions))

(compiler-test-eq
 "and evaluates expressions from left to right"
 3 (and-evaluates-expressions-from-left-to-right))

(compiler-test-eq
 "false value in and short-circuits to false"
 2 (and-false-short-circuits-to-false))

(compiler-test-end "and")
