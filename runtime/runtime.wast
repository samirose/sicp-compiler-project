(assert_return (invoke "i32->boolean" (i32.const 0)) (i32.const 0x00000006))
(assert_return (invoke "i32->boolean" (i32.const 1)) (i32.const 0x00000016))
(assert_return (invoke "boolean->i32" (i32.const 0x00000006)) (i32.const 0))
(assert_return (invoke "boolean->i32" (i32.const 0x00000016)) (i32.const 1))
(assert_return (invoke "boolean?" (i32.const 0x00000006)) (i32.const 0x00000016))
(assert_return (invoke "boolean?" (i32.const 0x00000016)) (i32.const 0x00000016))
(assert_return (invoke "boolean?" (i32.const 0)) (i32.const 0x00000006))
(assert_return (invoke "boolean?" (i32.const 1)) (i32.const 0x00000006))

(assert_return (invoke "number?" (i32.const 0x00000006)) (i32.const 0x00000006))
(assert_return (invoke "number?" (i32.const 0x00000016)) (i32.const 0x00000006))

;; error-code is initially zero
(assert_return (get "error-no-error") (i32.const 0))
(assert_return (invoke "get-error-code") (i32.const 0))

;; Converting a non-fixnum with fixnum->i32 causes a trap and error-code being set
(assert_return (get "error-expected-number") (i32.const 1))
(assert_trap (invoke "fixnum->i32" (i32.const 0)) "unreachable")
(assert_return (invoke "get-error-code") (i32.const 1))

;; Error code is reset after reading it with get-error-code
(assert_return (invoke "get-error-code") (i32.const 0))

;; Calling zero? on non-fixum causes a trap and error-code being set
(assert_trap (invoke "zero?" (i32.const 0)) "unreachable")
(assert_return (invoke "get-error-code") (i32.const 1))

;; Converting a non-procedure with procedure->funcidx causes a trap and error-code being set
(assert_return (get "error-expected-procedure") (i32.const 2))
(assert_trap (invoke "procedure->funcidx" (i32.const 0x00000006)) "unreachable")
(assert_return (invoke "get-error-code") (i32.const 2))

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
)

(assert_return (invoke "i32->fixnum->i32" (i32.const  0))  (i32.const  0))
(assert_return (invoke "i32->fixnum->i32" (i32.const  1))  (i32.const  1))
(assert_return (invoke "i32->fixnum->i32" (i32.const -1))  (i32.const -1))
(assert_return (invoke "i32->fixnum->i32" (i32.const  42)) (i32.const  42))
(assert_return (invoke "i32->fixnum->i32" (i32.const -42)) (i32.const -42))

(assert_return (invoke "i32->fixnum->number?" (i32.const  0)) (i32.const 0x00000016))
(assert_return (invoke "i32->fixnum->number?" (i32.const  1)) (i32.const 0x00000016))
(assert_return (invoke "i32->fixnum->number?" (i32.const -1)) (i32.const 0x00000016))
(assert_return (invoke "i32->fixnum->number?" (i32.const 42)) (i32.const 0x00000016))

(assert_return (invoke "i32->fixnum->zero?" (i32.const  0)) (i32.const 0x00000016))
(assert_return (invoke "i32->fixnum->zero?" (i32.const  1)) (i32.const 0x00000006))
(assert_return (invoke "i32->fixnum->zero?" (i32.const -1)) (i32.const 0x00000006))
(assert_return (invoke "i32->fixnum->zero?" (i32.const 42)) (i32.const 0x00000006))

(assert_return (invoke "i32->fixnum->boolean?" (i32.const   0)) (i32.const 0x00000006))
(assert_return (invoke "i32->fixnum->boolean?" (i32.const   1)) (i32.const 0x00000006))
(assert_return (invoke "i32->fixnum->boolean?" (i32.const  -1)) (i32.const 0x00000006))
(assert_return (invoke "i32->fixnum->boolean?" (i32.const  42)) (i32.const 0x00000006))

(assert_return (invoke "i32->fixnum->procedure?" (i32.const   0)) (i32.const 0x00000006))
(assert_return (invoke "i32->fixnum->procedure?" (i32.const   1)) (i32.const 0x00000006))
(assert_return (invoke "i32->fixnum->procedure?" (i32.const  -1)) (i32.const 0x00000006))
(assert_return (invoke "i32->fixnum->procedure?" (i32.const  42)) (i32.const 0x00000006))

(assert_return (invoke "i32->boolean->i32" (i32.const  0)) (i32.const 0))
(assert_return (invoke "i32->boolean->i32" (i32.const  1)) (i32.const 1))
(assert_return (invoke "i32->boolean->i32" (i32.const -1)) (i32.const 1))
(assert_return (invoke "i32->boolean->i32" (i32.const 42)) (i32.const 1))

(assert_return (invoke "i32->boolean->boolean?" (i32.const 0)) (i32.const 0x00000016))
(assert_return (invoke "i32->boolean->boolean?" (i32.const 1)) (i32.const 0x00000016))

(assert_return (invoke "i32->boolean->number?" (i32.const 0)) (i32.const 0x00000006))
(assert_return (invoke "i32->boolean->number?" (i32.const 1)) (i32.const 0x00000006))

(assert_return (invoke "i32->boolean->procedure?" (i32.const 0)) (i32.const 0x00000006))
(assert_return (invoke "i32->boolean->procedure?" (i32.const 1)) (i32.const 0x00000006))

(assert_return (invoke "funcidx->procedure->funcidx" (i32.const 0)) (i32.const 0))
(assert_return (invoke "funcidx->procedure->funcidx" (i32.const 1)) (i32.const 1))
(assert_return (invoke "funcidx->procedure->funcidx" (i32.const 42)) (i32.const 42))

(assert_return (invoke "funcidx->procedure->procedure?" (i32.const 0))  (i32.const 0x00000016))
(assert_return (invoke "funcidx->procedure->procedure?" (i32.const 1))  (i32.const 0x00000016))
(assert_return (invoke "funcidx->procedure->procedure?" (i32.const 42)) (i32.const 0x00000016))

(assert_return (invoke "funcidx->procedure->number?" (i32.const 0))  (i32.const 0x00000006))
(assert_return (invoke "funcidx->procedure->number?" (i32.const 1))  (i32.const 0x00000006))
(assert_return (invoke "funcidx->procedure->number?" (i32.const 42)) (i32.const 0x00000006))

(assert_return (invoke "funcidx->procedure->number?" (i32.const 0))  (i32.const 0x00000006))
(assert_return (invoke "funcidx->procedure->number?" (i32.const 1))  (i32.const 0x00000006))
(assert_return (invoke "funcidx->procedure->number?" (i32.const 42)) (i32.const 0x00000006))

(assert_return (invoke "funcidx->procedure->boolean?" (i32.const 0))  (i32.const 0x00000006))
(assert_return (invoke "funcidx->procedure->boolean?" (i32.const 1))  (i32.const 0x00000006))
(assert_return (invoke "funcidx->procedure->boolean?" (i32.const 42)) (i32.const 0x00000006))
