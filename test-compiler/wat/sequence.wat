(module
  (type (;0;) (func (result i32)))
  (type (;1;) (func (param i32) (result i32)))
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
  (import "scheme base" "boolean?" (func (;8;) (param i32) (result i32)))
  (import "scheme base" "procedure?" (func (;9;) (param i32) (result i32)))
  (import "scheme base" "eq?" (func (;10;) (param i32 i32) (result i32)))
  (global (;2;) (mut i32) (i32.const 46))
  (global (;3;) (mut i32) (i32.const 46))
  (global (;4;) (mut i32) (i32.const 46))
  (global (;5;) (mut i32) (i32.const 46))
  (global (;6;) (mut i32) (i32.const 46))
  (global (;7;) (mut i32) (i32.const 46))
  (global (;8;) (mut i32) (i32.const 46))
  (global (;9;) (mut i32) (i32.const 46))
  (global (;10;) (mut i32) (i32.const 46))
  (func (;11;) (type 0) (result i32)
    i32.const 1
    call 1
    drop
    i32.const 2
    call 1
    drop
    i32.const 3
    call 1)
  (func (;12;) (type 0) (result i32)
    i32.const 0
    call 1
    call 3
    i32.const 1
    call 1
    call 3
    i32.add
    call 1
    drop
    i32.const 0
    call 1
    call 3
    i32.const 2
    call 1
    call 3
    i32.add
    call 1)
  (func (;13;) (type 1) (param i32) (result i32)
    local.get 0
    call 3
    i32.const 1
    call 1
    call 3
    i32.add
    call 1
    local.set 0
    i32.const 30
    drop
    local.get 0
    call 3
    i32.const 2
    call 1
    call 3
    i32.add
    call 1
    local.set 0
    i32.const 30
    drop
    local.get 0
    call 3
    i32.const 3
    call 1
    call 3
    i32.add
    call 1
    local.set 0
    i32.const 30
    drop
    local.get 0)
  (func (;14;) (type 0) (result i32)
    i32.const 0
    call 1
    i32.const 7
    call_indirect (type 1))
  (func (;15;) (type 1) (param i32) (result i32)
    local.get 0
    call 3
    i32.const 1
    call 1
    call 3
    i32.add
    call 1
    local.set 0
    i32.const 30
    drop
    local.get 0
    call 3
    i32.const 10
    call 1
    call 3
    i32.mul
    call 1
    local.set 0
    i32.const 30
    drop
    local.get 0
    call 3
    i32.const 10
    call 1
    call 3
    i32.div_s
    call 1
    local.set 0
    i32.const 30
    drop
    local.get 0)
  (func (;16;) (type 0) (result i32)
    i32.const 0
    call 1
    i32.const 9
    call_indirect (type 1))
  (func (;17;)
    i32.const 0
    global.set 2
    i32.const 1
    global.set 3
    i32.const 2
    global.set 4
    i32.const 3
    global.set 5
    i32.const 4
    global.set 6
    i32.const 5
    global.set 7
    i32.const 30
    drop
    i32.const 6
    global.set 8
    i32.const 30
    drop
    i32.const 8
    global.set 9
    i32.const 30
    drop
    i32.const 10
    global.set 10
    i32.const 30
    drop)
  (table (;0;) 11 funcref)
  (export "sequence-has-last-value" (func 11))
  (export "sequence-has-last-expressions-value" (func 12))
  (export "all-sequence-expressions-are-evaluated" (func 14))
  (export "sequence-expressions-are-evaluated-in-order" (func 16))
  (start 17)
  (elem (;0;) (i32.const 0) func 4 5 8 9 10 11 12 13 14 15 16)
  (type (;2;) (func (param i32 i32) (result i32)))
  (type (;3;) (func)))
