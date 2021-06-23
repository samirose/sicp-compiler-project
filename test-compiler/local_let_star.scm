(define-library
  (export constant-let*
          expression-let*
          let*-shadowing
          let*-in-lambda
          let*-value-referring-lambda-arg
          let*-value-shadowing-lambda-arg
          lambda-as-let*-value
          mutate-locals
          get-global-with-let*-value
          get-global-assigned-with-let*-value)

  (import (scheme base))

  (begin
    (define (constant-let*)
      (let* ((a 2))
        (+ 40 a)))

    (define (expression-let*)
      (let* ((a (* 2 3))
             (b (* 5 a)))
        b))

    (define (let*-shadowing)
      (let* ((a 2) (b 3) (b 5))
          (* a b)))

    (define (let*-in-lambda)
      ((lambda (x)
         (let* ((a 2))
           (* a x)))
       5))

    (define (let*-value-referring-lambda-arg)
      ((lambda (x)
         (let* ((a (* x 2)))
           (* a x)))
       3))

    (define (let*-value-shadowing-lambda-arg)
      ((lambda (x)
         (let* ((x (* x 2)))
           (* x x)))
       3))

    (define (lambda-as-let*-value)
      (let* ((prod (* 2 3))
             (double (lambda (x) (+ x x))))
        (double prod)))

    (define (mutate-locals)
      (let* ((a 1) (b 2) (b (+ a b 3)))
        (set! a b)
        (set! b (+ b 1))
        (+ a b)))

    (define global-with-let*-value
      (let* ((x 2) (y (+ x 1)))
        (+ x y)))

    (define (get-global-with-let*-value)
      global-with-let*-value)

    (define global-assigned-with-let*-value 0)

    (define (get-global-assigned-with-let*-value)
      global-assigned-with-let*-value)

    (set! global-assigned-with-let*-value
      (let* ((a 2) (b 3) (b (+ a b 4)))
        b))
  )
)
