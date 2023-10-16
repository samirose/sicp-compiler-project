(module
  (type (;0;) (func (param i32) (result i32)))
  (type (;1;) (func (result i32)))
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
  (import "scheme base" "string?" (func (;13;) (param i32) (result i32)))
  (import "scheme base" "eq?" (func (;14;) (param i32 i32) (result i32)))
  (global (;0;) i32 (i32.const 2))
  (global (;1;) i32 (i32.const 18))
  (global (;2;) i32 (i32.const 34))
  (global (;3;) i32 (i32.const 50))
  (global (;4;) i32 (i32.const 66))
  (global (;5;) i32 (i32.const 82))
  (global (;6;) i32 (i32.const 98))
  (global (;7;) (mut i32) (i32.const 46))
  (global (;8;) (mut i32) (i32.const 46))
  (global (;9;) (mut i32) (i32.const 46))
  (global (;10;) (mut i32) (i32.const 46))
  (global (;11;) (mut i32) (i32.const 46))
  (global (;12;) (mut i32) (i32.const 46))
  (global (;13;) (mut i32) (i32.const 46))
  (global (;14;) (mut i32) (i32.const 46))
  (global (;15;) (mut i32) (i32.const 46))
  (func (;15;) (type 0) (param i32) (result i32)
    i32.const 10
    call 1
    local.set 0
    local.get 0
    call 3
    i32.const 3
    i32.add
    call 1)
  (func (;16;) (type 1) (result i32)
    i32.const 5
    call 1
    i32.const 7
    call_indirect (type 0))
  (func (;17;) (type 1) (result i32)
    (local i32)
    i32.const 5
    call 1
    local.set 0
    i32.const 10
    call 1
    local.set 0
    local.get 0
    call 3
    i32.const 3
    i32.add
    call 1)
  (func (;18;) (type 1) (result i32)
    i32.const 10
    call 1
    global.set 9
    global.get 9
    call 3
    i32.const 3
    i32.add
    call 1)
  (func (;19;) (type 1) (result i32)
    global.get 11)
  (func (;20;) (type 1) (result i32)
    global.get 11
    call 3
    i32.const 1
    i32.add
    call 1
    global.set 11
    i32.const 30)
  (func (;21;) (type 1) (result i32)
    global.get 14)
  (func (;22;) (type 0) (param i32) (result i32)
    local.get 0
    call 3
    local.get 0
    call 3
    i32.add
    call 1)
  (func (;23;)
    i32.const 8
    call 8
    global.set 7
    i32.const 9
    call 8
    global.set 8
    i32.const 5
    call 1
    global.set 9
    i32.const 10
    call 8
    global.set 10
    i32.const 0
    call 1
    global.set 11
    i32.const 11
    call 8
    global.set 12
    i32.const 12
    call 8
    global.set 13
    i32.const 0
    call 1
    global.set 14
    i32.const 13
    call 8
    global.set 15
    i32.const 5
    call 1
    global.set 11
    i32.const 11
    call 1
    i32.const 14
    call_indirect (type 0)
    global.set 14
    i32.const 30
    drop)
  (table (;0;) 15 funcref)
  (export "set!-local-lambda" (func 16))
  (export "set!-local-let" (func 17))
  (export "set!-global" (func 18))
  (export "get-global" (func 19))
  (export "increment-global!" (func 20))
  (export "get-lambda-computed-global" (func 21))
  (start 23)
  (elem (;0;) (i32.const 0) func 4 5 10 11 12 13 14 15 16 17 18 19 20 21 22)
  (type (;2;) (func (param i32 i32) (result i32)))
  (type (;3;) (func)))
