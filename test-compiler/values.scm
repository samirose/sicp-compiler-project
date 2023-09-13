(define-library (values)

  (export
   number quoted-number quoted-number-is-number?
   boolean-true boolean-false quoted-boolean-true quoted-boolean-false quoted-boolean-is-boolean?)

  (import (scheme base))

  (begin
    (define (number) 42)
    (define (quoted-number) (quote 53))
    (define (quoted-number-is-number?) (number? (quote 1)))

    (define (boolean-true) #t)
    (define (boolean-false) #f)

    (define (quoted-boolean-true) (quote #t))
    (define (quoted-boolean-false) (quote #f))
    (define (quoted-boolean-is-boolean?)
      (and (boolean? (quote #f)) (boolean? (quote #t)))))
  )
