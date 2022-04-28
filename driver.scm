(import (scheme base)
        (scheme read)
	(scheme write)
        (module-compiler))

(write (compile-r7rs-library-to-wasm-module (read)))
(newline)
