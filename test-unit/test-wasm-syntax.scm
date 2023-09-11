(import (scheme base)
        (wasm-syntax)
        (assert))

(assert-equal
 '(data-with-length 0 0 "")
 (wasm-data-definition 0 '())
 "empty list produces data definition with an empty value")

(assert-equal
 '(data-with-length 0 0 "")
 (wasm-data-definition 0 "")
 "empty string produces data definition with an empty value")

(assert-equal
 32
 (wasm-data-offset (wasm-data-definition #x20 '("foobar")))
 "wasm-data-offset returns the offset value of a data definition")

(assert-equal
 '(data-with-length 0 3 "str")
 (wasm-data-definition 0 '("str"))
 "single string produces the string in data value")

(assert-equal
 '(data-with-length 0 5 "\\00\\01\\a0\\b0\\ff")
 (wasm-data-definition 0 '(#x0 #x01 #xa0 #xb0 #xff))
 "byte values produce hex unicode characters")

(assert-equal
 '(data-with-length 0 4 "\\12\\34\\ab\\cd")
 (wasm-data-definition 0 '(#xcdab3412))
 "word value produces hex unicode characters in little-endian order")

(assert-equal
 '(data-with-length 32 15 "foo\\cd\\ab\\34\\12bar\\a0\r\n\t\b")
 (wasm-data-definition #x20 '("foo" #x1234abcd "bar" 160 "\r\n\t\b"))
 "mixed values produce a data definition")
