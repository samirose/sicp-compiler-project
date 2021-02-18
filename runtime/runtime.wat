(module
  (global $error-code (mut i32) (i32.const 0))
  (global $error-expected-number (export "error-expected-number") i32 (i32.const 1))

  (func (export "get-error-code") (result i32)
    global.get $error-code)

  (global $fixnum-mask i32 (i32.const 0x00000001))

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
)
