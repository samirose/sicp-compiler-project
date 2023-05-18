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
  (import "scheme base" "funcidx->procedure" (func (;8;) (param i32) (result i32)))
  (import "scheme base" "procedure->funcidx" (func (;9;) (param i32) (result i32)))
  (import "scheme base" "boolean?" (func (;10;) (param i32) (result i32)))
  (import "scheme base" "procedure?" (func (;11;) (param i32) (result i32)))
  (import "scheme base" "eq?" (func (;12;) (param i32 i32) (result i32)))
  (global (;2;) i32 (i32.const 2))
  (global (;3;) i32 (i32.const 18))
  (global (;4;) i32 (i32.const 34))
  (global (;5;) i32 (i32.const 50))
  (global (;6;) i32 (i32.const 66))
  (global (;7;) (mut i32) (i32.const 46))
  (global (;8;) (mut i32) (i32.const 46))
  (global (;9;) (mut i32) (i32.const 46))
  (global (;10;) (mut i32) (i32.const 46))
  (global (;11;) (mut i32) (i32.const 46))
  (global (;12;) (mut i32) (i32.const 46))
  (func (;13;) (type 0) (result i32)
    i32.const 6
    i32.const 22
    i32.const 22
    call 7
    select)
  (func (;14;) (type 0) (result i32)
    i32.const 6
    i32.const 22
    i32.const 6
    call 7
    select)
  (func (;15;) (type 0) (result i32)
    i32.const 6
    i32.const 22
    i32.const 42
    call 1
    call 7
    select)
  (func (;16;) (type 0) (result i32)
    i32.const 6
    i32.const 22
    i32.const 1
    call 1
    i32.const 0
    call 1
    i32.gt_s
    select)
  (func (;17;) (type 1) (param i32) (result i32)
    local.get 0
    call 3
    i32.const 1
    i32.add
    call 1)
  (func (;18;) (type 0) (result i32)
    i32.const 6
    i32.const 22
    i32.const 2
    call 1
    i32.const 9
    call 8
    call 9
    call_indirect (type 1)
    call 7
    select)
  (func (;19;) (type 0) (result i32)
    i32.const 6
    i32.const 22
    i32.const 0
    call 1
    i32.const 1
    call 1
    i32.gt_s
    select)
  (func (;20;)
    i32.const 5
    call 8
    global.set 7
    i32.const 6
    call 8
    global.set 8
    i32.const 7
    call 8
    global.set 9
    i32.const 8
    call 8
    global.set 10
    i32.const 10
    call 8
    global.set 11
    i32.const 11
    call 8
    global.set 12
    i32.const 30
    drop)
  (table (;0;) 12 funcref)
  (export "not-true-is-false" (func 13))
  (export "not-false-is-true" (func 14))
  (export "not-non-false-value-is-false" (func 15))
  (export "not-true-expression-is-false" (func 16))
  (export "not-non-false-expression-is-false" (func 18))
  (export "not-false-expression-is-true" (func 19))
  (start 20)
  (elem (;0;) (i32.const 0) func 4 5 10 11 12 13 14 15 16 17 18 19)
  (type (;2;) (func (param i32 i32) (result i32)))
  (type (;3;) (func)))
