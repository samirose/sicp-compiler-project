(define-library (example-library)

  (export
   square square-4 get-square-4
   abs abs-3 abs-minus-5)

  (import (scheme base))

  (begin
    (define (square x) (* x x))

    (define square-4 (square 4))

    (define (get-square-4) square-4)

    (define (abs x)
      (if (< x 0) (- x) x))

    (define (abs-3) (abs 3))
    (define (abs-minus-5) (abs -5))
    ))

;; Compiling
;; make -s compile < demo/example-library.scm > demo/example-library.wat
;; wat-desugar demo/example-library.wat

;; Running
;; make -s compile < demo/example-library.scm > demo/example-library.wat
;; wat2wasm demo/example-library.wat -o demo/example-library.wasm
;; wasm-interp demo/example-library.wasm --run-all-exports

;; Examining Wasm binary
;; file demo/example-library.wasm
;; hexdump -C demo/example-library.wasm
;; wasm2wat demo/example-library.wasm

;; Piping
;; make -s compile < demo/example-library.scm | wat2wasm --output=- - | wasm-interp - --run-all-exports
