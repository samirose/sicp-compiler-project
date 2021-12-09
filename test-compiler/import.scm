(define-library
  (import (scheme base))
  (export number?)

  (begin
    ; re-define import
    (define (number? x) 42))
)
