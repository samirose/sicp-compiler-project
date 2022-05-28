(define-library (example-module)
  (export square get-value)

;;  (import (scheme base))

  (begin
    (define (square x) (* x x))

    (define a (square 42))

    (define (get-value) a)
    ))

;; Compiling
;; make -s compile < demo/example-module.scm | wat-desugar -

;; Running
;; make -s compile < demo/example-module.scm > demo/example-module.wat
;; wat2wasm demo/example-module.wat -o demo/example-module.wasm
;; wasm-interp demo/example-module.wasm --run-all-exports
