(define-library
  (test-override-special-form-as-variable)

  (export override-quote-let
          override-quote-arg
          override-define-let
          override-define-arg
          override-lambda-let
          override-lambda-arg
          override-special-symbols-let*)

  (import (scheme base))

  (begin
    (define (override-quote-let)
      (let ((quote (+ 40 2)))
        quote))

    (define (override-quote-arg quote)
      (+ quote 1))

    (define (override-define-let)
      (let ((define 42))
        define))

    (define (override-define-arg define)
      (+ define 1))

    (define (override-lambda-let)
      (let ((lambda (+ 40 2)))
        lambda))

    (define (override-lambda-arg lambda)
      (+ lambda 1))

    (define (override-special-symbols-let*)
      (let* ((if 40)
             (set! 2))
        (+ if set!)))
  )
)
