(define-library
  (export if-true
          if-true-consquent-only
          if-false
          if-false-consquent-only
          if-lambda-condition
          if-lambda-consquent
          if-lambda-alternative)

  (import (scheme base))

  (begin
    (define x 1)

    (define (if-true)
      (set! x 1)
      (if (= x 1) x (+ x 1)))

    (define (if-true-consquent-only)
      (set! x 1)
      (if (= x 1) (set! x (+ x 2)))
      x)

    (define (if-false)
      (set! x 1)
      (if (> x 1) x (+ x 1)))

    (define (if-false-consquent-only)
      (set! x 1)
      (if (> x 1) (set! x (+ x 2)))
      x)

    (define (if-lambda-condition)
      (if ((lambda (x) (> x 0)) 1)
          1 2))

    (define (if-lambda-consquent)
      (if ((lambda (x) (> x 0)) 1)
          ((lambda (x) (+ x 1)) 1)
          3))

    (define (if-lambda-alternative)
      (if ((lambda (x) (> x 0)) 0)
          ((lambda (x) (+ x 1)) 1)
          ((lambda (x) (+ x 2)) 2)))
  )
)
