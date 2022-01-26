#!r6rs
(import (rnrs base)
        (rnrs io simple)
        (module-compiler))

(write (compile-r7rs-library-to-wasm-module (read)))
(newline)
