(begin
  (define x 1)
  (if (= x 1) (set! x (+ x 2)))
  x)