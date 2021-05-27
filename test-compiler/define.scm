(define-library

  (export define-constants
          define-combinations
          define-procedure
          define-procedure-with-lambda)

  (import (scheme base))

  (begin
    (define x 40)
    (define y 2)

    (define (define-constants) (+ x y))

    (define a (+ 30 2))
    (define b (+ a 11))

    (define (define-combinations) b)

    (define (double x) (* x 2))

    (define (define-procedure) (double 8))

    (define square (lambda (x) (* x x)))

    (define (define-procedure-with-lambda) (square 5)))
)
