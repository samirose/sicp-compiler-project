(import (scheme base))
(import (scheme write))
(import (values))

(define scheme-base-wast
  `(
    (assert_return (invoke "i32->boolean" (i32.const 0)) (i32.const ,false-value))
    (assert_return (invoke "i32->boolean" (i32.const 1)) (i32.const ,true-value))
    (assert_return (invoke "boolean->i32" (i32.const ,false-value)) (i32.const 0))
    (assert_return (invoke "boolean->i32" (i32.const ,true-value)) (i32.const 1))
    (assert_return (invoke "boolean?" (i32.const ,false-value)) (i32.const ,true-value))
    (assert_return (invoke "boolean?" (i32.const ,true-value)) (i32.const ,true-value))
    (assert_return (invoke "boolean?" (i32.const 0)) (i32.const ,false-value))
    (assert_return (invoke "boolean?" (i32.const 1)) (i32.const ,false-value))

    (assert_return (invoke "number?" (i32.const ,false-value)) (i32.const ,false-value))
    (assert_return (invoke "number?" (i32.const ,true-value)) (i32.const ,false-value))

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
     (import "scheme base" "fixnum->i32"  (func $fixnum->i32  (param i32) (result i32)))
     (import "scheme base" "number?"      (func $number?      (param i32) (result i32)))
     (import "scheme base" "zero?"        (func $zero?        (param i32) (result i32)))
     (import "scheme base" "i32->boolean" (func $i32->boolean (param i32) (result i32)))
     (import "scheme base" "boolean->i32" (func $boolean->i32 (param i32) (result i32)))
     (import "scheme base" "boolean?"     (func $boolean?     (param i32) (result i32)))
     (import "scheme base" "funcidx->procedure" (func $funcidx->procedure  (param i32) (result i32)))
     (import "scheme base" "procedure->funcidx" (func $procedure->funcidx  (param i32) (result i32)))
     (import "scheme base" "procedure?"         (func $procedure?          (param i32) (result i32)))
     (import "scheme base" "eq?" (func $eq? (param i32) (param i32) (result i32)))
     (import "scheme base" "check-initialized"   (func $check-initialized (param i32) (result i32)))

     (func (export "i32->fixnum->i32") (param $value i32) (result i32)
           local.get $value
           call $i32->fixnum
           call $fixnum->i32)

     (func (export "i32->fixnum->number?") (param $value i32) (result i32)
           local.get $value
           call $i32->fixnum
           call $number?)

     (func (export "i32->fixnum->zero?") (param $value i32) (result i32)
           local.get $value
           call $i32->fixnum
           call $zero?)

     (func (export "i32->fixnum->boolean?") (param $value i32) (result i32)
           local.get $value
           call $i32->fixnum
           call $boolean?)

     (func (export "i32->fixnum->procedure?") (param $value i32) (result i32)
           local.get $value
           call $i32->fixnum
           call $procedure?)

     (func (export "i32->fixnum->check-initialized") (param $value i32) (result i32)
           local.get $value
           call $i32->fixnum
           call $check-initialized
           call $fixnum->i32)

     (func (export "i32->boolean->i32") (param $value i32) (result i32)
           local.get $value
           call $i32->boolean
           call $boolean->i32)

     (func (export "i32->boolean->boolean?") (param $value i32) (result i32)
           local.get $value
           call $i32->boolean
           call $boolean?)

     (func (export "i32->boolean->number?") (param $value i32) (result i32)
           local.get $value
           call $i32->boolean
           call $number?)

     (func (export "i32->boolean->procedure?") (param $value i32) (result i32)
           local.get $value
           call $i32->boolean
           call $procedure?)

     (func (export "i32->boolean->check-initialized") (param $value i32) (result i32)
           local.get $value
           call $i32->boolean
           call $check-initialized
           call $boolean->i32)

     (func (export "funcidx->procedure->funcidx") (param $funcidx i32) (result i32)
           local.get $funcidx
           call $funcidx->procedure
           call $procedure->funcidx)

     (func (export "funcidx->procedure->procedure?") (param $funcidx i32) (result i32)
           local.get $funcidx
           call $funcidx->procedure
           call $procedure?)

     (func (export "funcidx->procedure->number?") (param $funcidx i32) (result i32)
           local.get $funcidx
           call $funcidx->procedure
           call $number?)

     (func (export "funcidx->procedure->boolean?") (param $funcidx i32) (result i32)
           local.get $funcidx
           call $funcidx->procedure
           call $boolean?)

     (func (export "funcidx->procedure->check-initialized") (param $funcidx i32) (result i32)
           local.get $funcidx
           call $funcidx->procedure
           call $check-initialized
           call $procedure->funcidx)

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

    (assert_return (invoke "i32->fixnum->i32" (i32.const  0))  (i32.const  0))
    (assert_return (invoke "i32->fixnum->i32" (i32.const  1))  (i32.const  1))
    (assert_return (invoke "i32->fixnum->i32" (i32.const -1))  (i32.const -1))
    (assert_return (invoke "i32->fixnum->i32" (i32.const  42)) (i32.const  42))
    (assert_return (invoke "i32->fixnum->i32" (i32.const -42)) (i32.const -42))

    (assert_return (invoke "i32->fixnum->number?" (i32.const  0)) (i32.const ,true-value))
    (assert_return (invoke "i32->fixnum->number?" (i32.const  1)) (i32.const ,true-value))
    (assert_return (invoke "i32->fixnum->number?" (i32.const -1)) (i32.const ,true-value))
    (assert_return (invoke "i32->fixnum->number?" (i32.const 42)) (i32.const ,true-value))

    (assert_return (invoke "i32->fixnum->zero?" (i32.const  0)) (i32.const ,true-value))
    (assert_return (invoke "i32->fixnum->zero?" (i32.const  1)) (i32.const ,false-value))
    (assert_return (invoke "i32->fixnum->zero?" (i32.const -1)) (i32.const ,false-value))
    (assert_return (invoke "i32->fixnum->zero?" (i32.const 42)) (i32.const ,false-value))

    (assert_return (invoke "i32->fixnum->boolean?" (i32.const   0)) (i32.const ,false-value))
    (assert_return (invoke "i32->fixnum->boolean?" (i32.const   1)) (i32.const ,false-value))
    (assert_return (invoke "i32->fixnum->boolean?" (i32.const  -1)) (i32.const ,false-value))
    (assert_return (invoke "i32->fixnum->boolean?" (i32.const  42)) (i32.const ,false-value))

    (assert_return (invoke "i32->fixnum->procedure?" (i32.const   0)) (i32.const ,false-value))
    (assert_return (invoke "i32->fixnum->procedure?" (i32.const   1)) (i32.const ,false-value))
    (assert_return (invoke "i32->fixnum->procedure?" (i32.const  -1)) (i32.const ,false-value))
    (assert_return (invoke "i32->fixnum->procedure?" (i32.const  42)) (i32.const ,false-value))

    (assert_return (invoke "i32->fixnum->check-initialized" (i32.const  0)) (i32.const  0))
    (assert_return (invoke "i32->fixnum->check-initialized" (i32.const  1)) (i32.const  1))
    (assert_return (invoke "i32->fixnum->check-initialized" (i32.const -1)) (i32.const -1))

    (assert_return (invoke "i32->boolean->i32" (i32.const  0)) (i32.const 0))
    (assert_return (invoke "i32->boolean->i32" (i32.const  1)) (i32.const 1))
    (assert_return (invoke "i32->boolean->i32" (i32.const -1)) (i32.const 1))
    (assert_return (invoke "i32->boolean->i32" (i32.const 42)) (i32.const 1))

    (assert_return (invoke "i32->boolean->boolean?" (i32.const 0)) (i32.const ,true-value))
    (assert_return (invoke "i32->boolean->boolean?" (i32.const 1)) (i32.const ,true-value))

    (assert_return (invoke "i32->boolean->number?" (i32.const 0)) (i32.const ,false-value))
    (assert_return (invoke "i32->boolean->number?" (i32.const 1)) (i32.const ,false-value))

    (assert_return (invoke "i32->boolean->procedure?" (i32.const 0)) (i32.const ,false-value))
    (assert_return (invoke "i32->boolean->procedure?" (i32.const 1)) (i32.const ,false-value))

    (assert_return (invoke "i32->boolean->check-initialized" (i32.const 0)) (i32.const 0))
    (assert_return (invoke "i32->boolean->check-initialized" (i32.const 1)) (i32.const 1))

    (assert_return (invoke "funcidx->procedure->funcidx" (i32.const 0)) (i32.const 0))
    (assert_return (invoke "funcidx->procedure->funcidx" (i32.const 1)) (i32.const 1))
    (assert_return (invoke "funcidx->procedure->funcidx" (i32.const 42)) (i32.const 42))

    (assert_return (invoke "funcidx->procedure->procedure?" (i32.const 0))  (i32.const ,true-value))
    (assert_return (invoke "funcidx->procedure->procedure?" (i32.const 1))  (i32.const ,true-value))
    (assert_return (invoke "funcidx->procedure->procedure?" (i32.const 42)) (i32.const ,true-value))

    (assert_return (invoke "funcidx->procedure->number?" (i32.const 0))  (i32.const ,false-value))
    (assert_return (invoke "funcidx->procedure->number?" (i32.const 1))  (i32.const ,false-value))
    (assert_return (invoke "funcidx->procedure->number?" (i32.const 42)) (i32.const ,false-value))

    (assert_return (invoke "funcidx->procedure->number?" (i32.const 0))  (i32.const ,false-value))
    (assert_return (invoke "funcidx->procedure->number?" (i32.const 1))  (i32.const ,false-value))
    (assert_return (invoke "funcidx->procedure->number?" (i32.const 42)) (i32.const ,false-value))

    (assert_return (invoke "funcidx->procedure->boolean?" (i32.const 0))  (i32.const ,false-value))
    (assert_return (invoke "funcidx->procedure->boolean?" (i32.const 1))  (i32.const ,false-value))
    (assert_return (invoke "funcidx->procedure->boolean?" (i32.const 42)) (i32.const ,false-value))

    (assert_return (invoke "funcidx->procedure->check-initialized" (i32.const  0)) (i32.const 0))
    (assert_return (invoke "funcidx->procedure->check-initialized" (i32.const  1)) (i32.const 1))
    (assert_return (invoke "funcidx->procedure->check-initialized" (i32.const 42)) (i32.const 42))

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
