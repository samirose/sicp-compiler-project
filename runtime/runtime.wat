(module
  (global $error-code (mut i32) (i32.const 0))
  (global $error-expected-number (export "error-expected-number") i32 (i32.const 1))

  (func (export "get-error-code") (result i32)
    global.get $error-code)

  (global $fixnum-mask    i32 (i32.const 0x00000001))
  (global $boolean-tag    i32 (i32.const 0x00000006))
  (global $immediate-mask i32 (i32.const 0x0000000f))
  (global $false-value    (export "false-value") i32 (i32.const 0x00000006))
  (global $true-value     (export "true-value")  i32 (i32.const 0x00000016))

  (func (export "i32->fixnum") (param $value i32) (result i32)
    local.get $value
    i32.const 1
    i32.shl
    global.get $fixnum-mask
    i32.or)

  (func (export "fixnum->i32") (param $fixnum i32) (result i32)
    local.get $fixnum
    global.get $fixnum-mask
    i32.and
    if (result i32)
      local.get $fixnum
      i32.const 1
      i32.shr_s
    else
      global.get $error-expected-number
      global.set $error-code
      unreachable
    end)

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
)
