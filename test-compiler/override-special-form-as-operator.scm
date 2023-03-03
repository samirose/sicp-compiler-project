(define-library
  (override-special-form-as-operator)

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
      (let ((quote (lambda (x) (+ x 2))))
        (quote 40)))

    (define (quote-arg quote)
      (quote 2))

    (define (override-quote-arg)
      (quote-arg (lambda (x) (+ x 40))))

    (define (override-define-let)
      (let ((define (lambda (x) (+ x 2))))
        (define 40)))

    (define (define-arg define)
      (define 2))

    (define (override-define-arg)
      (define-arg (lambda (x) (+ x 40))))

    (define (override-lambda-let)
      (let ((lambda (lambda (x) (+ x 2))))
        (lambda 40)))

    (define (lambda-arg lambda)
      (lambda 2))

    (define (override-lambda-arg)
      (lambda-arg (lambda (x) (+ x 40))))

    (define (override-special-symbols-let*)
      (let* ((if (lambda (cond x) (cond x)))
             (set! (lambda (x) (+ x 2))))
        (if set! 40)))
  )
)
