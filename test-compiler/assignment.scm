(define-library

  (export set!-local-lambda)
  (export set!-local-let)
  (export set!-global)

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
    )
  )
