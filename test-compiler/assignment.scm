(define-library
  (assignment)

  (export set!-local-lambda)
  (export set!-local-let)
  (export set!-global)
  (export get-global)
  (export increment-global!)
  (export get-lambda-computed-global)

  (import (scheme base))

  (begin
    (define (set!-local-lambda)
      ((lambda (x)
         (set! x 10)
         (+ x 3))
       5))

    (define (set!-local-let)
      (let ((x 5))
        (set! x 10)
        (+ x 3)))

    (define a 5)

    (define (set!-global)
      (set! a 10)
      (+ a 3))

    (define b 0)
    (set! b 5)

    (define (get-global) b)

    (define (increment-global!)
      (set! b (+ b 1)))

    (define c 0)
    (set! c ((lambda (x) (+ x x)) 11))

    (define (get-lambda-computed-global) c)
  )
)
