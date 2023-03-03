(import (compiler-test)
	(if))

(compiler-test-begin "if")

(compiler-test-eq
 "if with literal true test evaluates to the consequent"
 1 (if-true))

(compiler-test-eq
 "if with test evaluating to true evaluates to the consequent"
 1 (if-true-expression))

(compiler-test-eq
 "if with test evaluating to true does not evaluate the alternative"
 1 (if-true-does-not-evaluate-alternative))

(compiler-test-eq
 "if with only consequent and test evaluating to true evaluates the consequent"
 3 (if-true-consequent-only))

(compiler-test-eq
 "if with literal false test evaluates to the alternative"
 2 (if-false))

(compiler-test-eq
 "if with test evaluating to false evaluates to the alternative"
 2 (if-false-expression))

(compiler-test-eq
 "if with test evaluating to false does not evaluate the consequent"
 1 (if-false-does-not-evaluate-consequent))

(compiler-test-eq
 "if with only consequent and test evaluating to false does not evaluate the consequent"
 1 (if-false-consequent-only))

(compiler-test-eq
 "if with lambda in the test evaluates according to the result of the lambda"
 1 (if-lambda-condition))

(compiler-test-eq
 "if with test evaluating to true and lambda consequent evaluates to the value of the consequent lambda expression"
 2 (if-lambda-consequent))

(compiler-test-eq
 "if with test evaluating to false and lambda alternative evaluates to the value of the alternative lambda expression"
 4 (if-lambda-alternative))

(compiler-test-end "if")
