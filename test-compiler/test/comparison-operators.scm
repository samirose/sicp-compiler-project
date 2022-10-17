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

(compiler-test-end 'comparison-operators)
