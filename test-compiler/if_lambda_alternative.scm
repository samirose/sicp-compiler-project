(begin
  (if ((lambda (x) (> x 0)) 0)
      ((lambda (x) (+ x 1)) 1)
      ((lambda (x) (+ x 2)) 2)))
