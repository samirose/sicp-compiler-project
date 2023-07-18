(import (compiler-test)
        (type-errors))

(compiler-test-begin "type-errors")

(compiler-test-error
 "arithmetic with boolean value is a type error"
 (plus-two #t) expected-number)

(compiler-test-error
 "arithmetic with boolean value is a type error"
 (plus-two #f) expected-number)

(compiler-test-error
 "arithmetic with procedure value is a type error"
 (lambda-two-times) expected-number)

(compiler-test-error
 "arithmetic with procedure value is a type error"
 (procedure-plus-two) expected-number)

(compiler-test-error
 "number as operator is a type error"
 (apply-to 2 #f) expected-procedure)

(compiler-test-error
 "boolean as operator is a type error"
 (apply-to #t 3) expected-procedure)

(compiler-test-error
 "arithmetic with unspecified value is a type error"
 (unspecified-plus-two) expected-number)

(compiler-test-error
 "unspecified value as operator is a type error"
 (unspecified-as-operator 1) expected-procedure)

(compiler-test-end "type-errors")
