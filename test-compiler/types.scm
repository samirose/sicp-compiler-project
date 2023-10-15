(define-library
  (types)

  (export
   is-number?
   is-zero?
   is-eq?
   numeric-exp-is-number?
   is-boolean?
   eq?-evaluates-to-boolean-value
   arithmetic-comparison-operators-evaluate-to-boolean-values
   is-procedure?
   lambda-is-procedure?
   defined-procedure-is-procedure?
   imported-procedure-is-procedure?
   procedure-argument-is-procedure?
   procedure-from-procedure-is-procedure?
   is-procedure-eq-to-same-procedure?
   is-procedure-eq-to-different-procedure?
   is-procedure-number?-eq-to
   symbol-is-symbol?
   is-symbol?
   procedure-is-symbol?)

  (import (scheme base))

  (begin
    (define (is-number? x)
      (number? x))

    (define (is-zero? x)
      (zero? x))

    (define (is-eq? x y)
      (eq? x y))

    (define (numeric-exp-is-number?)
      (number? (+ 1 2)))

    (define (is-boolean? x)
      (boolean? x))

    (define (eq?-evaluates-to-boolean-value)
      (and (boolean? (eq? 1 1))
           (boolean? (eq? 1 2))))

    (define (arithmetic-comparison-operators-evaluate-to-boolean-values)
      (and (boolean? (< 1 2))
           (boolean? (< 2 1))
           (boolean? (<= 1 2))
           (boolean? (<= 2 1))
           (boolean? (= 1 1))
           (boolean? (> 2 1))
           (boolean? (> 1 2))
           (boolean? (>= 2 1))
           (boolean? (>= 1 2))))

    (define (is-procedure? x)
      (procedure? x))

    (define (lambda-is-procedure?)
      (procedure? (lambda (x) (+ x x))))

    (define (defined-procedure-is-procedure?)
      (procedure? lambda-is-procedure?))

    (define (imported-procedure-is-procedure?)
      (procedure? number?))

    (define (procedure-argument-is-procedure?)
      (and (is-procedure? (lambda (x) (* x x)))
           (is-procedure? is-number?)
           (is-procedure? zero?)))

    (define (doubler)
      (lambda (x) (+ x x)))

    (define (procedure-from-procedure-is-procedure?)
      (procedure? (doubler)))

    (define (is-procedure-eq-to-same-procedure?)
      (eq? number? number?))

    (define (is-procedure-eq-to-different-procedure?)
      (or (eq? number? zero?) (eq? zero? number?)))

    (define (is-procedure-number?-eq-to x)
      (eq? number? x))

    (define (symbol-is-symbol?)
      (symbol? 'sym))

    (define (is-symbol? x)
      (symbol? x))

    (define (procedure-is-symbol?)
      (symbol? doubler))

))
