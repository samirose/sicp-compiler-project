(define-library 

  (export square minus)

  (import (scheme base))

  (begin
    (define (square x) (* x x))
    (define (minus x y) (- x y))))
