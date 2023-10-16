(import (compiler-test)
	(types))

(compiler-test-begin "types")

(compiler-test-eq
 "0 is number"
 #t (is-number? 0))

(compiler-test-eq
 "1 is number"
 #t (is-number? 1))

(compiler-test-eq
 "-1 is number"
 #t (is-number? -1))

(compiler-test-eq
 "0 is zero"
 #t (is-zero? 0))

(compiler-test-eq
 "1 is not zero"
 #f (is-zero? 1))

(compiler-test-eq
 "-1 is not zero"
 #f (is-zero? -1))

(compiler-test-eq
 "0 is eq to 0"
 #t (is-eq? 0 0))

(compiler-test-eq
 "1 is eq to 1"
 #t (is-eq? 1 1))

(compiler-test-eq
 "-1 is eq to -1"
 #t (is-eq? -1 -1))

(compiler-test-eq
 "0 is not eq to 1"
 #f (is-eq? 0 1))

(compiler-test-eq
 "1 is not eq to 0"
 #f (is-eq? 1 0))

(compiler-test-eq
 "numeric expression's value is number"
 #t (numeric-exp-is-number?))

(compiler-test-eq
 "true is not number"
 #f (is-number? #t))

(compiler-test-eq
 "false is not number"
 #f (is-number? #f))

(compiler-test-eq
 "true is boolean"
 #t (is-boolean? #t))

(compiler-test-eq
 "false is boolean"
 #t (is-boolean? #f))

(compiler-test-eq
 "1 is not boolean"
 #f (is-boolean? 1))

(compiler-test-eq
 "0 is not boolean"
 #f (is-boolean? 0))

(compiler-test-eq
 "-1 is not boolean"
 #f (is-boolean? -1))

(compiler-test-eq
 "true is eq to true"
 #t (is-eq? #t #t))

(compiler-test-eq
 "false is eq to false"
 #t (is-eq? #f #f))

(compiler-test-eq
 "true is not eq to false"
 #f (is-eq? #t #f))

(compiler-test-eq
 "false is not eq to true"
 #f (is-eq? #f #t))

(compiler-test-eq
 "true is not eq to 1"
 #f (is-eq? #t 1))

(compiler-test-eq
 "false is not eq to 0"
 #f (is-eq? #f 0))

(compiler-test-eq
 "eq? evaluates to boolean value"
 #t (eq?-evaluates-to-boolean-value))

(compiler-test-eq
 "arithmetic comparison operators return boolean values"
 #t (arithmetic-comparison-operators-evaluate-to-boolean-values))

(compiler-test-eq
 "lambda is procedure"
 #t (lambda-is-procedure?))

(compiler-test-eq
 "defined procedure is procedure"
 #t (defined-procedure-is-procedure?))

(compiler-test-eq
 "imported procedure is procedure"
 #t (imported-procedure-is-procedure?))

(compiler-test-eq
 "procedure argument is procedure"
 #t (procedure-argument-is-procedure?))

(compiler-test-eq
 "procedure from procedure is procedure"
 #t (procedure-from-procedure-is-procedure?))

(compiler-test-eq
 "procedure is eq to same procedure"
 #t (is-procedure-eq-to-same-procedure?))

(compiler-test-eq
 "procedure is not eq to different procedure"
 #f (is-procedure-eq-to-different-procedure?))

(compiler-test-eq
 "1 is not procedure"
 #f (is-procedure? 1))

(compiler-test-eq
 "true is not procedure"
 #f (is-procedure? #t))

(compiler-test-eq
 "false is not procedure"
 #f (is-procedure? #f))

(compiler-test-eq
 "1 is not eq to procedure number?"
 #f (is-procedure-number?-eq-to 1))

(compiler-test-eq
 "true is not eq to procedure number?"
 #f (is-procedure-number?-eq-to #t))

(compiler-test-eq
 "symbol is symbol"
 #t (symbol-is-symbol?))

(compiler-test-eq
 "0 is not a symbol"
 #f (is-symbol? 0))

(compiler-test-eq
 "1 is not a symbol"
 #f (is-symbol? 1))

(compiler-test-eq
 "-1 is not a symbol"
 #f (is-symbol? -1))

(compiler-test-eq
 "false is not a symbol"
 #f (is-symbol? #f))

(compiler-test-eq
 "true is not a symbol"
 #f (is-symbol? #t))

(compiler-test-eq
 "procedure is not a symbol"
 #f (procedure-is-symbol?))

(compiler-test-eq
 "string is not a symbol"
 #f (string-is-symbol?))

(compiler-test-eq
 "string is string"
 #t (string-is-string?))

(compiler-test-eq
 "0 is not a string"
 #f (is-string? 0))

(compiler-test-eq
 "1 is not a string"
 #f (is-string? 1))

(compiler-test-eq
 "-1 is not a string"
 #f (is-string? -1))

(compiler-test-eq
 "false is not a string"
 #f (is-string? #f))

(compiler-test-eq
 "true is not a string"
 #f (is-string? #t))

(compiler-test-eq
 "procedure is not a string"
 #f (procedure-is-string?))

(compiler-test-eq
 "symbol is not a string"
 #f (symbol-is-string?))

(compiler-test-end "types")
