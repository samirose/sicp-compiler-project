(define-library (runtime-memory)

  (export definitions
          user-memory-start-address)

  (import (scheme base)
          (values))

  (begin
    (define definitions
      ;; WASI requires the export name "memory"
      '((memory (export "memory") 10)))

    ;; Reserve 0x00-0xff for runtime internal data
    (define user-memory-start-address #x100)
    ))
