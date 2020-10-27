(begin
  (define (prodsum x y)
    (let ((prod (* x y))
          (double (lambda (x) (+ x x))))
      (double prod)))
  (prodsum 2 3))
