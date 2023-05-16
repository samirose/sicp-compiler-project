(module
  (type (;0;) (func (result i32)))
  (type (;1;) (func (param i32) (result i32)))
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
  (global (;2;) (mut i32) (i32.const 0))
  (global (;3;) (mut i32) (i32.const 0))
  (global (;4;) (mut i32) (i32.const 0))
  (global (;5;) (mut i32) (i32.const 0))
  (global (;6;) (mut i32) (i32.const 0))
  (global (;7;) (mut i32) (i32.const 0))
  (global (;8;) (mut i32) (i32.const 0))
  (global (;9;) (mut i32) (i32.const 0))
  (global (;10;) (mut i32) (i32.const 0))
  (global (;11;) (mut i32) (i32.const 0))
  (global (;12;) (mut i32) (i32.const 0))
  (global (;13;) (mut i32) (i32.const 0))
  (global (;14;) (mut i32) (i32.const 0))
  (global (;15;) (mut i32) (i32.const 0))
  (global (;16;) (mut i32) (i32.const 0))
  (global (;17;) (mut i32) (i32.const 0))
  (global (;18;) (mut i32) (i32.const 0))
  (func (;10;) (type 0) (result i32)
    (local i32)
    i32.const 2
    call 1
    call 2
    local.set 0
    i32.const 40
    call 1
    call 2
    local.get 0
    i32.add)
  (func (;11;) (type 0) (result i32)
    (local i32 i32)
    i32.const 2
    call 1
    call 2
    i32.const 3
    call 1
    call 2
    i32.mul
    local.set 0
    i32.const 5
    call 1
    call 2
    local.get 0
    i32.mul
    local.set 1
    local.get 1)
  (func (;12;) (type 0) (result i32)
    (local i32 i32 i32)
    i32.const 2
    call 1
    call 2
    local.set 0
    i32.const 3
    call 1
    call 2
    local.set 1
    i32.const 5
    call 1
    call 2
    local.set 2
    local.get 0
    local.get 2
    i32.mul)
  (func (;13;) (type 1) (param i32) (result i32)
    (local i32)
    i32.const 2
    call 1
    call 2
    local.set 1
    local.get 1
    local.get 0
    i32.mul)
  (func (;14;) (type 0) (result i32)
    i32.const 5
    call 1
    call 2
    i32.const 8
    call_indirect (type 1))
  (func (;15;) (type 1) (param i32) (result i32)
    (local i32)
    local.get 0
    i32.const 2
    call 1
    call 2
    i32.mul
    local.set 1
    local.get 1
    local.get 0
    i32.mul)
  (func (;16;) (type 0) (result i32)
    i32.const 3
    call 1
    call 2
    i32.const 10
    call_indirect (type 1))
  (func (;17;) (type 1) (param i32) (result i32)
    (local i32)
    local.get 0
    i32.const 2
    call 1
    call 2
    i32.mul
    local.set 1
    local.get 1
    local.get 1
    i32.mul)
  (func (;18;) (type 0) (result i32)
    i32.const 3
    call 1
    call 2
    i32.const 12
    call_indirect (type 1))
  (func (;19;) (type 1) (param i32) (result i32)
    local.get 0
    local.get 0
    i32.add)
  (func (;20;) (type 0) (result i32)
    (local i32 i32)
    i32.const 2
    call 1
    call 2
    i32.const 3
    call 1
    call 2
    i32.mul
    local.set 0
    i32.const 14
    local.set 1
    local.get 0
    local.get 1
    call_indirect (type 1))
  (func (;21;) (type 0) (result i32)
    (local i32 i32 i32)
    i32.const 1
    call 1
    call 2
    local.set 0
    i32.const 2
    call 1
    call 2
    local.set 1
    local.get 0
    local.get 1
    i32.add
    i32.const 3
    call 1
    call 2
    i32.add
    local.set 2
    local.get 2
    local.set 0
    i32.const 0
    drop
    local.get 2
    i32.const 1
    call 1
    call 2
    i32.add
    local.set 2
    i32.const 0
    drop
    local.get 0
    local.get 2
    i32.add)
  (func (;22;) (type 0) (result i32)
    global.get 15)
  (func (;23;) (type 0) (result i32)
    global.get 17)
  (func (;24;)
    (local i32 i32 i32 i32 i32)
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
    i32.const 0
    drop
    i32.const 6
    global.set 8
    i32.const 0
    drop
    i32.const 7
    global.set 9
    i32.const 0
    drop
    i32.const 9
    global.set 10
    i32.const 0
    drop
    i32.const 11
    global.set 11
    i32.const 0
    drop
    i32.const 13
    global.set 12
    i32.const 0
    drop
    i32.const 15
    global.set 13
    i32.const 0
    drop
    i32.const 16
    global.set 14
    i32.const 0
    drop
    i32.const 2
    call 1
    call 2
    local.set 0
    local.get 0
    i32.const 1
    call 1
    call 2
    i32.add
    local.set 1
    local.get 0
    local.get 1
    i32.add
    global.set 15
    i32.const 0
    drop
    i32.const 17
    global.set 16
    i32.const 0
    drop
    i32.const 0
    call 1
    call 2
    global.set 17
    i32.const 0
    drop
    i32.const 18
    global.set 18
    i32.const 0
    drop
    i32.const 2
    call 1
    call 2
    local.set 0
    i32.const 3
    call 1
    call 2
    local.set 1
    local.get 0
    local.get 1
    i32.add
    i32.const 4
    call 1
    call 2
    i32.add
    local.set 2
    local.get 2
    global.set 17
    i32.const 0
    drop)
  (table (;0;) 19 funcref)
  (export "constant-let*" (func 10))
  (export "expression-let*" (func 11))
  (export "let*-shadowing" (func 12))
  (export "let*-in-lambda" (func 14))
  (export "let*-value-referring-lambda-arg" (func 16))
  (export "let*-value-shadowing-lambda-arg" (func 18))
  (export "lambda-as-let*-value" (func 20))
  (export "mutate-locals" (func 21))
  (export "get-global-with-let*-value" (func 22))
  (export "get-global-assigned-with-let*-value" (func 23))
  (start 24)
  (elem (;0;) (i32.const 0) func 3 4 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23)
  (type (;2;) (func (param i32 i32) (result i32)))
  (type (;3;) (func)))
