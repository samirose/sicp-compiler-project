(define-library
  (import)

  (import (scheme base))

  ; should export the re-defined number?
  (export number?)

  ; should export the original zero?
  (export zero?)

  (begin
    ; re-define import
    (define (number? x) 42))
)
