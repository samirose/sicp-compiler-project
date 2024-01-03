(import (compiler-test)
        (eqv))

(compiler-test-begin "eqv")

;; booleans to booleans
(compiler-test-eq
 "#t eqv? #t is true"
 #t (eqv-literals #t #t))

(compiler-test-eq
 "#f eqv? #f is true"
 #t (eqv-literals #f #f))

(compiler-test-eq
 "#t eqv? #f is false"
 #f (eqv-literals #t #f))

(compiler-test-eq
 "#f eqv? #t is false"
 #f (eqv-literals #f #t))

;; numbers to numbers
(compiler-test-eq
 "0 eqv? 0 is true"
 #t (eqv-literals 0 0))

(compiler-test-eq
 "1 eqv? 1 is true"
 #t (eqv-literals 1 1))

(compiler-test-eq
 "-1 eqv? -1 is true"
 #t (eqv-literals -1 -1))

(compiler-test-eq
 "553 eqv? 553 is true"
 #t (eqv-literals 553 553))

(compiler-test-eq
 "0 eqv? 1 is false"
 #f (eqv-literals 0 1))

(compiler-test-eq
 "-1 eqv? 1 is false"
 #f (eqv-literals -1 1))

(compiler-test-eq
 "429 eqv? 555 is false"
 #f (eqv-literals 429 555))

;; numbers to booleans
(compiler-test-eq
 "0 eqv? #t is false"
 #f (eqv-literals 0 #t))

(compiler-test-eq
 "#t eqv? 1 is false"
 #f (eqv-literals #t 1))

(compiler-test-eq
 "0 eqv? #f is false"
 #f (eqv-literals 0 #t))

(compiler-test-eq
 "#f eqv? 1 is false"
 #f (eqv-literals #f 1))

;; procedures to procedures
(compiler-test-eq
 "procedure reference is eqv? with the same procedure reference"
 #t (eqv-proc-reference-to-same-proc-reference))

(compiler-test-eq
 "procedure reference is not eqv? with different procedure reference"
 #f (eqv-proc-reference-to-different-proc-reference))

(compiler-test-eq
 "procedure reference is not eqv? with lambda"
 #f (eqv-proc-reference-to-lambda))

(compiler-test-eq
 "a lambda is not eqv? to a lambda with different form"
 #f (eqv-lambda-to-lambda-with-different-form))

(compiler-test-eq
 "lambda eqv? to lambda with same form is boolean"
 #t (eqv-lambda-to-lambda-with-same-form-is-boolean))

;; procedures to booleans
(compiler-test-eq
 "procedure is not eqv? to #t"
 #f (eqv-procedure-to-literal #t))

(compiler-test-eq
 "procedure is not eqv? to #f"
 #f (eqv-procedure-to-literal #f))

;; procedures to numbers
(compiler-test-eq
 "procedure is not eqv? to 42"
 #f (eqv-procedure-to-literal 42))

(compiler-test-eq
 "procedure is not eqv? to 0"
 #f (eqv-procedure-to-literal 0))

;; symbols to symbols
(compiler-test-eq
 "symbol literal is eqv? with the same symbol literal"
 #t (eqv-symbol-literal-with-same-symbol-literal))

(compiler-test-eq
 "symbol reference is eqv? with the same symbol literal"
 #t (eqv-symbol-reference-with-same-symbol-literal))

(compiler-test-eq
 "symbol reference is eqv? with the same symbol reference"
 #t (eqv-symbol-reference-with-same-reference))

;; symbols to literals
(compiler-test-eq
 "symbol is not eqv? to 42"
 #f (eqv-symbol-to-literal 42))

;; symbols to procedures
(compiler-test-eq
 "symbol is not eqv? to a procedure"
 #f (eqv-symbol-to-procedure))

;; strings to strings
(compiler-test-eq
 "string location is eqv? with the same location"
 #t (eqv-string-to-same-string-location))

(compiler-test-eq
 "eqv? between string literals has boolean result"
 #t (eqv-string-to-string-literal-is-boolean))

;; strings to booleans
(compiler-test-eq
 "string is not eqv? to #t"
 #f (eqv-string-to-literal #t))

(compiler-test-eq
 "string is not eqv? to #f"
 #f (eqv-string-to-literal #f))

;; strings to numbers
(compiler-test-eq
 "string is not eqv? to 42"
 #f (eqv-string-to-literal 42))

(compiler-test-eq
 "string is not eqv? to 0"
 #f (eqv-string-to-literal 0))

;; strings to procedures
(compiler-test-eq
 "string is not eqv? to a procedure"
 #f (eqv-string-to-procedure))

;; strings to symbols
(compiler-test-eq
 "string is not eqv? to a symbol"
 #f (eqv-string-to-symbol))

(compiler-test-end "eqv")
