(define-library

  (import (scheme base))

  (begin
    (define x 40)
    (define y 2)
    ((lambda (x z) (+ x z)) 3 x)))
