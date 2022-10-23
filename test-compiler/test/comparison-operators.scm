(import (compiler-test)
	(comparison-operators))

(compiler-test-begin 'comparison-operators)

(compiler-test-eq
 "all comparison operators with a single argument evaluate to true"
 #t (all-with-single-argument-are-true))

(compiler-test-eq
 "binary numeric equality is true with equal values"
 #t (binary-equal 1 1))

(compiler-test-eq
 "binary numeric equality is false with unequal values"
 #f (binary-equal 1 0))

(compiler-test-eq
 "binary numeric equality is false with unequal values"
 #f (binary-equal 0 1))

(compiler-test-eq
 "(> x y) = true, when x > y"
 #t (binary-greater-than 1 0))

(compiler-test-eq
 "(> x y) = false, when x < y"
 #f (binary-greater-than 0 1))

(compiler-test-eq
 "(> x y) = false, when x = y"
 #f (binary-greater-than 1 1))

(compiler-test-eq
 "(< x y) = true, when x < y"
 #t (binary-less-than 0 1))

(compiler-test-eq
 "(< x y) = false, when x > y"
 #f (binary-less-than 1 0))

(compiler-test-eq
 "(< x y) = false, when x = y"
 #f (binary-less-than 1 1))

(compiler-test-eq
 "(<= x y) = true, when x < y"
 #t (binary-less-or-equal-than 0 1))

(compiler-test-eq
 "(<= x y) = false, when x > y"
 #f (binary-less-or-equal-than 1 0))

(compiler-test-eq
 "(<= x y) = true, when x = y"
 #t (binary-less-or-equal-than 1 1))

(compiler-test-eq
 "(>= x y) = true, when x > y"
 #t (binary-greater-or-equal-than 1 0))

(compiler-test-eq
 "(>= x y) = false, when x < y"
 #f (binary-greater-or-equal-than 0 1))

(compiler-test-eq
 "(>= x y) = true, when x = y"
 #t (binary-greater-or-equal-than 1 1))

(compiler-test-eq
 "more-than-two-params-true"
 #t (more-than-two-params-true))

(compiler-test-eq
 "more-than-two-params-false"
 #f (more-than-two-params-false))

(compiler-test-end 'comparison-operators)
