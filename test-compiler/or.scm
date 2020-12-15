(define-library

  (export
    empty-or-is-false
    or-one-false-is-false
    or-one-non-false-value-is-value
    or-two-non-falses-is-first-value
    or-any-non-false-is-non-false
    or-with-complex-expressions
    or-evaluates-expressions-from-left-to-right
    or-true-short-circuits-to-true)

  (begin
    (define (empty-or-is-false)
      (or))

    (define (or-one-false-is-false)
      (or #f))

    (define (or-one-non-false-value-is-value)
      (or 42))

    (define (or-two-non-falses-is-first-value)
      (or 1 2))

    (define (or-any-non-false-is-non-false)
      (if (or #f 2)
        (if (or 1 #f)
          #t
          #f)
        #f))

    (define (or-with-complex-expressions)
      (or ((lambda (x) (if x #t #f)) #f)
          (> (+ 0 1) 2)
          (let ((x 1)) (* x 2))))

    (define (or-evaluates-expressions-from-left-to-right)
      (let ((step 0))
        (if (or
              (begin (set! step 1) (> step 1))
              (begin (set! step 2) (> step 2))
              (begin (set! step 3) 3))
            step
            #f)))

    (define (or-true-short-circuits-to-true)
      (let ((step 0))
        (or (begin (set! step 1) #f)
            (begin (set! step 2) 2)
            (begin (set! step 3) 3))
        step))
  )
)
