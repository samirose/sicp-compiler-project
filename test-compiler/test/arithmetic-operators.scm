(import (compiler-test)
	(arithmetic-operators))

(compiler-test-begin "arithmetic-operators")

(compiler-test-eq
 "plus identity is zero"
 0 (plus-identity))

(compiler-test-eq
 "multiply identity is one"
 1 (multiply-identity))

(compiler-test-eq
 "plus single number equals the number"
 2 (plus-single))

(compiler-test-eq
 "minus single number equals the number negated"
 -2 (minus-single))

(compiler-test-eq
 "multiply single number equals the number"
 2 (multiply-single))

(compiler-test-eq
 "zero plus positive number equals the number"
 2 (plus-zero-to-positive))

(compiler-test-eq
 "plus with two positive numbers equals sum of the numbers"
 3 (plus-positive-result))

(compiler-test-eq
 "positive number plus smaller negative number equals the positive sum"
 1 (signed-plus-positive-result))

(compiler-test-eq
 "positive number plus equal negative number equals zero"
 0 (signed-plus-zero-result))

(compiler-test-eq
 "positive number plus greater negative number equals the negative sum"
 -1 (signed-plus-negative-result))

(compiler-test-eq
 "negative number plus zero equals the negative number"
 -2 (plus-zero-to-negative))

(compiler-test-eq
 "plus with more than two arguments equals sum of the arguments"
 6 (plus-multiple))

(compiler-test-eq
 "nested arithmetic expression evaluates to correct value"
 -8 (complex))

(compiler-test-end "arithmetic-operators")
