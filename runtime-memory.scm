(define-library (runtime-memory)

  (export memory-definitions
          literal-memory-start-address
          heap-memory-start-vector)

  (import (scheme base)
          (values))

  (begin
    (define memory-definitions
      ;; WASI requires the export name "memory"
      '((memory (export "memory") 10)))

    ;; Reserve memory addresses 0x00000000-0x000000ff for runtime internal data.
    ;; Literal data will start from 0x00000100
    (define literal-memory-start-address #x00000100)

    ;; Address of pointer to start of heap after literal data
    (define heap-memory-start-vector #x00000000)
    ))
