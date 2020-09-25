(define-library
    (export
        plus-zero-to-positive
        plus-positive-result
        signed-plus-positive-result
        signed-plus-zero-result
        signed-plus-negative-result
        plus-zero-to-negative
        plus-multiple
        complex)

    (begin
        (define (plus-zero-to-positive) (+ 0 2))
        (define (plus-positive-result) (+ 1 2))
        (define (signed-plus-positive-result) (+ 2 -1))
        (define (signed-plus-zero-result) (+ 2 -2))
        (define (signed-plus-negative-result) (+ 2 -3))
        (define (plus-zero-to-negative) (+ -2 0))
        (define (plus-multiple) (+ 1 2 3))

        (define (complex) (+ (/ (* 2 -6 2) 3 2) (- 10 10 6) 2))
    )
)
