(import (scheme base)
        (scheme read)
	(scheme write)
        (lists)
        (module-compiler)
        (wasm-syntax))

(let ((output-port (current-output-port)))
  (emit-wat
   (compile-r7rs-library-to-wasm-module (read))
   output-port))
