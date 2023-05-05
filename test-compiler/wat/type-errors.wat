(module
  (type (;0;) (func (param i32) (result i32)))
  (type (;1;) (func (result i32)))
  (type (;2;) (func (param i32 i32) (result i32)))
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
  (func (;13;) (type 0) (param i32) (result i32)
    local.get 0
    call 3
    i32.const 2
    i32.add
    call 1)
  (func (;14;) (type 0) (param i32) (result i32)
    i32.const 2
    local.get 0
    call 3
    i32.mul
    call 1)
  (func (;15;) (type 0) (param i32) (result i32)
    local.get 0
    call 3
    local.get 0
    call 3
    i32.mul
    call 1)
  (func (;16;) (type 1) (result i32)
    i32.const 7
    call 8
    global.get 8
    call 9
    call_indirect (type 0))
  (func (;17;) (type 1) (result i32)
    global.get 8
    global.get 7
    call 9
    call_indirect (type 0))
  (func (;18;) (type 2) (param i32 i32) (result i32)
    local.get 1
    local.get 0
    call 9
    call_indirect (type 0))
  (func (;19;) (type 1) (result i32)
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            i32.const 6
            call 7
            br_if 0 (;@4;)
            br 1 (;@3;)
          end
          i32.const 42
          call 1
          br 2 (;@1;)
        end
      end
      i32.const 30
    end
    global.get 7
    call 9
    call_indirect (type 0))
  (func (;20;) (type 0) (param i32) (result i32)
    local.get 0
    call 3
    i32.const 1
    i32.add
    call 1)
  (func (;21;) (type 0) (param i32) (result i32)
    local.get 0
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            i32.const 6
            call 7
            br_if 0 (;@4;)
            br 1 (;@3;)
          end
          i32.const 12
          call 8
          br 2 (;@1;)
        end
      end
      i32.const 30
    end
    call 9
    call_indirect (type 0))
  (func (;22;)
    i32.const 2
    global.set 2
    i32.const 18
    global.set 3
    i32.const 34
    global.set 4
    i32.const 50
    global.set 5
    i32.const 66
    global.set 6
    i32.const 5
    call 8
    global.set 7
    i32.const 6
    call 8
    global.set 8
    i32.const 8
    call 8
    global.set 9
    i32.const 9
    call 8
    global.set 10
    i32.const 10
    call 8
    global.set 11
    i32.const 11
    call 8
    global.set 12
    i32.const 13
    call 8
    global.set 13
    i32.const 30
    drop)
  (table (;0;) 14 funcref)
  (export "plus-two" (func 13))
  (export "two-times" (func 14))
  (export "lambda-two-times" (func 16))
  (export "procedure-plus-two" (func 17))
  (export "apply-to" (func 18))
  (export "unspecified-plus-two" (func 19))
  (export "unspecified-as-operator" (func 21))
  (start 22)
  (elem (;0;) (i32.const 0) func 4 5 10 11 12 13 14 15 16 17 18 19 20 21)
  (type (;3;) (func)))
