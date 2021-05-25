(define-library

  (import (scheme base))

  (begin
    ((lambda (x)
      (set! x 10)
      (+ x 3))
    5)))
