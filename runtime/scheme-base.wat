(module
  (global $error-code (mut i32) (i32.const 0))
  (global $error-no-error (export "error-no-error") i32 (i32.const 0))
  (global $error-expected-number (export "error-expected-number") i32 (i32.const 1))
  (global $error-expected-procedure (export "error-expected-procedure") i32 (i32.const 2))

  (func (export "get-error-code") (result i32)
    global.get $error-code
    global.get $error-no-error
    global.set $error-code)

  (global $fixnum-mask     i32 (i32.const 0x00000001)) ;; 00000001
  (global $fixnum-shift    i32 (i32.const 1))
  (global $immediate-mask  i32 (i32.const 0x0000000f)) ;; 00001111
  (global $immediate-shift i32 (i32.const 4))
  (global $procedure-tag   i32 (i32.const 0x00000002)) ;; 00000010
  (global $boolean-tag     i32 (i32.const 0x00000006)) ;; 00000110
  (global $false-value     i32 (i32.const 0x00000006)) ;; 00000110
  (global $true-value      i32 (i32.const 0x00000016)) ;; 00010110

  (export "false-value" (global $false-value))
  (export "true-value"  (global $false-value))

  (func (export "i32->fixnum") (param $value i32) (result i32)
    local.get $value
    global.get $fixnum-shift
    i32.shl
    global.get $fixnum-mask
    i32.or)

  (func $check-fixnum (param $obj i32) (result i32)
    local.get $obj
    global.get $fixnum-mask
    i32.and
    if (result i32)
      local.get $obj
    else
      global.get $error-expected-number
      global.set $error-code
      unreachable
    end)

  (func $fixnum->i32 (export "fixnum->i32") (param $obj i32) (result i32)
    local.get $obj
    call $check-fixnum
    global.get $fixnum-shift
    i32.shr_s)

  (func $i32->boolean  (export "i32->boolean") (param $value i32) (result i32)
    global.get $true-value
    global.get $false-value
    local.get $value
    select)

  (func (export "boolean->i32") (param $obj i32) (result i32)
    i32.const 0
    i32.const 1
    local.get $obj
    global.get $false-value
    i32.eq
    select)

  (func (export "funcidx->procedure") (param $funcidx i32) (result i32)
    local.get $funcidx
    global.get $immediate-shift
    i32.shl
    global.get $procedure-tag
    i32.or)

  (func $check-procedure (param $obj i32) (result i32)
    local.get $obj
    local.get $obj
    global.get $immediate-mask
    i32.and
    global.get $procedure-tag
    i32.xor
    if
      global.get $error-expected-procedure
      global.set $error-code
      unreachable
    end)

  (func (export "procedure->funcidx") (param $obj i32) (result i32)
    local.get $obj
    call $check-procedure
    global.get $immediate-shift
    i32.shr_s)

  (func (export "boolean?") (param $obj i32) (result i32)
    local.get $obj
    global.get $immediate-mask
    i32.and
    global.get $boolean-tag
    i32.eq
    call $i32->boolean)

  (func (export "number?") (param $obj i32) (result i32)
    local.get $obj
    global.get $fixnum-mask
    i32.and
    call $i32->boolean)

  (func (export "zero?") (param $obj i32) (result i32)
    local.get $obj
    call $fixnum->i32
    i32.eqz
    call $i32->boolean)

  (func (export "procedure?") (param $obj i32) (result i32)
    local.get $obj
    global.get $immediate-mask
    i32.and
    global.get $procedure-tag
    i32.eq
    call $i32->boolean)
)
