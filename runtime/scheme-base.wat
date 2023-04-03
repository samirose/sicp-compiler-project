(module $scheme-base
  (global $error-code (mut i32) (i32.const 0))
  (global $error-no-error (export "error-no-error") i32 (i32.const 0))
  (global $error-expected-number (export "error-expected-number") i32 (i32.const 1))
  (global $error-expected-procedure (export "error-expected-procedure") i32 (i32.const 2))
  (global $error-uninitialized (export "error-uninitialized") i32 (i32.const 3))

  (func (export "get-error-code") (result i32)
    global.get $error-code
    global.get $error-no-error
    global.set $error-code)

  (func $raise-error (export "raise-error") (param $error-code i32)
    local.get $error-code
    global.set $error-code
    unreachable)

  ;; fixnums are encoded with least signigicant bit set
  (global $fixnum-mask       i32 (i32.const 0x00000001)) ;; 00000001
  (global $fixnum-shift      i32 (i32.const 1))

  ;; Other immediate value types are encoded in the least significant 4 bits
  ;; Note that the least significant two bits need to non-zero for all immediate type tags to
  ;; enable detecting 32-bit aligned pointers from immediates.
  (global $immediate-mask      i32 (i32.const 0x0000000f)) ;; 00001111
  (global $immediate-shift     i32 (i32.const 4))

  ;; Type tag for procedure values.
  ;; Wasm function index of the procedure is encoded in the 3 most significant bytes
  (global $procedure-tag       i32 (i32.const 0x00000002)) ;; 00000010

  ;; Type tag and values for boolean values
  (global $boolean-tag         i32 (i32.const 0x00000006)) ;; 00000110
  (global $false-value         i32 (i32.const 0x00000006)) ;; 00000110
  (global $true-value          i32 (i32.const 0x00000016)) ;; 00010110

  ;; Special type tag and values
  (global $special-tag         i32 (i32.const 0x0000000e)) ;; 00001110
  (global $unspecified-value   i32 (i32.const 0x0000001e)) ;; 00011110
  (global $uninitialized-value i32 (i32.const 0x0000002e)) ;; 00101110

  (export "false-value" (global $false-value))
  (export "true-value"  (global $true-value))
  (export "unspecified-value" (global $unspecified-value))
  (export "uninitialized-value" (global $uninitialized-value))

  (func (export "i32->fixnum") (param $value i32) (result i32)
    local.get $value
    global.get $fixnum-shift
    i32.shl
    global.get $fixnum-mask
    i32.or)

  (func $check-fixnum (export "check-fixnum") (param $obj i32) (result i32)
    local.get $obj
    local.get $obj
    global.get $fixnum-mask
    i32.and
    global.get $fixnum-mask
    i32.ne
    if
      global.get $error-expected-number
      call $raise-error
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
    i32.ne
    if
      global.get $error-expected-procedure
      call $raise-error
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

  (func (export "eq?") (param $obj1 i32) (param $obj2 i32) (result i32)
    local.get $obj1
    local.get $obj2
    i32.eq
    call $i32->boolean)

  (func (export "check-initialized") (param $obj i32) (result i32)
    local.get $obj
    local.get $obj
    global.get $uninitialized-value
    i32.eq
    if
      global.get $error-uninitialized
      call $raise-error
    end)
)
