#!r6rs
(import (rnrs base)
        (rnrs io simple)
        (module-compiler))

(write (compile-single-exp-to-wasm-module (read)))
(newline)
