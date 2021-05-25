(define-library

  (export
    empty-and-is-true
    and-one-false-is-false
    and-one-non-false-value-is-value
    and-two-non-falses-is-last-value
    and-any-false-is-false
    and-with-complex-expressions
    and-evaluates-expressions-from-left-to-right
    and-false-short-circuits-to-false)

  (import (scheme base))

  (begin
    (define (empty-and-is-true)
      (and))

    (define (and-one-false-is-false)
      (and #f))

    (define (and-one-non-false-value-is-value)
      (and 42))

    (define (and-two-non-falses-is-last-value)
      (and 1 2))

    (define (and-any-false-is-false)
      (if (and #f 2)
        #t
        (if (and 1 #f)
          #t
          #f)))

    (define (and-with-complex-expressions)
      (and (+ 0 1)
           ((lambda (x) (if x #f #t)) #f)
           (let ((x 1)) (* x 2))))

    (define (and-evaluates-expressions-from-left-to-right)
      (let ((step 0))
        (and (begin (set! step 1) 1)
             (begin (set! step 2) 2)
             (begin (set! step 3) 3))
        step))

    (define (and-false-short-circuits-to-false)
      (let ((step 0))
        (and (begin (set! step 1) 1)
             (begin (set! step 2) #f)
             (begin (set! step 3) 3))
        step))
  )
)
