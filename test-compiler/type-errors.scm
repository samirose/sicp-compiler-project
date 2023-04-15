(define-library
    (type-errors)

  (export
   plus-two
   two-times)

  (import (scheme base))

  (begin
    (define (plus-two x)
      (+ x 2))

    (define (two-times x)
      (* 2 x))
    )
  )
