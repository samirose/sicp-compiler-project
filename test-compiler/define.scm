(define-library
  (define)

  (export define-constants
          define-combinations
          define-lambda-combination
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

    (define c ((lambda (x) (+ x x)) 11))
    (define (define-lambda-combination) c)

    (define (double x) (* x 2))

    (define (define-procedure) (double 8))

    (define square (lambda (x) (* x x)))

    (define (define-procedure-with-lambda) (square 5)))
)
