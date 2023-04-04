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
  (global (;14;) (mut i32) (i32.const 46))
  (func (;11;) (type 0) (result i32)
    i32.const 6)
  (func (;12;) (type 0) (result i32)
    i32.const 6)
  (func (;13;) (type 0) (result i32)
    i32.const 42
    call 1)
  (func (;14;) (type 0) (result i32)
    (local i32)
    block  ;; label = @1
      block  ;; label = @2
        i32.const 1
        call 1
        local.tee 0
        call 7
        br_if 1 (;@1;)
      end
      i32.const 2
      call 1
      local.set 0
    end
    local.get 0)
  (func (;15;) (type 0) (result i32)
    (local i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        i32.const 6
        local.tee 0
        call 7
        br_if 1 (;@1;)
      end
      i32.const 2
      call 1
      local.set 0
    end
    local.get 0
    call 7
    if (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          i32.const 1
          call 1
          local.tee 0
          call 7
          br_if 1 (;@2;)
        end
        i32.const 6
        local.set 0
      end
      local.get 0
      call 7
      if (result i32)  ;; label = @2
        i32.const 22
      else
        i32.const 6
      end
    else
      i32.const 6
    end)
  (func (;16;) (type 1) (param i32) (result i32)
    local.get 0
    call 7
    if (result i32)  ;; label = @1
      i32.const 22
    else
      i32.const 6
    end)
  (func (;17;) (type 0) (result i32)
    (local i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        i32.const 6
        i32.const 10
        call_indirect (type 1)
        local.tee 0
        call 7
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        i32.const 0
        call 1
        call 3
        i32.const 1
        call 1
        call 3
        i32.add
        call 1
        call 2
        i32.const 2
        call 1
        call 2
        i32.gt_s
        call 6
        local.tee 0
        call 7
        br_if 1 (;@1;)
      end
      i32.const 1
      call 1
      local.set 1
      local.get 1
      call 3
      i32.const 2
      call 1
      call 3
      i32.mul
      call 1
      local.set 0
    end
    local.get 0)
  (func (;18;) (type 0) (result i32)
    (local i32 i32)
    i32.const 0
    call 1
    local.set 0
    block  ;; label = @1
      block  ;; label = @2
        i32.const 1
        call 1
        local.set 0
        i32.const 30
        drop
        local.get 0
        call 2
        i32.const 1
        call 1
        call 2
        i32.gt_s
        call 6
        local.tee 1
        call 7
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        i32.const 2
        call 1
        local.set 0
        i32.const 30
        drop
        local.get 0
        call 2
        i32.const 2
        call 1
        call 2
        i32.gt_s
        call 6
        local.tee 1
        call 7
        br_if 1 (;@1;)
      end
      i32.const 3
      call 1
      local.set 0
      i32.const 30
      drop
      i32.const 3
      call 1
      local.set 1
    end
    local.get 1
    call 7
    if (result i32)  ;; label = @1
      local.get 0
    else
      i32.const 6
    end)
  (func (;19;) (type 0) (result i32)
    (local i32 i32)
    i32.const 0
    call 1
    local.set 0
    block  ;; label = @1
      block  ;; label = @2
        i32.const 1
        call 1
        local.set 0
        i32.const 30
        drop
        i32.const 6
        local.tee 1
        call 7
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        i32.const 2
        call 1
        local.set 0
        i32.const 30
        drop
        i32.const 2
        call 1
        local.tee 1
        call 7
        br_if 1 (;@1;)
      end
      i32.const 3
      call 1
      local.set 0
      i32.const 30
      drop
      i32.const 3
      call 1
      local.set 1
    end
    local.get 1
    drop
    local.get 0)
  (func (;20;)
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
    i32.const 11
    global.set 12
    i32.const 30
    drop
    i32.const 12
    global.set 13
    i32.const 30
    drop
    i32.const 13
    global.set 14
    i32.const 30
    drop)
  (table (;0;) 14 funcref)
  (export "empty-or-is-false" (func 11))
  (export "or-one-false-is-false" (func 12))
  (export "or-one-non-false-value-is-value" (func 13))
  (export "or-two-non-falses-is-first-value" (func 14))
  (export "or-any-non-false-is-non-false" (func 15))
  (export "or-with-complex-expressions" (func 17))
  (export "or-evaluates-expressions-from-left-to-right" (func 18))
  (export "or-true-short-circuits-to-true" (func 19))
  (start 20)
  (elem (;0;) (i32.const 0) func 4 5 8 9 10 11 12 13 14 15 16 17 18 19)
  (type (;2;) (func (param i32 i32) (result i32)))
  (type (;3;) (func)))
