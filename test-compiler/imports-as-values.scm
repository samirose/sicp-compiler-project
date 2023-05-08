(define-library (imports-as-values)

  (import (scheme base))

  (export imported-procedure-value-is-procedure
          apply-number?-as-value)

  (begin
    (define (get-number?)
      number?)

    (define (pred? p? x)
      (p? x))

    (define (imported-procedure-value-is-procedure)
      (procedure? (get-number?)))

    (define (apply-number?-as-value x)
      ((get-number?) x))

    ))
