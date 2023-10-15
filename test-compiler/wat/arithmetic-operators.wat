(module
  (type (;0;) (func (result i32)))
  (import "scheme base" "$heap" (memory (;0;) 1))
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
  (import "scheme base" "symbol?" (func (;12;) (param i32) (result i32)))
  (import "scheme base" "eq?" (func (;13;) (param i32 i32) (result i32)))
  (global (;0;) i32 (i32.const 2))
  (global (;1;) i32 (i32.const 18))
  (global (;2;) i32 (i32.const 34))
  (global (;3;) i32 (i32.const 50))
  (global (;4;) i32 (i32.const 66))
  (global (;5;) i32 (i32.const 82))
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
  (func (;14;) (type 0) (result i32)
    i32.const 0
    call 1)
  (func (;15;) (type 0) (result i32)
    i32.const 1
    call 1)
  (func (;16;) (type 0) (result i32)
    i32.const 2
    call 1)
  (func (;17;) (type 0) (result i32)
    i32.const 1
    i32.const 2
    i32.add
    call 1)
  (func (;18;) (type 0) (result i32)
    i32.const -2
    call 1)
  (func (;19;) (type 0) (result i32)
    i32.const 0
    i32.const 2
    i32.const 3
    i32.add
    i32.sub
    call 1)
  (func (;20;) (type 0) (result i32)
    i32.const 2
    call 1)
  (func (;21;) (type 0) (result i32)
    i32.const 0
    i32.const 2
    i32.add
    call 1)
  (func (;22;) (type 0) (result i32)
    i32.const 1
    i32.const 2
    i32.add
    call 1)
  (func (;23;) (type 0) (result i32)
    i32.const 2
    i32.const -1
    i32.add
    call 1)
  (func (;24;) (type 0) (result i32)
    i32.const 2
    i32.const -2
    i32.add
    call 1)
  (func (;25;) (type 0) (result i32)
    i32.const 2
    i32.const -3
    i32.add
    call 1)
  (func (;26;) (type 0) (result i32)
    i32.const -2
    i32.const 0
    i32.add
    call 1)
  (func (;27;) (type 0) (result i32)
    i32.const 1
    i32.const 2
    i32.add
    i32.const 3
    i32.add
    call 1)
  (func (;28;) (type 0) (result i32)
    i32.const 2
    i32.const -6
    i32.mul
    i32.const 2
    i32.mul
    i32.const 3
    i32.div_s
    i32.const 2
    i32.div_s
    i32.const 0
    i32.const 1
    i32.const 2
    i32.add
    i32.const 3
    i32.add
    i32.sub
    i32.add
    i32.const 1
    i32.const 1
    i32.add
    i32.add
    call 1)
  (func (;29;)
    i32.const 6
    call 8
    global.set 6
    i32.const 7
    call 8
    global.set 7
    i32.const 8
    call 8
    global.set 8
    i32.const 9
    call 8
    global.set 9
    i32.const 10
    call 8
    global.set 10
    i32.const 11
    call 8
    global.set 11
    i32.const 12
    call 8
    global.set 12
    i32.const 13
    call 8
    global.set 13
    i32.const 14
    call 8
    global.set 14
    i32.const 15
    call 8
    global.set 15
    i32.const 16
    call 8
    global.set 16
    i32.const 17
    call 8
    global.set 17
    i32.const 18
    call 8
    global.set 18
    i32.const 19
    call 8
    global.set 19
    i32.const 20
    call 8
    global.set 20
    i32.const 30
    drop)
  (table (;0;) 21 funcref)
  (export "plus-identity" (func 14))
  (export "multiply-identity" (func 15))
  (export "plus-single" (func 16))
  (export "plus-single-expr" (func 17))
  (export "minus-single" (func 18))
  (export "minus-single-expr" (func 19))
  (export "multiply-single" (func 20))
  (export "plus-zero-to-positive" (func 21))
  (export "plus-positive-result" (func 22))
  (export "signed-plus-positive-result" (func 23))
  (export "signed-plus-zero-result" (func 24))
  (export "signed-plus-negative-result" (func 25))
  (export "plus-zero-to-negative" (func 26))
  (export "plus-multiple" (func 27))
  (export "complex" (func 28))
  (start 29)
  (elem (;0;) (i32.const 0) func 4 5 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28)
  (type (;1;) (func (param i32) (result i32)))
  (type (;2;) (func (param i32 i32) (result i32)))
  (type (;3;) (func)))
