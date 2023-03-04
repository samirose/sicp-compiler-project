(define-library
  (recursive-definition)

  (export gcd-test)

  (import (scheme base))

  (begin
    (define (remainder-exp-positive n d e)
      (cond ((< n d) n)
            ((<= e n) (remainder-exp-positive (- n e) d (* e d)))
            (else     (remainder-exp-positive n d (/ e d)))))

    ;; undefined for d=0
    (define (remainder-positive n d)
      (remainder-exp-positive n d d))

    (define (gcd-positive a b)
      (if (= b 0)
          a
          (gcd-positive b (remainder-positive a b))))

    (define (gcd-test a b)
      (let ((a (if (< a 0) (- a) a))
            (b (if (< b 0) (- b) b)))
        (gcd-positive a b)))
    )
)
