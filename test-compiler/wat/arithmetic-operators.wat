(module
  (type (;0;) (func (result i32)))
  (import "scheme base" "unspecified-value" (global (;0;) i32))
  (import "scheme base" "uninitialized-value" (global (;1;) i32))
  (import "scheme base" "get-error-code" (func (;0;) (result i32)))
  (import "scheme base" "i32->fixnum" (func (;1;) (param i32) (result i32)))
  (import "scheme base" "fixnum->i32" (func (;2;) (param i32) (result i32)))
  (import "scheme base" "number?" (func (;3;) (param i32) (result i32)))
  (import "scheme base" "zero?" (func (;4;) (param i32) (result i32)))
  (import "scheme base" "i32->boolean" (func (;5;) (param i32) (result i32)))
  (import "scheme base" "boolean->i32" (func (;6;) (param i32) (result i32)))
  (import "scheme base" "boolean?" (func (;7;) (param i32) (result i32)))
  (import "scheme base" "procedure?" (func (;8;) (param i32) (result i32)))
  (import "scheme base" "eq?" (func (;9;) (param i32 i32) (result i32)))
  (global (;2;) (mut i32) (i32.const 46))
  (global (;3;) (mut i32) (i32.const 46))
  (global (;4;) (mut i32) (i32.const 46))
  (global (;5;) (mut i32) (i32.const 46))
  (global (;6;) (mut i32) (i32.const 46))
  (global (;7;) (mut i32) (i32.const 46))
  (global (;8;) (mut i32) (i32.const 46))
  (global (;9;) (mut i32) (i32.const 46))
  (global (;10;) (mut i32) (i32.const 46))
  (global (;11;) (mut i32) (i32.const 46))
  (global (;12;) (mut i32) (i32.const 46))
  (global (;13;) (mut i32) (i32.const 46))
  (global (;14;) (mut i32) (i32.const 46))
  (global (;15;) (mut i32) (i32.const 46))
  (global (;16;) (mut i32) (i32.const 46))
  (global (;17;) (mut i32) (i32.const 46))
  (global (;18;) (mut i32) (i32.const 46))
  (global (;19;) (mut i32) (i32.const 46))
  (global (;20;) (mut i32) (i32.const 46))
  (global (;21;) (mut i32) (i32.const 46))
  (func (;10;) (type 0) (result i32)
    i32.const 0
    call 1
    call 2)
  (func (;11;) (type 0) (result i32)
    i32.const 1
    call 1
    call 2)
  (func (;12;) (type 0) (result i32)
    i32.const 2
    call 1
    call 2)
  (func (;13;) (type 0) (result i32)
    i32.const 1
    call 1
    call 2
    i32.const 2
    call 1
    call 2
    i32.add)
  (func (;14;) (type 0) (result i32)
    i32.const -2
    call 1
    call 2)
  (func (;15;) (type 0) (result i32)
    i32.const 0
    call 1
    call 2
    i32.const 2
    call 1
    call 2
    i32.const 3
    call 1
    call 2
    i32.add
    i32.sub)
  (func (;16;) (type 0) (result i32)
    i32.const 2
    call 1
    call 2)
  (func (;17;) (type 0) (result i32)
    i32.const 0
    call 1
    call 2
    i32.const 2
    call 1
    call 2
    i32.add)
  (func (;18;) (type 0) (result i32)
    i32.const 1
    call 1
    call 2
    i32.const 2
    call 1
    call 2
    i32.add)
  (func (;19;) (type 0) (result i32)
    i32.const 2
    call 1
    call 2
    i32.const -1
    call 1
    call 2
    i32.add)
  (func (;20;) (type 0) (result i32)
    i32.const 2
    call 1
    call 2
    i32.const -2
    call 1
    call 2
    i32.add)
  (func (;21;) (type 0) (result i32)
    i32.const 2
    call 1
    call 2
    i32.const -3
    call 1
    call 2
    i32.add)
  (func (;22;) (type 0) (result i32)
    i32.const -2
    call 1
    call 2
    i32.const 0
    call 1
    call 2
    i32.add)
  (func (;23;) (type 0) (result i32)
    i32.const 1
    call 1
    call 2
    i32.const 2
    call 1
    call 2
    i32.add
    i32.const 3
    call 1
    call 2
    i32.add)
  (func (;24;) (type 0) (result i32)
    i32.const 2
    call 1
    call 2
    i32.const -6
    call 1
    call 2
    i32.mul
    i32.const 2
    call 1
    call 2
    i32.mul
    i32.const 3
    call 1
    call 2
    i32.div_s
    i32.const 2
    call 1
    call 2
    i32.div_s
    i32.const 0
    call 1
    call 2
    i32.const 1
    call 1
    call 2
    i32.const 2
    call 1
    call 2
    i32.add
    i32.const 3
    call 1
    call 2
    i32.add
    i32.sub
    i32.add
    i32.const 1
    call 1
    call 2
    i32.const 1
    call 1
    call 2
    i32.add
    i32.add)
  (func (;25;)
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
    i32.const 7
    global.set 9
    i32.const 30
    drop
    i32.const 8
    global.set 10
    i32.const 30
    drop
    i32.const 9
    global.set 11
    i32.const 30
    drop
    i32.const 10
    global.set 12
    i32.const 30
    drop
    i32.const 11
    global.set 13
    i32.const 30
    drop
    i32.const 12
    global.set 14
    i32.const 30
    drop
    i32.const 13
    global.set 15
    i32.const 30
    drop
    i32.const 14
    global.set 16
    i32.const 30
    drop
    i32.const 15
    global.set 17
    i32.const 30
    drop
    i32.const 16
    global.set 18
    i32.const 30
    drop
    i32.const 17
    global.set 19
    i32.const 30
    drop
    i32.const 18
    global.set 20
    i32.const 30
    drop
    i32.const 19
    global.set 21
    i32.const 30
    drop)
  (table (;0;) 20 funcref)
  (export "plus-identity" (func 10))
  (export "multiply-identity" (func 11))
  (export "plus-single" (func 12))
  (export "plus-single-expr" (func 13))
  (export "minus-single" (func 14))
  (export "minus-single-expr" (func 15))
  (export "multiply-single" (func 16))
  (export "plus-zero-to-positive" (func 17))
  (export "plus-positive-result" (func 18))
  (export "signed-plus-positive-result" (func 19))
  (export "signed-plus-zero-result" (func 20))
  (export "signed-plus-negative-result" (func 21))
  (export "plus-zero-to-negative" (func 22))
  (export "plus-multiple" (func 23))
  (export "complex" (func 24))
  (start 25)
  (elem (;0;) (i32.const 0) func 3 4 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24)
  (type (;1;) (func (param i32) (result i32)))
  (type (;2;) (func (param i32 i32) (result i32)))
  (type (;3;) (func)))
