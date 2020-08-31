(begin
  (if ((lambda (x) (> x 0)) 1)
      ((lambda (x) (+ x 1)) 1)
      3))
