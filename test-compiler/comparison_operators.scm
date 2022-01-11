(define-library
  (test-comparison-operators)

  (export
    all-with-single-argument-are-true
    binary-equal
    binary-greater-than
    binary-less-than
    binary-greater-or-equal-than
    binary-less-or-equal-than
    more-than-two-params-true
    more-than-two-params-false)

  (import (scheme base))

  (begin
    (define (all-with-single-argument-are-true)
      (and (= 1) (< 2) (> 2) (<= 3) (>= 4)))

    (define (binary-equal x y)
      (= x y))

    (define (binary-greater-than x y)
      (> x y))

    (define (binary-less-than x y)
      (< x y))

    (define (binary-greater-or-equal-than x y)
      (>= x y))

    (define (binary-less-or-equal-than x y)
      (<= x y))

    (define (more-than-two-params-true)
      (and (= 1 1 1) (< 1 2 3 4) (> 3 2 1 0 -1) (<= 1 2 2 3) (>= 3 2 2 1)))

    (define (more-than-two-params-false)
      (or (= 1 1 0) (< 1 2 4 3) (> 3 2 1 -1 0) (<= 1 2 0 2) (>= 3 2 3 2)))
  )
)
