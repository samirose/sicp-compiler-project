#!r6rs
(import (rnrs base)
        (rnrs io simple)
        (wasm-compiler))

(display
 (compile-to-wasm-module '((lambda (x) (* x x)) (+ 1 2))))
