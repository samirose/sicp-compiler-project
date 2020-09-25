(define-library 
  (export square minus)
  (begin
    (define (square x) (* x x))
    (define (minus x y) (- x y))))
