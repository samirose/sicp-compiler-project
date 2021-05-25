(define-library

  (import (scheme base))

  (begin
    (define (proc x) (+ y x))
    (define y 2)
    (proc 40)))
