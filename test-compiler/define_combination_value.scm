(define-library

  (import (scheme base))

  (begin
    (define x (+ 30 2))
    (define (double x) (* x 2))
    (define y (double x))
    y))
