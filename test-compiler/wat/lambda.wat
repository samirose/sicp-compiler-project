(module
  (type (;0;) (func (param i32) (result i32)))
  (type (;1;) (func (result i32)))
  (type (;2;) (func (param i32 i32) (result i32)))
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
  (func (;18;) (type 0) (param i32) (result i32)
    local.get 0
    call 3
    local.get 0
    call 3
    i32.mul
    call 1)
  (func (;19;) (type 1) (result i32)
    i32.const 2
    call 1
    i32.const 10
    call_indirect (type 0))
  (func (;20;) (type 2) (param i32 i32) (result i32)
    local.get 1
    call 2
    i32.const 1
    call 1
    i32.eq
    if (result i32)  ;; label = @1
      i32.const 1
      call 1
    else
      local.get 1
      call 3
      local.get 0
      local.get 1
      call 3
      i32.const 1
      i32.sub
      call 1
      local.get 0
      call 9
      call_indirect (type 2)
      call 3
      i32.mul
      call 1
    end)
  (func (;21;) (type 2) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    local.get 0
    call 9
    call_indirect (type 2))
  (func (;22;) (type 0) (param i32) (result i32)
    i32.const 12
    call 8
    local.get 0
    i32.const 13
    call_indirect (type 2))
  (func (;23;) (type 1) (result i32)
    i32.const 5
    call 1
    i32.const 14
    call_indirect (type 0))
  (func (;24;) (type 1) (result i32)
    i32.const 40
    i32.const 2
    i32.add
    call 1)
  (func (;25;) (type 1) (result i32)
    i32.const 16
    call_indirect (type 1))
  (func (;26;) (type 0) (param i32) (result i32)
    local.get 0
    call 3
    global.get 14
    call 3
    i32.add
    call 1)
  (func (;27;) (type 1) (result i32)
    i32.const 4
    call 1
    i32.const 18
    call_indirect (type 0))
  (func (;28;) (type 0) (param i32) (result i32)
    local.get 0
    call 3
    local.get 0
    call 3
    i32.mul
    call 1)
  (func (;29;) (type 0) (param i32) (result i32)
    i32.const 2
    i32.const 3
    call 1
    i32.const 20
    call_indirect (type 0)
    call 3
    i32.add
    call 1)
  (func (;30;) (type 1) (result i32)
    i32.const 4
    call 1
    i32.const 21
    call_indirect (type 0))
  (func (;31;) (type 0) (param i32) (result i32)
    i32.const 2
    local.get 0
    call 3
    i32.mul
    call 1)
  (func (;32;) (type 1) (result i32)
    i32.const 23
    call 8)
  (func (;33;) (type 1) (result i32)
    i32.const 3
    call 1
    global.get 17
    call 9
    call_indirect (type 1)
    call 9
    call_indirect (type 0))
  (func (;34;)
    i32.const 11
    call 8
    global.set 10
    i32.const 15
    call 8
    global.set 11
    i32.const 17
    call 8
    global.set 12
    i32.const 2
    call 1
    global.set 13
    i32.const 3
    call 1
    global.set 14
    i32.const 19
    call 8
    global.set 15
    i32.const 22
    call 8
    global.set 16
    i32.const 24
    call 8
    global.set 17
    i32.const 25
    call 8
    global.set 18
    i32.const 30
    drop)
  (table (;0;) 26 funcref)
  (export "lambda-application" (func 19))
  (export "lambda-argument" (func 23))
  (export "lambda-without-parameters" (func 25))
  (export "lambda-parameters-shadow-globals" (func 27))
  (export "inner-lambda-parameters-shadow-outer" (func 30))
  (export "lambda-procedure-result" (func 33))
  (start 34)
  (elem (;0;) (i32.const 0) func 4 5 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33)
  (type (;3;) (func)))
