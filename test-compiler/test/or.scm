(import (compiler-test)
	(or))

(compiler-test-begin "or")

(compiler-test-eq
 "empty or is false"
 #f (empty-or-is-false))

(compiler-test-eq
 "or one false is false"
 #f (or-one-false-is-false))

(compiler-test-eq
 "or with one non-false value is the value"
 42 (or-one-non-false-value-is-value))

(compiler-test-eq
 "or with two non-false values is the first value"
 1 (or-two-non-falses-is-first-value))

(compiler-test-eq
 "or with any non-false value is non-false"
 #t (or-any-non-false-is-non-false))

(compiler-test-eq
 "or test expressions can be arbitrarily complex"
 2 (or-with-complex-expressions))

(compiler-test-eq
 "or evaluates expressions from left to right"
 3 (or-evaluates-expressions-from-left-to-right))

(compiler-test-eq
 "or with non-false test short-circuits to non-false"
 2 (or-true-short-circuits-to-true))

(compiler-test-end "or")
