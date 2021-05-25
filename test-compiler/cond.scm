(define-library
  (export no-clauses
          single-exp
          single-exp-else
          test-and-exp
          test-and-exp-else
          only-else
          nested
          short-circuit
          sequence-exps
          lambda-exps)

  (import (scheme base))

  (begin
    (define (no-clauses)
      (cond))

    (define (single-exp x)
      (cond (x)))

    (define (single-exp-else x)
      (cond (x)
            (else 2)))

    (define (test-and-exp x)
      (cond ((= x 1) (+ x 1))))

    (define (test-and-exp-else x)
      (cond ((< x 10) (+ x 1))
            (else (- x 1))))

    (define (only-else)
      (cond (else 42)))

    (define (nested x)
      (cond ((< x 10)
             (cond ((> x 0) (+ x 1))
                   (else 0)))
            (else (- x 1))))

    (define (short-circuit x)
      (let ((step 0))
        (cond
          ((> x 1) (set! step (+ step 2)))
          ((> x 0) (set! step (+ step 1)))
          (else (set! step (+ step 3))))
        step))

    (define (sequence-exps x)
      (let ((step 0))
        (cond
          ((> x 1) (set! step (+ step 2)) step)
          ((> x 0) (set! step (+ step 1)) step)
          (else (set! step (+ step 3)) step))))

    (define (lambda-exps x)
      ((cond ((> x 1) (lambda (x) (+ x 2)))
             ((> x 0) (lambda (x) (+ x 1)))
             (else (lambda (x) (+ x 3)))) x))
    )
  )
