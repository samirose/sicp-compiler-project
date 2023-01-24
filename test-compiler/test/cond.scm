(import (compiler-test)
	(cond))

(compiler-test-begin "cond")

(compiler-test-eq
 "cond with single non-false test expression returns the value of the expression"
 1 (single-exp 1))

(compiler-test-eq
 "cond with single true test expression returns true"
 #t (single-exp #t))

(compiler-test-unspecified
 "cond with single false test expression returns unspecified value"
 (single-exp #f))

(compiler-test-eq
 "cond with true test and expression returns value of the expression"
 2 (test-and-exp 1))

(compiler-test-unspecified
 "cond with false test and expression returns unspecified value"
 (test-and-exp 2))

(compiler-test-eq
 "cond with true test, expression and else returns value of the expression"
 6 (test-and-exp-else 5))

(compiler-test-eq
 "cond with false test, expression and else returns value of the else expression"
 9 (test-and-exp-else 10))

(compiler-test-eq
 "cond with only else expression returns value of the else expression"
 42 (only-else))

(compiler-test-eq
 "nested cond returns value of top-level else expression if all top-level tests evaluate to false"
 10 (nested 11))

(compiler-test-eq
 "nested cond returns value of inner cond's clause with a test evaluating to true"
 3 (nested 2))

(compiler-test-eq
 "nested cond returns value of inner cond's else when inner cond's tests evaluate to false"
 0 (nested -1))

(compiler-test-eq
 "cond evaluates only the expression in the first clause that has a test evaluating to true"
 1 (sequence-exps 1))

(compiler-test-eq
 "cond evaluates only the expression in the first clause that has a test evaluating to true"
 2 (sequence-exps 2))

(compiler-test-eq
 "cond evaluates only the expression in the else clause when all test clauses evaluate to false"
 3 (sequence-exps -1))

(compiler-test-eq
 "cond clause expression can be a lambda"
 4 (lambda-exps 2))

(compiler-test-eq
 "cond clause expression can be a lambda"
 2 (lambda-exps 1))

(compiler-test-eq
 "cond else expression can be a lambda"
 2 (lambda-exps -1))

(compiler-test-end "cond")
