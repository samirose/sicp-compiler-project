(define-library
  (test-lambda)

  (import (scheme base))

  (export lambda-application
          lambda-argument
          lambda-without-parameters
          lambda-parameters-shadow-globals
          inner-lambda-parameters-shadow-outer)

  (begin
    (define (lambda-application)
      ((lambda (x) (* x x)) 2))

    (define (lambda-argument)
      ((lambda (n)
         ((lambda (fact n) (fact fact n))
          (lambda (ft k) (if (= k 1) 1 (* k (ft ft (- k 1))))) n))
       5))

    (define (lambda-without-parameters)
      ((lambda () (+ 40 2))))

    (define g 2)
    (define h 3)

    (define (lambda-parameters-shadow-globals)
      ((lambda (g) (+ g h)) 4))

    (define (inner-lambda-parameters-shadow-outer)
      ((lambda (x) (+ 2 ((lambda (x) (* x x)) 3))) 4)))
)
