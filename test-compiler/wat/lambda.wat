(module
  (type (;0;) (func (param i32) (result i32)))
  (type (;1;) (func (result i32)))
  (type (;2;) (func (param i32 i32) (result i32)))
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
  (func (;10;) (type 0) (param i32) (result i32)
    local.get 0
    local.get 0
    i32.mul)
  (func (;11;) (type 1) (result i32)
    i32.const 2
    call 1
    call 2
    i32.const 5
    call_indirect (type 0))
  (func (;12;) (type 2) (param i32 i32) (result i32)
    local.get 1
    i32.const 1
    call 1
    call 2
    i32.eq
    if (result i32)  ;; label = @1
      i32.const 1
      call 1
      call 2
    else
      local.get 1
      local.get 0
      local.get 1
      i32.const 1
      call 1
      call 2
      i32.sub
      local.get 0
      call_indirect (type 2)
      i32.mul
    end)
  (func (;13;) (type 2) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    local.get 0
    call_indirect (type 2))
  (func (;14;) (type 0) (param i32) (result i32)
    i32.const 7
    local.get 0
    i32.const 8
    call_indirect (type 2))
  (func (;15;) (type 1) (result i32)
    i32.const 5
    call 1
    call 2
    i32.const 9
    call_indirect (type 0))
  (func (;16;) (type 1) (result i32)
    i32.const 40
    call 1
    call 2
    i32.const 2
    call 1
    call 2
    i32.add)
  (func (;17;) (type 1) (result i32)
    i32.const 11
    call_indirect (type 1))
  (func (;18;) (type 0) (param i32) (result i32)
    local.get 0
    global.get 11
    i32.add)
  (func (;19;) (type 1) (result i32)
    i32.const 4
    call 1
    call 2
    i32.const 13
    call_indirect (type 0))
  (func (;20;) (type 0) (param i32) (result i32)
    local.get 0
    local.get 0
    i32.mul)
  (func (;21;) (type 0) (param i32) (result i32)
    i32.const 2
    call 1
    call 2
    i32.const 3
    call 1
    call 2
    i32.const 15
    call_indirect (type 0)
    i32.add)
  (func (;22;) (type 1) (result i32)
    i32.const 4
    call 1
    call 2
    i32.const 16
    call_indirect (type 0))
  (func (;23;) (type 0) (param i32) (result i32)
    i32.const 2
    call 1
    call 2
    local.get 0
    i32.mul)
  (func (;24;) (type 1) (result i32)
    i32.const 18)
  (func (;25;) (type 1) (result i32)
    i32.const 3
    call 1
    call 2
    global.get 14
    call_indirect (type 1)
    call_indirect (type 0))
  (func (;26;)
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
    i32.const 6
    global.set 7
    i32.const 30
    drop
    i32.const 10
    global.set 8
    i32.const 30
    drop
    i32.const 12
    global.set 9
    i32.const 30
    drop
    i32.const 2
    call 1
    call 2
    global.set 10
    i32.const 30
    drop
    i32.const 3
    call 1
    call 2
    global.set 11
    i32.const 30
    drop
    i32.const 14
    global.set 12
    i32.const 30
    drop
    i32.const 17
    global.set 13
    i32.const 30
    drop
    i32.const 19
    global.set 14
    i32.const 30
    drop
    i32.const 20
    global.set 15
    i32.const 30
    drop)
  (table (;0;) 21 funcref)
  (export "lambda-application" (func 11))
  (export "lambda-argument" (func 15))
  (export "lambda-without-parameters" (func 17))
  (export "lambda-parameters-shadow-globals" (func 19))
  (export "inner-lambda-parameters-shadow-outer" (func 22))
  (export "lambda-procedure-result" (func 25))
  (start 26)
  (elem (;0;) (i32.const 0) func 3 4 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25)
  (type (;3;) (func)))
