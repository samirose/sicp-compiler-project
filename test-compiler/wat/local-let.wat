(module
  (type (;0;) (func (result i32)))
  (type (;1;) (func (param i32) (result i32)))
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
  (import "scheme base" "symbol=?" (func (;14;) (param i32 i32) (result i32)))
  (import "scheme base" "string=?" (func (;15;) (param i32 i32) (result i32)))
  (import "scheme base" "eq?" (func (;16;) (param i32 i32) (result i32)))
  (import "scheme base" "eq?" (func (;17;) (param i32 i32) (result i32)))
  (global (;0;) i32 (i32.const 2))
  (global (;1;) i32 (i32.const 18))
  (global (;2;) i32 (i32.const 34))
  (global (;3;) i32 (i32.const 50))
  (global (;4;) i32 (i32.const 66))
  (global (;5;) i32 (i32.const 82))
  (global (;6;) i32 (i32.const 98))
  (global (;7;) i32 (i32.const 114))
  (global (;8;) i32 (i32.const 130))
  (global (;9;) i32 (i32.const 146))
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
  (global (;22;) (mut i32) (i32.const 46))
  (global (;23;) (mut i32) (i32.const 46))
  (global (;24;) (mut i32) (i32.const 46))
  (func (;18;) (type 0) (result i32)
    (local i32)
    i32.const 2
    call 1
    local.set 0
    i32.const 40
    local.get 0
    call 3
    i32.add
    call 1)
  (func (;19;) (type 0) (result i32)
    (local i32)
    i32.const 2
    i32.const 3
    i32.mul
    call 1
    local.set 0
    i32.const 5
    local.get 0
    call 3
    i32.mul
    call 1)
  (func (;20;) (type 0) (result i32)
    (local i32 i32)
    i32.const 2
    call 1
    local.set 0
    i32.const 3
    call 1
    local.set 1
    local.get 0
    call 3
    local.get 1
    call 3
    i32.mul
    call 1)
  (func (;21;) (type 0) (result i32)
    (local i32 i32)
    i32.const 2
    call 1
    local.set 0
    i32.const 3
    call 1
    local.set 1
    local.get 0
    call 3
    local.get 1
    call 3
    i32.mul
    call 1)
  (func (;22;) (type 0) (result i32)
    (local i32 i32)
    i32.const 2
    call 1
    local.set 0
    local.get 0
    call 3
    i32.const 1
    i32.add
    call 1
    local.set 1
    local.get 0
    call 3
    local.get 1
    call 3
    i32.mul
    call 1)
  (func (;23;) (type 0) (result i32)
    (local i32 i32 i32)
    i32.const 2
    call 1
    local.set 0
    i32.const 3
    call 1
    local.set 1
    i32.const 5
    call 1
    local.set 2
    local.get 0
    call 3
    local.get 2
    call 3
    i32.mul
    call 1)
  (func (;24;) (type 1) (param i32) (result i32)
    (local i32)
    i32.const 2
    call 1
    local.set 1
    local.get 1
    call 3
    local.get 0
    call 3
    i32.mul
    call 1)
  (func (;25;) (type 0) (result i32)
    i32.const 5
    call 1
    i32.const 16
    call_indirect (type 1))
  (func (;26;) (type 1) (param i32) (result i32)
    (local i32)
    local.get 0
    call 3
    i32.const 2
    i32.mul
    call 1
    local.set 1
    local.get 1
    call 3
    local.get 0
    call 3
    i32.mul
    call 1)
  (func (;27;) (type 0) (result i32)
    i32.const 3
    call 1
    i32.const 18
    call_indirect (type 1))
  (func (;28;) (type 1) (param i32) (result i32)
    (local i32)
    local.get 0
    call 3
    i32.const 2
    i32.mul
    call 1
    local.set 1
    local.get 1
    call 3
    local.get 1
    call 3
    i32.mul
    call 1)
  (func (;29;) (type 0) (result i32)
    i32.const 3
    call 1
    i32.const 20
    call_indirect (type 1))
  (func (;30;) (type 1) (param i32) (result i32)
    local.get 0
    call 3
    local.get 0
    call 3
    i32.add
    call 1)
  (func (;31;) (type 0) (result i32)
    (local i32 i32)
    i32.const 2
    i32.const 3
    i32.mul
    call 1
    local.set 0
    i32.const 22
    call 8
    local.set 1
    local.get 0
    local.get 1
    call 9
    call_indirect (type 1))
  (func (;32;) (type 0) (result i32)
    (local i32 i32 i32)
    i32.const 1
    call 1
    local.set 0
    i32.const 2
    call 1
    local.set 1
    i32.const 3
    call 1
    local.set 2
    local.get 1
    local.set 0
    local.get 2
    local.set 1
    local.get 2
    call 3
    i32.const 1
    i32.add
    call 1
    local.set 2
    local.get 0
    call 3
    local.get 1
    call 3
    i32.add
    local.get 2
    call 3
    i32.add
    call 1)
  (func (;33;) (type 0) (result i32)
    global.get 21)
  (func (;34;) (type 0) (result i32)
    global.get 23)
  (func (;35;)
    (local i32 i32 i32 i32 i32)
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
    i32.const 17
    call 8
    global.set 16
    i32.const 19
    call 8
    global.set 17
    i32.const 21
    call 8
    global.set 18
    i32.const 23
    call 8
    global.set 19
    i32.const 24
    call 8
    global.set 20
    i32.const 2
    call 1
    local.set 0
    i32.const 3
    call 1
    local.set 1
    local.get 0
    call 3
    local.get 1
    call 3
    i32.add
    call 1
    global.set 21
    i32.const 25
    call 8
    global.set 22
    i32.const 0
    call 1
    global.set 23
    i32.const 26
    call 8
    global.set 24
    i32.const 2
    call 1
    local.set 0
    i32.const 3
    call 1
    local.set 1
    i32.const 4
    call 1
    local.set 2
    local.get 0
    call 3
    local.get 1
    call 3
    i32.add
    local.get 2
    call 3
    i32.add
    call 1
    global.set 23
    i32.const 30
    drop)
  (table (;0;) 27 funcref)
  (export "constant-let" (func 18))
  (export "expression-let" (func 19))
  (export "multi-variable-let" (func 20))
  (export "nested-let" (func 21))
  (export "nested-let-referring-outer-let" (func 22))
  (export "let-shadowing-let" (func 23))
  (export "let-in-lambda" (func 25))
  (export "let-value-referring-lambda-arg" (func 27))
  (export "let-value-shadowing-lambda-arg" (func 29))
  (export "lambda-as-let-value" (func 31))
  (export "mutate-locals" (func 32))
  (export "get-global-with-let-value" (func 33))
  (export "get-global-assigned-with-let-value" (func 34))
  (start 35)
  (elem (;0;) (i32.const 0) func 4 5 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34)
  (type (;2;) (func (param i32 i32) (result i32)))
  (type (;3;) (func)))
