(import (compiler-test)
	(lambda))

(compiler-test-begin "lambda")

(compiler-test-eq
 "immediate lambda application evaluates to the value of the lambda body with parameters replaced with the arguments"
 4 (lambda-application))

(compiler-test-eq
 "lambda expression can be used as an argument to another lambda"
 120 (lambda-argument))

(compiler-test-eq
 "applying lambda without arguments evaluates to the value of the lambda body expression"
 42 (lambda-without-parameters))

(compiler-test-eq
 "lambda parameters shadow global bindings with the same names"
 7 (lambda-parameters-shadow-globals))

(compiler-test-eq
 "inner lambda parameters shadow outer lambda parameters with the same names"
 11 (inner-lambda-parameters-shadow-outer))

(compiler-test-eq
 "lambda returned from a procedure can be applied to arguments"
 6 (lambda-procedure-result))

(compiler-test-end "lambda")

