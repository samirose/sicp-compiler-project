(define-library
  (types)

  (export
   is-number? is-zero? is-eq?)

  (import (scheme base))

  (begin
    (define (is-number? x)
      (number? x))

    (define (is-zero? x)
      (zero? x))

    (define (is-eq? x y)
      (eq? x y))
    ))
