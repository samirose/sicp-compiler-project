(import (scheme base))
(import (scheme write))
(import (values))

(define fixnum-nonzero-test-values
  (list 1 -1 42 -42 fixnum-max fixnum-min))

(define fixnum-test-values
  (cons 0 fixnum-nonzero-test-values))

(define funcidx-test-values
  '(0 1 42))

(define eq?-test-cases
  (list
   ;; number
   (list (number->fixnum-value 0) (number->fixnum-value 1) false-value)
   (list (number->fixnum-value 0) (number->fixnum-value 0) true-value)
   (list (number->fixnum-value 1) (number->fixnum-value 1) true-value)
   (list (number->fixnum-value 42) (number->fixnum-value 42) true-value)
   (list (number->fixnum-value fixnum-max) (number->fixnum-value fixnum-min) false-value)
   (list (number->fixnum-value fixnum-max) (number->fixnum-value fixnum-max) true-value)
   (list (number->fixnum-value fixnum-min) (number->fixnum-value fixnum-min) true-value)
   ;; boolean
   (list false-value true-value false-value)
   (list true-value true-value true-value)
   (list false-value false-value true-value)
   ;; procedure
   (list (funcidx->procedure-value 0) (funcidx->procedure-value 1) false-value)
   (list (funcidx->procedure-value 0) (funcidx->procedure-value 0) true-value)
   (list (funcidx->procedure-value 1) (funcidx->procedure-value 1) true-value)
   (list (funcidx->procedure-value 42) (funcidx->procedure-value 42) true-value)
   ;; mixed
   (list (number->fixnum-value 1) true-value false-value)
   (list (number->fixnum-value 0) false-value false-value)
   (list (number->fixnum-value 42) true-value false-value)
   (list (number->fixnum-value 42) false-value false-value)
   (list (number->fixnum-value 42) (funcidx->procedure-value 42) false-value)
   (list (number->fixnum-value 42) unspecified-value false-value)
   (list false-value (funcidx->procedure-value 0) false-value)
   (list true-value (funcidx->procedure-value 1) false-value)
   (list false-value (funcidx->procedure-value 42) false-value)
   (list true-value (funcidx->procedure-value 42) false-value)
   (list false-value unspecified-value false-value)
   (list true-value unspecified-value false-value)
   ))


(define scheme-base-wast
  `(
    ;; fixnum tests
    ,@(map
       (lambda (n)
         `(assert_return (invoke "i32->fixnum" (i32.const ,n)) (i32.const ,(number->fixnum-value n))))
       fixnum-test-values)

    ,@(map
       (lambda (n)
         `(assert_return (invoke "fixnum->i32" (i32.const ,(number->fixnum-value n))) (i32.const ,n)))
       fixnum-test-values)

    ,@(map
       (lambda (n)
         `(assert_return (invoke "number?" (i32.const ,(number->fixnum-value n))) (i32.const ,true-value)))
       fixnum-test-values)

    ,@(map
       (lambda (n)
         `(assert_return (invoke "boolean?" (i32.const ,(number->fixnum-value n))) (i32.const ,false-value)))
       fixnum-test-values)

    ,@(map
       (lambda (n)
         `(assert_return (invoke "procedure?" (i32.const ,(number->fixnum-value n))) (i32.const ,false-value)))
       fixnum-test-values)

    ,@(map
       (lambda (n)
         `(assert_return (invoke "symbol?" (i32.const ,(number->fixnum-value n))) (i32.const ,false-value)))
       fixnum-test-values)

    ,@(map
       (lambda (n)
         `(assert_return (invoke "string?" (i32.const ,(number->fixnum-value n))) (i32.const ,false-value)))
       fixnum-test-values)

    ,@(map
       (lambda (n)
         `(assert_return (invoke "check-initialized" (i32.const ,(number->fixnum-value n))) (i32.const ,(number->fixnum-value n))))
       fixnum-test-values)

    ,@(map
       (lambda (n)
         `(assert_return (invoke "zero?" (i32.const ,(number->fixnum-value n))) (i32.const ,false-value)))
       fixnum-nonzero-test-values)

    (assert_return (invoke "zero?" (i32.const ,(number->fixnum-value 0))) (i32.const ,true-value))

    ;; boolean tests
    (assert_return (invoke "i32->boolean" (i32.const 0)) (i32.const ,false-value))
    (assert_return (invoke "i32->boolean" (i32.const 1)) (i32.const ,true-value))
    (assert_return (invoke "boolean->i32" (i32.const ,false-value)) (i32.const 0))
    (assert_return (invoke "boolean->i32" (i32.const ,true-value)) (i32.const 1))
    (assert_return (invoke "boolean?" (i32.const ,false-value)) (i32.const ,true-value))
    (assert_return (invoke "boolean?" (i32.const ,true-value)) (i32.const ,true-value))
    (assert_return (invoke "boolean?" (i32.const 0)) (i32.const ,false-value))
    (assert_return (invoke "boolean?" (i32.const 1)) (i32.const ,false-value))

    ,@(map
       (lambda (n)
         `(assert_return (invoke "boolean->i32" (i32.const ,(number->fixnum-value n))) (i32.const 1)))
       fixnum-test-values)

    ,@(map
       (lambda (i)
         `(assert_return (invoke "boolean->i32" (i32.const ,(funcidx->procedure-value i))) (i32.const 1)))
       funcidx-test-values)

    (assert_return (invoke "number?" (i32.const ,false-value)) (i32.const ,false-value))
    (assert_return (invoke "number?" (i32.const ,true-value)) (i32.const ,false-value))

    (assert_return (invoke "procedure?" (i32.const ,false-value)) (i32.const ,false-value))
    (assert_return (invoke "procedure?" (i32.const ,true-value)) (i32.const ,false-value))

    (assert_return (invoke "symbol?" (i32.const ,false-value)) (i32.const ,false-value))
    (assert_return (invoke "symbol?" (i32.const ,true-value)) (i32.const ,false-value))

    (assert_return (invoke "string?" (i32.const ,false-value)) (i32.const ,false-value))
    (assert_return (invoke "string?" (i32.const ,true-value)) (i32.const ,false-value))

    (assert_return (invoke "check-initialized" (i32.const ,false-value)) (i32.const ,false-value))
    (assert_return (invoke "check-initialized" (i32.const ,true-value)) (i32.const ,true-value))

    ;; procedure tests
    ,@(map
       (lambda (i)
         `(assert_return (invoke "funcidx->procedure" (i32.const ,i)) (i32.const ,(funcidx->procedure-value i))))
       funcidx-test-values)

    ,@(map
       (lambda (i)
         `(assert_return (invoke "procedure->funcidx" (i32.const ,(funcidx->procedure-value i))) (i32.const ,i)))
       funcidx-test-values)

    ,@(map
       (lambda (i)
         `(assert_return (invoke "procedure?" (i32.const ,(funcidx->procedure-value i))) (i32.const ,true-value)))
       funcidx-test-values)

    ,@(map
       (lambda (i)
         `(assert_return (invoke "number?" (i32.const ,(funcidx->procedure-value i))) (i32.const ,false-value)))
       funcidx-test-values)

    ,@(map
       (lambda (i)
         `(assert_return (invoke "boolean?" (i32.const ,(funcidx->procedure-value i))) (i32.const ,false-value)))
       funcidx-test-values)

    ,@(map
       (lambda (i)
         `(assert_return (invoke "symbol?" (i32.const ,(funcidx->procedure-value i))) (i32.const ,false-value)))
       funcidx-test-values)

    ,@(map
       (lambda (i)
         `(assert_return (invoke "string?" (i32.const ,(funcidx->procedure-value i))) (i32.const ,false-value)))
       funcidx-test-values)

    ,@(map
       (lambda (i)
         `(assert_return (invoke "check-initialized" (i32.const ,(funcidx->procedure-value i))) (i32.const ,(funcidx->procedure-value i))))
       funcidx-test-values)

    ;; unpsecified value tests
    (assert_return (invoke "number?" (i32.const ,unspecified-value)) (i32.const ,false-value))
    (assert_return (invoke "boolean?" (i32.const ,unspecified-value)) (i32.const ,false-value))
    (assert_return (invoke "procedure?" (i32.const ,unspecified-value)) (i32.const ,false-value))
    (assert_return (invoke "symbol?" (i32.const ,unspecified-value)) (i32.const ,false-value))
    (assert_return (invoke "string?" (i32.const ,unspecified-value)) (i32.const ,false-value))
    (assert_return (invoke "check-initialized" (i32.const ,unspecified-value)) (i32.const ,unspecified-value))

    ;; uninitialized value tests
    (assert_return (invoke $scheme-base "get-error-code") (i32.const ,error-no-error))
    (assert_trap (invoke "check-initialized" (i32.const ,uninitialized-value)) "unreachable")
    (assert_return (invoke $scheme-base "get-error-code") (i32.const ,error-uninitialized))

    ;; error-code is initially no error
    (assert_return (invoke "get-error-code") (i32.const ,error-no-error))

    ;; raise-error sets error code and traps
    (assert_trap (invoke "raise-error" (i32.const 99)) "unreachable")
    (assert_return (invoke "get-error-code") (i32.const 99))

    ;; Converting a non-fixnum with fixnum->i32 causes a trap and error-code being set
    (assert_trap (invoke "fixnum->i32" (i32.const 0)) "unreachable")
    (assert_return (invoke "get-error-code") (i32.const ,error-expected-number))

    ;; Error code is reset after reading it with get-error-code
    (assert_return (invoke "get-error-code") (i32.const ,error-no-error))

    ;; Calling zero? on non-fixum causes a trap and error-code being set
    (assert_trap (invoke "zero?" (i32.const 0)) "unreachable")
    (assert_return (invoke "get-error-code") (i32.const ,error-expected-number))

    ;; Converting a non-procedure with procedure->funcidx causes a trap and error-code being set
    (assert_trap (invoke "procedure->funcidx" (i32.const ,false-value)) "unreachable")
    (assert_return (invoke "get-error-code") (i32.const ,error-expected-procedure))

    ;; eq? tests
    ,@(map
       (lambda (t)
         `(assert_return (invoke "eq?" (i32.const ,(car t)) (i32.const ,(cadr t))) (i32.const ,(caddr t))))
       eq?-test-cases)

    ,@(map
       (lambda (t)
         `(assert_return (invoke "eq?" (i32.const ,(cadr t)) (i32.const ,(car t))) (i32.const ,(caddr t))))
       eq?-test-cases)
    ))

(let emit ((statements scheme-base-wast))
  (cond ((null? statements) (newline))
        (else
         (write (car statements))
         (newline)
         (emit (cdr statements)))))
