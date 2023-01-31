(define-library 
  (exported-procedure)

  (export value square minus double)

  (import (scheme base))

  (begin
    (define (value) 42)
    (define (square x) (* x x))
    (define (minus x y) (- x y))
    (define double (lambda (x) (+ x x)))))
