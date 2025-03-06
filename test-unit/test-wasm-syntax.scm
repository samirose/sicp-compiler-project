(import (scheme base)
        (wasm-syntax)
        (assert))

(let-values
    (((data length) (string-as-wasm-data "")))
  (assert-equal "" data "data of empty string is the empty string")
  (assert-equal 0 length "data length of empty string is zero"))

(let-values
    (((data length) (string-as-wasm-data "str")))
  (assert-equal "str" data "data of string is the string")
  (assert-equal 3 length "data length of a string is the string length in bytes"))

(let-values
    (((data length) (i32-as-wasm-data #xcdab3412)))
  (assert-equal
   #u8(#x12 #x34 #xab #xcd)
   data
   "data of number as i32 is a bytevector of the value in little-endian order")
  (assert-equal 4 length "data length of a number as i32 is 4"))
