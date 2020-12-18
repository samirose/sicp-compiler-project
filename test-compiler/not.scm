(define-library

  (export
    not-true-is-false
    not-false-is-true
    not-non-false-value-is-false
    not-true-expression-is-false
    not-non-false-expression-is-false
    not-false-expression-is-true)

  (begin
    (define (not-true-is-false)
      (not #t))

    (define (not-false-is-true)
      (not #f))

    (define (not-non-false-value-is-false)
      (not 42))

    (define (not-true-expression-is-false)
      (not (> 1 0)))

    (define (not-non-false-expression-is-false)
      (not ((lambda (x) (+ x 1)) 2)))

    (define (not-false-expression-is-true)
      (not (> 0 1)))
  )
)
