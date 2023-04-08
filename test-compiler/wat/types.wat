(module
  (type (;0;) (func (param i32) (result i32)))
  (type (;1;) (func (param i32 i32) (result i32)))
  (import "scheme base" "unspecified-value" (global (;0;) i32))
  (import "scheme base" "uninitialized-value" (global (;1;) i32))
  (import "scheme base" "get-error-code" (func (;0;) (result i32)))
  (import "scheme base" "i32->fixnum" (func (;1;) (param i32) (result i32)))
  (import "scheme base" "check-fixnum" (func (;2;) (param i32) (result i32)))
  (import "scheme base" "fixnum->i32" (func (;3;) (param i32) (result i32)))
  (import "scheme base" "number?" (func (;4;) (param i32) (result i32)))
  (import "scheme base" "zero?" (func (;5;) (param i32) (result i32)))
  (import "scheme base" "i32->boolean" (func (;6;) (param i32) (result i32)))
  (import "scheme base" "boolean->i32" (func (;7;) (param i32) (result i32)))
  (import "scheme base" "funcidx->procedure" (func (;8;) (param i32) (result i32)))
  (import "scheme base" "procedure->funcidx" (func (;9;) (param i32) (result i32)))
  (import "scheme base" "boolean?" (func (;10;) (param i32) (result i32)))
  (import "scheme base" "procedure?" (func (;11;) (param i32) (result i32)))
  (import "scheme base" "eq?" (func (;12;) (param i32 i32) (result i32)))
  (global (;2;) (mut i32) (i32.const 46))
  (global (;3;) (mut i32) (i32.const 46))
  (global (;4;) (mut i32) (i32.const 46))
  (global (;5;) (mut i32) (i32.const 46))
  (global (;6;) (mut i32) (i32.const 46))
  (global (;7;) (mut i32) (i32.const 46))
  (global (;8;) (mut i32) (i32.const 46))
  (global (;9;) (mut i32) (i32.const 46))
  (func (;13;) (type 0) (param i32) (result i32)
    local.get 0
    global.get 2
    call 9
    call_indirect (type 0))
  (func (;14;) (type 0) (param i32) (result i32)
    local.get 0
    global.get 3
    call 9
    call_indirect (type 0))
  (func (;15;) (type 1) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    global.get 6
    call 9
    call_indirect (type 1))
  (func (;16;)
    i32.const 2
    global.set 2
    i32.const 18
    global.set 3
    i32.const 34
    global.set 4
    i32.const 50
    global.set 5
    i32.const 66
    global.set 6
    i32.const 5
    call 8
    global.set 7
    i32.const 30
    drop
    i32.const 6
    call 8
    global.set 8
    i32.const 30
    drop
    i32.const 7
    call 8
    global.set 9
    i32.const 30
    drop)
  (table (;0;) 8 funcref)
  (export "is-number?" (func 13))
  (export "is-zero?" (func 14))
  (export "is-eq?" (func 15))
  (start 16)
  (elem (;0;) (i32.const 0) func 4 5 10 11 12 13 14 15)
  (type (;2;) (func (result i32)))
  (type (;3;) (func)))
