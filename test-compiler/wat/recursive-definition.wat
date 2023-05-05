(module
  (type (;0;) (func (param i32 i32 i32) (result i32)))
  (type (;1;) (func (param i32 i32) (result i32)))
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
  (func (;13;) (type 0) (param i32 i32 i32) (result i32)
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            call 2
            local.get 1
            call 2
            i32.lt_s
            call 6
            call 7
            br_if 0 (;@4;)
            br 1 (;@3;)
          end
          local.get 0
          br 2 (;@1;)
        end
        block  ;; label = @3
          block  ;; label = @4
            local.get 2
            call 2
            local.get 0
            call 2
            i32.le_s
            call 6
            call 7
            br_if 0 (;@4;)
            br 1 (;@3;)
          end
          local.get 0
          call 3
          local.get 2
          call 3
          i32.sub
          call 1
          local.get 1
          local.get 2
          call 3
          local.get 1
          call 3
          i32.mul
          call 1
          global.get 7
          call 9
          call_indirect (type 0)
          br 2 (;@1;)
        end
      end
      local.get 0
      local.get 1
      local.get 2
      call 3
      local.get 1
      call 3
      i32.div_s
      call 1
      global.get 7
      call 9
      call_indirect (type 0)
    end)
  (func (;14;) (type 1) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    local.get 1
    global.get 7
    call 9
    call_indirect (type 0))
  (func (;15;) (type 1) (param i32 i32) (result i32)
    local.get 1
    call 2
    i32.const 0
    call 1
    call 2
    i32.eq
    call 6
    call 7
    if (result i32)  ;; label = @1
      local.get 0
    else
      local.get 1
      local.get 0
      local.get 1
      global.get 8
      call 9
      call_indirect (type 1)
      global.get 9
      call 9
      call_indirect (type 1)
    end)
  (func (;16;) (type 1) (param i32 i32) (result i32)
    (local i32 i32)
    local.get 0
    call 2
    i32.const 0
    call 1
    call 2
    i32.lt_s
    call 6
    call 7
    if (result i32)  ;; label = @1
      i32.const 0
      local.get 0
      call 3
      i32.sub
      call 1
    else
      local.get 0
    end
    local.set 2
    local.get 1
    call 2
    i32.const 0
    call 1
    call 2
    i32.lt_s
    call 6
    call 7
    if (result i32)  ;; label = @1
      i32.const 0
      local.get 1
      call 3
      i32.sub
      call 1
    else
      local.get 1
    end
    local.set 3
    local.get 2
    local.get 3
    global.get 9
    call 9
    call_indirect (type 1))
  (func (;17;)
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
    i32.const 7
    call 8
    global.set 9
    i32.const 8
    call 8
    global.set 10
    i32.const 30
    drop)
  (table (;0;) 9 funcref)
  (export "gcd-test" (func 16))
  (start 17)
  (elem (;0;) (i32.const 0) func 4 5 10 11 12 13 14 15 16)
  (type (;2;) (func (result i32)))
  (type (;3;) (func (param i32) (result i32)))
  (type (;4;) (func)))
