(define-library
  (if)

  (export if-true
          if-number
          if-procedure
          if-symbol
          if-string
          if-true-expression
          if-true-does-not-evaluate-alternative
          if-true-consequent-only
          if-false
          if-false-expression
          if-false-does-not-evaluate-consequent
          if-false-consequent-only
          if-lambda-condition
          if-lambda-consequent
          if-lambda-alternative)

  (import (scheme base))

  (begin
    (define x 1)

    (define (if-true)
      (if #t 1 2))

    (define (if-number)
      (if 0 1 2))

    (define (if-procedure)
      (if if-true 1 2))

    (define (if-symbol)
      (if 'symb 1 2))

    (define (if-string)
      (if "str" 1 2))

    (define (if-true-expression)
      (set! x 1)
      (if (= x 1) x (+ x 1)))

    (define (if-true-does-not-evaluate-alternative)
      (set! x 0)
      (if (= x 0) (set! x (+ x 1))  (set! x (+ x 2)))
      x)

    (define (if-true-consequent-only)
      (set! x 1)
      (if (= x 1) (set! x (+ x 2)))
      x)

    (define (if-false)
      (if #f 1 2))

    (define (if-false-expression)
      (set! x 1)
      (if (> x 1) x (+ x 1)))

    (define (if-false-does-not-evaluate-consequent)
      (set! x 0)
      (if (= x 1) (set! x (+ x 2)) (set! x (+ x 1)))
      x)

    (define (if-false-consequent-only)
      (set! x 1)
      (if (> x 1) (set! x (+ x 2)))
      x)

    (define (if-lambda-condition)
      (if ((lambda (x) (> x 0)) 1)
          1 2))

    (define (if-lambda-consequent)
      (if ((lambda (x) (> x 0)) 1)
          ((lambda (x) (+ x 1)) 1)
          3))

    (define (if-lambda-alternative)
      (if ((lambda (x) (> x 0)) 0)
          ((lambda (x) (+ x 1)) 1)
          ((lambda (x) (+ x 2)) 2)))
  )
)
