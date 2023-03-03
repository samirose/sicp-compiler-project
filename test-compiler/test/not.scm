(import (compiler-test)
	(not))

(compiler-test-begin "not")

(compiler-test-eq
 "not true is false"
 #f (not-true-is-false))

(compiler-test-eq
 "not false is true"
 #t (not-false-is-true))

(compiler-test-eq
 "not non-false value is false"
 #f (not-non-false-value-is-false))

(compiler-test-eq
 "not true expression is false"
 #f (not-true-expression-is-false))

(compiler-test-eq
 "not non-false expression is false"
 #f (not-non-false-expression-is-false))

(compiler-test-eq
 "not false expression is true"
 #t (not-false-expression-is-true))

(compiler-test-end "not")
