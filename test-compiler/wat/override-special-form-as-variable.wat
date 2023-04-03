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
  (global (;11;) (mut i32) (i32.const 46))
  (global (;12;) (mut i32) (i32.const 46))
  (global (;13;) (mut i32) (i32.const 46))
  (func (;11;) (type 0) (result i32)
    (local i32)
    i32.const 40
    call 1
    call 3
    i32.const 2
    call 1
    call 3
    i32.add
    call 1
    local.set 0
    local.get 0)
  (func (;12;) (type 1) (param i32) (result i32)
    local.get 0
    call 3
    i32.const 1
    call 1
    call 3
    i32.add
    call 1)
  (func (;13;) (type 0) (result i32)
    (local i32)
    i32.const 42
    call 1
    local.set 0
    local.get 0)
  (func (;14;) (type 1) (param i32) (result i32)
    local.get 0
    call 3
    i32.const 1
    call 1
    call 3
    i32.add
    call 1)
  (func (;15;) (type 0) (result i32)
    (local i32)
    i32.const 40
    call 1
    call 3
    i32.const 2
    call 1
    call 3
    i32.add
    call 1
    local.set 0
    local.get 0)
  (func (;16;) (type 1) (param i32) (result i32)
    local.get 0
    call 3
    i32.const 1
    call 1
    call 3
    i32.add
    call 1)
  (func (;17;) (type 0) (result i32)
    (local i32 i32)
    i32.const 40
    call 1
    local.set 0
    i32.const 2
    call 1
    local.set 1
    local.get 0
    call 3
    local.get 1
    call 3
    i32.add
    call 1)
  (func (;18;)
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
    drop)
  (table (;0;) 12 funcref)
  (export "override-quote-let" (func 11))
  (export "override-quote-arg" (func 12))
  (export "override-define-let" (func 13))
  (export "override-define-arg" (func 14))
  (export "override-lambda-let" (func 15))
  (export "override-lambda-arg" (func 16))
  (export "override-special-symbols-let*" (func 17))
  (start 18)
  (elem (;0;) (i32.const 0) func 4 5 8 9 10 11 12 13 14 15 16 17)
  (type (;2;) (func (param i32 i32) (result i32)))
  (type (;3;) (func)))
