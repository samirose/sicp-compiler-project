(define-library
    (eqv)

  (export
   eqv-literals
   eqv-proc-reference-to-same-proc-reference
   eqv-proc-reference-to-different-proc-reference
   eqv-proc-reference-to-lambda
   eqv-lambda-to-lambda-with-different-form
   eqv-lambda-to-lambda-with-same-form-is-boolean
   eqv-procedure-to-literal
   eqv-symbol-literal-with-same-symbol-literal
   eqv-symbol-reference-with-same-symbol-literal
   eqv-symbol-reference-with-same-reference
   eqv-symbol-to-literal
   eqv-symbol-to-procedure
   eqv-string-to-same-string-location
   eqv-string-to-string-literal-is-boolean
   eqv-string-to-literal
   eqv-string-to-procedure
   eqv-string-to-symbol)

  (import (scheme base))

  (begin
    ;; literals
    (define (eqv-literals x y)
      (eqv? x y))

    ;; procedures
    (define (proc x) (* x x))
    (define (proc2 x) (+ x x))

    (define (eqv-proc-reference-to-same-proc-reference)
      (and
       (eqv? proc proc)
       (let ((p (lambda (x) x)))
         (eqv? p p))))

    (define (eqv-proc-reference-to-different-proc-reference)
      (eqv? proc proc2))

    (define (eqv-proc-reference-to-lambda)
      (eqv? proc (lambda (x) (* x x))))

    (define (eqv-lambda-to-lambda-with-different-form)
      (eqv? (lambda (x) (+ x 1)) (lambda (y) (+ y 2))))

    (define (eqv-lambda-to-lambda-with-same-form-is-boolean)
      (boolean? (eqv? (lambda (x) (* x x)) (lambda (y) (* y y)))))

    (define (eqv-procedure-to-literal x)
      (or (eqv? proc x)
          (eqv? x proc)
          (eqv? (lambda (x) x) x)
          (eqv? x (lambda (y) (+ y 1)))))

    ;; symbols
    (define symbref 'symb)

    (define (eqv-symbol-literal-with-same-symbol-literal)
      (eqv? 'foo 'foo))

    (define (eqv-symbol-reference-with-same-symbol-literal)
      (and (eqv? symbref 'symb)
           (eqv? 'symb symbref)))

    (define (eqv-symbol-reference-with-same-reference)
      (eqv? symbref symbref))

    (define (eqv-symbol-to-literal x)
      (or (eqv? 'symb x) (eqv? symbref x)
          (eqv? x 'symb) (eqv? x symbref)))

    (define (eqv-symbol-to-procedure)
      (or (eqv? 'symb proc) (eqv? symbref proc)
          (eqv? proc 'symb) (eqv? proc symbref)
          (eqv? 'symb (lambda (x) x)) (eqv? (lambda (y) (+ y 1)) symbref)))

    ;; strings
    (define (eqv-string-to-same-string-location)
      (and
       (let ((s ""))
         (eqv? s s))
       (let ((s "foobarxyzzy"))
         (eqv? s s))))

    (define (eqv-string-to-string-literal-is-boolean)
      (and
       (boolean? (eqv? "" ""))
       (boolean? (eqv? "foobar1234" "foobar1234"))
       (boolean? (eqv? "x" "y"))))

    (define (eqv-string-to-literal x)
      (or (eqv? "foo" x) (eqv? x "")))

    (define (eqv-string-to-procedure)
      (or (eqv? "proc" proc) (eqv? proc "")
          (eqv? "lambda" (lambda (x) x)) (eqv? (lambda (y) (+ y 1)) "lambda")))

    (define (eqv-string-to-symbol)
      (or (eqv? "symb" 'symb) (eqv? 'symb "symb")
          (eqv? "" symbref) (eqv? symbref "foo")))

    )
  )
