(define-library
  (local-let)

  (export constant-let
          expression-let
          multi-variable-let
          nested-let
          nested-let-referring-outer-let
          let-shadowing-let
          let-in-lambda
          let-value-referring-lambda-arg
          let-value-shadowing-lambda-arg
          lambda-as-let-value
          mutate-locals
          get-global-with-let-value
          get-global-assigned-with-let-value)

  (import (scheme base))

  (begin
    (define (constant-let)
      (let ((a 2))
        (+ 40 a)))

    (define (expression-let)
      (let ((a (* 2 3)))
        (* 5 a)))

    (define (multi-variable-let)
      (let ((a 2) (b 3))
        (* a b)))

    (define (nested-let)
      (let ((a 2))
        (let ((b 3))
          (* a b))))

    (define (nested-let-referring-outer-let)
      (let ((a 2))
        (let ((b (+ a 1)))
          (* a b))))

    (define (let-shadowing-let)
      (let ((a 2) (b 3))
        (let ((b 5))
          (* a b))))

    (define (let-in-lambda)
      ((lambda (x)
         (let ((a 2))
           (* a x)))
       5))

    (define (let-value-referring-lambda-arg)
      ((lambda (x)
         (let ((a (* x 2)))
           (* a x)))
       3))

    (define (let-value-shadowing-lambda-arg)
      ((lambda (x)
         (let ((x (* x 2)))
           (* x x)))
       3))

    (define (lambda-as-let-value)
      (let ((prod (* 2 3))
            (double (lambda (x) (+ x x))))
        (double prod)))

    (define (mutate-locals)
      (let ((a 1) (b 2))
        (let ((c 3))
          (set! a b)
          (set! b c)
          (set! c (+ c 1))
          (+ a b c))))

    (define global-with-let-value
      (let ((x 2) (y 3))
        (+ x y)))

    (define (get-global-with-let-value)
      global-with-let-value)

    (define global-assigned-with-let-value 0)

    (define (get-global-assigned-with-let-value)
      global-assigned-with-let-value)

    (set!
      global-assigned-with-let-value
      (let ((a 2) (b 3))
        (let ((c 4))
          (+ a b c))))
  )
)
