(define-library

  (export
    sequence-has-last-value
    sequence-has-last-expressions-value
    all-sequence-expressions-are-evaluated
    sequence-expressions-are-evaluated-in-order)

  (import (scheme base))

  (begin
    (define (sequence-has-last-value)
      (begin 1 2 3))

    (define (sequence-has-last-expressions-value)
      (begin (+ 0 1) (+ 0 2)))

    (define (all-sequence-expressions-are-evaluated)
      ((lambda (x)
        (begin (set! x (+ x 1)) (set! x (+ x 2)) (set! x (+ x 3))) x) 0))

    (define (sequence-expressions-are-evaluated-in-order)
      ((lambda (x)
        (begin (set! x (+ x 1)) (set! x (* x 10)) (set! x (/ x 10))) x) 0))
  )
)