#!r6rs
(import (rnrs base)
        (rnrs io simple)
        (wasm-compiler))

(write (compile-to-wasm-module (read)))
(newline)
