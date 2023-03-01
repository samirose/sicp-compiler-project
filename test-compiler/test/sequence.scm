(import (compiler-test)
	(sequence))

(compiler-test-begin "sequence")

(compiler-test-eq
 "sequence of values evaluates to the last value"
 3 (sequence-has-last-value))

(compiler-test-eq
 "sequence of expressions evaluates to the last expression's value"
 2 (sequence-has-last-expressions-value))

(compiler-test-eq
 "all expressions in a sequence are evaluated"
 6 (all-sequence-expressions-are-evaluated))

(compiler-test-eq
 "sequence expressions are evaluated in order"
 1 (sequence-expressions-are-evaluated-in-order))

(compiler-test-end "sequence")
