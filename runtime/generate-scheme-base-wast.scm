(import (scheme base))
(import (scheme write))
(import (values))

(define fixnum-nonzero-test-values
  (list 1 -1 42 -42 fixnum-max fixnum-min))

(define fixnum-test-values
  (cons 0 fixnum-nonzero-test-values))

(define funcidx-test-values
  '(0 1 42))

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
         `(assert_return (invoke "check-initialized" (i32.const ,(funcidx->procedure-value i))) (i32.const ,(funcidx->procedure-value i))))
       funcidx-test-values)

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

    ;; helper module for testing conversions
    (module
     (import "scheme base" "i32->fixnum"  (func $i32->fixnum  (param i32) (result i32)))
     (import "scheme base" "number?"      (func $number?      (param i32) (result i32)))
     (import "scheme base" "i32->boolean" (func $i32->boolean (param i32) (result i32)))
     (import "scheme base" "boolean?"     (func $boolean?     (param i32) (result i32)))
     (import "scheme base" "funcidx->procedure" (func $funcidx->procedure  (param i32) (result i32)))
     (import "scheme base" "procedure?"         (func $procedure?          (param i32) (result i32)))
     (import "scheme base" "eq?" (func $eq? (param i32) (param i32) (result i32)))
     (import "scheme base" "check-initialized"   (func $check-initialized (param i32) (result i32)))

     (func (export "unspecified-value->number?") (result i32)
           i32.const ,unspecified-value
           call $number?)

     (func (export "unspecified-value->boolean?") (result i32)
           i32.const ,unspecified-value
           call $boolean?)

     (func (export "unspecified-value->procedure?") (result i32)
           i32.const ,unspecified-value
           call $procedure?)

     (func (export "i32->fixnum-i32->fixnum-eq?") (param i32) (param i32) (result i32)
           local.get 0
           call $i32->fixnum
           local.get 1
           call $i32->fixnum
           call $eq?)

     (func (export "i32->boolean-i32->boolean-eq?") (param i32) (param i32) (result i32)
           local.get 0
           call $i32->boolean
           local.get 1
           call $i32->boolean
           call $eq?)

     (func (export "funcidx->procedure-funcidx->procedure-eq?") (param i32) (param i32) (result i32)
           local.get 0
           call $funcidx->procedure
           local.get 1
           call $funcidx->procedure
           call $eq?)

     (func (export "i32->fixnum-i32->boolean-eq?") (param i32) (param i32) (result i32)
           local.get 0
           call $i32->fixnum
           local.get 1
           call $i32->boolean
           call $eq?)

     (func (export "unspecified-value->check-initialized") (result i32)
           i32.const ,unspecified-value
           call $check-initialized)

     (func (export "uninitialized-value->check-initialized") (result i32)
           i32.const ,uninitialized-value
           call $check-initialized)
     )

    (assert_return (invoke "i32->fixnum-i32->fixnum-eq?" (i32.const 0) (i32.const 1)) (i32.const ,false-value))
    (assert_return (invoke "i32->fixnum-i32->fixnum-eq?" (i32.const 1) (i32.const 0)) (i32.const ,false-value))
    (assert_return (invoke "i32->fixnum-i32->fixnum-eq?" (i32.const 0) (i32.const 0)) (i32.const ,true-value))
    (assert_return (invoke "i32->fixnum-i32->fixnum-eq?" (i32.const 1) (i32.const 1)) (i32.const ,true-value))
    (assert_return (invoke "i32->fixnum-i32->fixnum-eq?" (i32.const 42) (i32.const 42)) (i32.const ,true-value))

    (assert_return (invoke "i32->boolean-i32->boolean-eq?" (i32.const 0) (i32.const 1)) (i32.const ,false-value))
    (assert_return (invoke "i32->boolean-i32->boolean-eq?" (i32.const 1) (i32.const 0)) (i32.const ,false-value))
    (assert_return (invoke "i32->boolean-i32->boolean-eq?" (i32.const 0) (i32.const 0)) (i32.const ,true-value))
    (assert_return (invoke "i32->boolean-i32->boolean-eq?" (i32.const 1) (i32.const 1)) (i32.const ,true-value))

    (assert_return (invoke "funcidx->procedure-funcidx->procedure-eq?" (i32.const 0) (i32.const 1)) (i32.const ,false-value))
    (assert_return (invoke "funcidx->procedure-funcidx->procedure-eq?" (i32.const 1) (i32.const 0)) (i32.const ,false-value))
    (assert_return (invoke "funcidx->procedure-funcidx->procedure-eq?" (i32.const 0) (i32.const 0)) (i32.const ,true-value))
    (assert_return (invoke "funcidx->procedure-funcidx->procedure-eq?" (i32.const 1) (i32.const 1)) (i32.const ,true-value))
    (assert_return (invoke "funcidx->procedure-funcidx->procedure-eq?" (i32.const 42) (i32.const 42)) (i32.const ,true-value))

    (assert_return (invoke "i32->fixnum-i32->boolean-eq?" (i32.const 0) (i32.const 1)) (i32.const ,false-value))
    (assert_return (invoke "i32->fixnum-i32->boolean-eq?" (i32.const 1) (i32.const 0)) (i32.const ,false-value))
    (assert_return (invoke "i32->fixnum-i32->boolean-eq?" (i32.const 0) (i32.const 0)) (i32.const ,false-value))
    (assert_return (invoke "i32->fixnum-i32->boolean-eq?" (i32.const 1) (i32.const 1)) (i32.const ,false-value))

    (assert_return (invoke "unspecified-value->number?") (i32.const ,false-value))
    (assert_return (invoke "unspecified-value->boolean?") (i32.const ,false-value))
    (assert_return (invoke "unspecified-value->procedure?") (i32.const ,false-value))
    (assert_return (invoke "unspecified-value->check-initialized") (i32.const ,unspecified-value))

    (assert_return (invoke $scheme-base "get-error-code") (i32.const ,error-no-error))
    (assert_trap (invoke "uninitialized-value->check-initialized") "unreachable")
    (assert_return (invoke $scheme-base "get-error-code") (i32.const ,error-uninitialized))
    ))

(let emit ((statements scheme-base-wast))
  (cond ((null? statements) (newline))
        (else
         (write (car statements))
         (newline)
         (emit (cdr statements)))))
