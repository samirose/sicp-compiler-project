(define-library
    (type-errors)

  (export
   plus-two
   two-times
   lambda-two-times
   procedure-plus-two
   apply-to
   unspecified-plus-two
   unspecified-as-operator)

  (import (scheme base))

  (begin
    (define (plus-two x)
      (+ x 2))

    (define (two-times x)
      (* 2 x))

    (define (lambda-two-times)
      (two-times (lambda (x) (* x x))))

    (define (procedure-plus-two)
      (plus-two two-times))

    (define (apply-to o p)
      (o p))

    (define (unspecified-plus-two)
      (plus-two (cond (#f 42))))

    (define (unspecified-as-operator x)
      ((cond (#f (lambda (x) (+ x 1)))) x))

    )
  )
