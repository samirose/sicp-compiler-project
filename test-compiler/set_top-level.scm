(define-library

  (import (scheme base))

  (begin
    (define a 5)
    ((lambda (b)
      (set! a 10)
      (+ a b))
    3)))
