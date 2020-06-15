#!r6rs
(import (rnrs base)
        (rnrs io simple)
        (wasm-compiler))

(write (compile-single-exp-to-wasm-module (read)))
(newline)
