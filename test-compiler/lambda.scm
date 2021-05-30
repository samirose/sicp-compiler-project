(define-library

  (export lambda-application
          lambda-argument
          lambda-without-parameters)

  (import (scheme base))

  (begin
    (define (lambda-application)
      ((lambda (x) (* x x)) 2))

    (define (lambda-argument)
      ((lambda (n)
         ((lambda (fact n) (fact fact n))
          (lambda (ft k) (if (= k 1) 1 (* k (ft ft (- k 1))))) n))
       5))

    (define (lambda-without-parameters)
      ((lambda () (+ 40 2)))))
)
