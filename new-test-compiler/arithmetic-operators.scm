(import (scheme base)
	(compiler-test))

(begin-compiler-test "arithmetic-operators")

(test-eq "(+) is zero" 0 (+))
(test-eq "(*) is one" 1 (*))
(test-eq "(+ x) is x" 2 (+ 2))
(test-eq "(- x) is -x" -2 (- 2))
(test-eq "(* x) is x" 2 (* 2))
(test-eq "(+ 0 x) is x, x > 0" 2 (+ 0 2))
(test-eq "(+ 0 x) is x, x < 0" -2 (+ -2 0))
(test-eq "(+ x y) is x + y (x > 0, y > 0)" 3 (+ 1 2))
(test-eq "(+ x y) is x + y (x > 0, y < 0, |x| > |y|)" 1 (+ 2 -1))
(test-eq "(+ x y) is x + y (x > 0, y < 0, |x| < |y|)" -1 (+ 2 -3))
(test-eq "(+ a b c) is a + b + c" 6 (+ 1 2 3))
(test-eq "complex arithmetic expression evaluates to correct result"
  -8
  (+ (/ (* 2 -6 2) 3 2) (- (+ 1 2 3)) (* (+ (+ 1 1)))))

(end-compiler-test "arithmetic-operators")
