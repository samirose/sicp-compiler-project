(define-library (example-module)

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
;; make -s compile < demo/example-module.scm > demo/example-module.wat
;; wat-desugar demo/example-module.wat

;; Running
;; make -s compile < demo/example-module.scm > demo/example-module.wat
;; wat2wasm demo/example-module.wat -o demo/example-module.wasm
;; wasm-interp demo/example-module.wasm --run-all-exports

;; Examining Wasm binary
;; file demo/example-module.wasm
;; hexdump -C demo/example-module.wasm
;; wasm2wat demo/example-module.wasm

;; Piping
;; make -s compile < demo/example-module.scm | wat2wasm --output=- - | wasm-interp - --run-all-exports
