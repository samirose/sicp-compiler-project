(import (compiler-test)
        (type-errors))

(compiler-test-begin "type-errors")

(compiler-test-error
 "arithmetic with boolean value is a type error"
 (plus-two #t))

(compiler-test-error
 "arithmetic with boolean value is a type error"
 (plus-two #f))

(compiler-test-end "type-errors")
