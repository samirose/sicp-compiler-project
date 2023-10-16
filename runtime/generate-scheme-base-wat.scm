(import (scheme base))
(import (scheme write))
(import (values))

(define scheme-base-wat
  `(module
    $scheme-base

    (memory $heap (export "$heap") 1)

    (global $error-code (mut i32) (i32.const ,error-no-error))

    (func (export "get-error-code") (result i32)
          global.get $error-code
          i32.const ,error-no-error
          global.set $error-code)

    (func $raise-error (export "raise-error") (param $error-code i32)
          local.get $error-code
          global.set $error-code
          unreachable)

    (func (export "i32->fixnum") (param $value i32) (result i32)
          local.get $value
          i32.const ,fixnum-shift
          i32.shl
          i32.const ,fixnum-mask
          i32.or)

    (func $check-fixnum (export "check-fixnum") (param $obj i32) (result i32)
          local.get $obj
          local.get $obj
          i32.const ,fixnum-mask
          i32.and
          i32.const ,fixnum-mask
          i32.ne
          if
          i32.const ,error-expected-number
          call $raise-error
          end)

    (func $fixnum->i32 (export "fixnum->i32") (param $obj i32) (result i32)
          local.get $obj
          call $check-fixnum
          i32.const ,fixnum-shift
          i32.shr_s)

    (func $i32->boolean  (export "i32->boolean") (param $value i32) (result i32)
          i32.const ,true-value
          i32.const ,false-value
          local.get $value
          select)

    (func (export "boolean->i32") (param $obj i32) (result i32)
          i32.const 0
          i32.const 1
          local.get $obj
          i32.const ,false-value
          i32.eq
          select)

    (func (export "funcidx->procedure") (param $funcidx i32) (result i32)
          local.get $funcidx
          i32.const ,immediate-shift
          i32.shl
          i32.const ,procedure-tag
          i32.or)

    (func $check-procedure (param $obj i32) (result i32)
          local.get $obj
          local.get $obj
          i32.const ,immediate-mask
          i32.and
          i32.const ,procedure-tag
          i32.ne
          if
          i32.const ,error-expected-procedure
          call $raise-error
          end)

    (func (export "procedure->funcidx") (param $obj i32) (result i32)
          local.get $obj
          call $check-procedure
          i32.const ,immediate-shift
          i32.shr_s)

    (func (export "boolean?") (param $obj i32) (result i32)
          local.get $obj
          i32.const ,immediate-mask
          i32.and
          i32.const ,boolean-tag
          i32.eq
          call $i32->boolean)

    (func (export "number?") (param $obj i32) (result i32)
          local.get $obj
          i32.const ,fixnum-mask
          i32.and
          call $i32->boolean)

    (func (export "zero?") (param $obj i32) (result i32)
          local.get $obj
          call $fixnum->i32
          i32.eqz
          call $i32->boolean)

    (func (export "procedure?") (param $obj i32) (result i32)
          local.get $obj
          i32.const ,immediate-mask
          i32.and
          i32.const ,procedure-tag
          i32.eq
          call $i32->boolean)

    (func (export "symbol?") (param $obj i32) (result i32)
          local.get $obj
          i32.const ,immediate-value-mask
          i32.and
          i32.eqz
          if (result i32)
            local.get $obj
            i32.load
            i32.const ,heap-object-type-mask
            i32.and
            i32.const ,heap-object-type-symbol
            i32.eq
            call $i32->boolean
          else
            i32.const ,false-value
          end)

    (func (export "string?") (param $obj i32) (result i32)
          local.get $obj
          i32.const ,immediate-value-mask
          i32.and
          i32.eqz
          if (result i32)
            local.get $obj
            i32.load
            i32.const ,heap-object-type-mask
            i32.and
            i32.const ,heap-object-type-string
            i32.eq
            call $i32->boolean
          else
            i32.const ,false-value
          end)

    (func (export "eq?") (param $obj1 i32) (param $obj2 i32) (result i32)
          local.get $obj1
          local.get $obj2
          i32.eq
          call $i32->boolean)

    (func (export "check-initialized") (param $obj i32) (result i32)
          local.get $obj
          local.get $obj
          i32.const ,uninitialized-value
          i32.eq
          if
          i32.const ,error-uninitialized
          call $raise-error
          end)
    ))

(write scheme-base-wat)
(newline)
