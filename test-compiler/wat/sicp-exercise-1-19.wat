(module
  (type (;0;) (func (param i32) (result i32)))
  (type (;1;) (func (param i32 i32) (result i32)))
  (type (;2;) (func (param i32 i32 i32 i32 i32) (result i32)))
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
  (func (;18;) (type 0) (param i32) (result i32)
    local.get 0
    call 3
    local.get 0
    call 3
    i32.mul
    call 1)
  (func (;19;) (type 1) (param i32 i32) (result i32)
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            call 2
            i32.const 0
            call 1
            i32.eq
            br_if 0 (;@4;)
            br 1 (;@3;)
          end
          i32.const 22
          br 2 (;@1;)
        end
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            call 2
            i32.const -1
            call 1
            i32.eq
            br_if 0 (;@4;)
            br 1 (;@3;)
          end
          i32.const 6
          br 2 (;@1;)
        end
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            call 2
            local.get 1
            call 2
            i32.le_s
            br_if 0 (;@4;)
            br 1 (;@3;)
          end
          local.get 0
          call 3
          local.get 1
          call 3
          i32.sub
          call 1
          local.get 1
          call 3
          i32.const 2
          i32.mul
          call 1
          global.get 11
          call 9
          call_indirect (type 1)
          br 2 (;@1;)
        end
      end
      local.get 0
      local.get 1
      call 3
      i32.const 2
      i32.div_s
      call 1
      global.get 11
      call 9
      call_indirect (type 1)
    end)
  (func (;20;) (type 0) (param i32) (result i32)
    local.get 0
    call 2
    i32.const 0
    call 1
    i32.gt_s
    if (result i32)  ;; label = @1
      i32.const 0
      local.get 0
      call 3
      i32.sub
      call 1
    else
      local.get 0
    end
    i32.const -2
    call 1
    global.get 11
    call 9
    call_indirect (type 1))
  (func (;21;) (type 2) (param i32 i32 i32 i32 i32) (result i32)
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 4
            call 2
            i32.const 0
            call 1
            i32.eq
            br_if 0 (;@4;)
            br 1 (;@3;)
          end
          local.get 1
          br 2 (;@1;)
        end
        block  ;; label = @3
          block  ;; label = @4
            local.get 4
            global.get 12
            call 9
            call_indirect (type 0)
            call 7
            br_if 0 (;@4;)
            br 1 (;@3;)
          end
          local.get 0
          local.get 1
          local.get 2
          global.get 10
          call 9
          call_indirect (type 0)
          call 3
          local.get 3
          global.get 10
          call 9
          call_indirect (type 0)
          call 3
          i32.add
          call 1
          i32.const 2
          local.get 2
          call 3
          i32.mul
          local.get 3
          call 3
          i32.mul
          local.get 3
          global.get 10
          call 9
          call_indirect (type 0)
          call 3
          i32.add
          call 1
          local.get 4
          call 3
          i32.const 2
          i32.div_s
          call 1
          global.get 13
          call 9
          call_indirect (type 2)
          br 2 (;@1;)
        end
      end
      local.get 1
      call 3
      local.get 3
      call 3
      i32.mul
      local.get 0
      call 3
      local.get 3
      call 3
      i32.mul
      i32.add
      local.get 0
      call 3
      local.get 2
      call 3
      i32.mul
      i32.add
      call 1
      local.get 1
      call 3
      local.get 2
      call 3
      i32.mul
      local.get 0
      call 3
      local.get 3
      call 3
      i32.mul
      i32.add
      call 1
      local.get 2
      local.get 3
      local.get 4
      call 3
      i32.const 1
      i32.sub
      call 1
      global.get 13
      call 9
      call_indirect (type 2)
    end)
  (func (;22;) (type 0) (param i32) (result i32)
    i32.const 1
    call 1
    i32.const 0
    call 1
    i32.const 0
    call 1
    i32.const 1
    call 1
    local.get 0
    global.get 13
    call 9
    call_indirect (type 2))
  (func (;23;)
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
    i32.const 30
    drop)
  (table (;0;) 15 funcref)
  (export "fib" (func 22))
  (start 23)
  (elem (;0;) (i32.const 0) func 4 5 10 11 12 13 14 15 16 17 18 19 20 21 22)
  (type (;3;) (func (result i32)))
  (type (;4;) (func)))
