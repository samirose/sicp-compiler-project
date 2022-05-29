(define-library (example-module)
  (export square get-value)

;;  (import (scheme base))

  (begin
    (define (square x) (* x x))

    (define a (square 4))

    (define (get-value) a)
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
;; hexdump demo/example-module.wasm
;; wasm2wat demo/example-module.wasm

;; Piping
;; make -s compile < demo/example-module.scm | wat2wasm --output=- - | wasm-interp - --run-all-exports
