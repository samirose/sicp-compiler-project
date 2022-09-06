(compiler-test-begin 'arithmetic-operators)

(compiler-test-eq plus-identity "(+) is zero"
		  0 (+))
(compiler-test-eq multiply-identity "(*) is one"
		  1 (*))
(compiler-test-eq plus-single "(+ x) is x"
		  2 (+ 2))
(compiler-test-eq minus-single "(- x) is -x"
		  -2 (- 2))
(compiler-test-eq multiply-single "(* x) is x"
		  2 (* 2))
(compiler-test-eq plus-zero-to-positive "(+ 0 x) is x, x > 0"
		  2 (+ 0 2))
(compiler-test-eq plus-zero-to-negative "(+ 0 x) is x, x < 0"
		  -2 (+ -2 0))
(compiler-test-eq plus-positive-result "(+ x y) is x + y (x > 0, y > 0)"
		  3 (+ 1 2))
(compiler-test-eq signed-plus-positive-result "(+ x y) is x + y (x > 0, y < 0, |x| > |y|)"
		  1 (+ 2 -1))
(compiler-test-eq signed-plus-zero-result "(+ x y) is 0 (x = -y)"
		  0 (+ 2 -2))
(compiler-test-eq signed-plus-negative-result "(+ x y) is x + y (x > 0, y < 0, |x| < |y|)"
		  -1 (+ 2 -3))
(compiler-test-eq plus-multiple "(+ a b c) is a + b + c"
		  6 (+ 1 2 3))
(compiler-test-eq complex "complex arithmetic expression evaluates to correct result"
  -8
  (+ (/ (* 2 -6 2) 3 2) (- (+ 1 2 3)) (* (+ (+ 1 1)))))

(compiler-test-end 'arithmetic-operators)
