(import (scheme base)
        (wasm-syntax)
        (assert))

(assert-equal
 '("" . 0)
 (string-as-wasm-data "")
 "empty string produces data with empty string and zero length")

(assert-equal
 '("str" . 3)
 (string-as-wasm-data "str")
 "single string produces the string as wasm data with the length of the string in bytes")

(assert-equal
 '(#u8(#x12 #x34 #xab #xcd) . 4)
 (i32-as-wasm-data #xcdab3412)
 "word value produces bytevector in little-endian order with length of 4")
