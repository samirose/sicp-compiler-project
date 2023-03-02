; SICP exercise 1.19

; Tpq: a <- bq + aq + ap, b <- bp + aq
; Compute (Tpq)^2
; a1 = bq + aq + ap, b1 = bp + aq
; b2 = b1p + a1p
; b2 = (bp + aq)p + (bq + aq + ap)p
;    = bp^2 + aqp + bqp + aqp + apq
;    = bp^2 + 2apq + bq^2 + aq^2
;    = b(p^2 + q^2) + a(2pq + q^2)
; -> p ́ = p^2 + q^2, q ́ = 2pq + q^2

(define-library
  (sicp-exercise-1-19)

  (export fib)

  (import (scheme base))

  (begin
    (define (square x) (* x x))

    (define (even?-exp-neg x e)
      (cond ((= x  0) #t)
	    ((= x -1) #f)
	    ((<= x e) (even?-exp-neg (- x e) (* e 2)))
	    (else (even?-exp-neg x (/ e 2)))))

    (define (even? x)
      (even?-exp-neg (if (> x 0) (- x) x) -2))

    (define (fib-iter a b p q count)
      (cond ((= count 0) b)
            ((even? count)
             (fib-iter a
                       b
                       (+ (square p) (square q)) ; p′
                       (+ (* 2 p q) (square q)) ; q′
                       (/ count 2)))
            (else
             (fib-iter (+ (* b q) (* a q) (* a p))
                       (+ (* b p) (* a q))
                       p
                       q
                       (- count 1)))))

    (define (fib n) (fib-iter 1 0 0 1 n))
    )
  )
