(define-library 
  (test-exported-procedure)

  (export square minus)

  (import (scheme base))

  (begin
    (define (square x) (* x x))
    (define (minus x y) (- x y))))
