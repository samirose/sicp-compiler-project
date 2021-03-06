(begin
  (define (gcd a b)
    (if (= b 0)
        a
        (gcd b (remainder a b))))

  (define (remainder n d)
    (if (< n d)
        n
        (remainder (- n d) d)))

  (gcd 480 28))
