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
  (global (;0;) i32 (i32.const 2))
  (global (;1;) i32 (i32.const 18))
  (global (;2;) i32 (i32.const 34))
  (global (;3;) i32 (i32.const 50))
  (global (;4;) i32 (i32.const 66))
  (global (;5;) i32 (i32.const 82))
  (global (;6;) i32 (i32.const 98))
  (global (;7;) i32 (i32.const 114))
  (global (;8;) i32 (i32.const 130))
  (global (;9;) (mut i32) (i32.const 46))
  (global (;10;) (mut i32) (i32.const 46))
  (global (;11;) (mut i32) (i32.const 46))
  (global (;12;) (mut i32) (i32.const 46))
  (global (;13;) (mut i32) (i32.const 46))
  (global (;14;) (mut i32) (i32.const 46))
  (global (;15;) (mut i32) (i32.const 46))
  (global (;16;) (mut i32) (i32.const 46))
  (func (;17;) (type 0) (result i32)
    i32.const 6)
  (func (;18;) (type 0) (result i32)
    i32.const 6)
  (func (;19;) (type 0) (result i32)
    i32.const 42
    call 1)
  (func (;20;) (type 0) (result i32)
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
  (func (;21;) (type 0) (result i32)
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
  (func (;22;) (type 1) (param i32) (result i32)
    local.get 0
    call 7
    if (result i32)  ;; label = @1
      i32.const 22
    else
      i32.const 6
    end)
  (func (;23;) (type 0) (result i32)
    (local i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        i32.const 6
        i32.const 14
        call_indirect (type 1)
        local.tee 0
        call 7
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        i32.const 0
        i32.const 1
        i32.add
        call 1
        i32.const 2
        call 1
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
      i32.mul
      call 1
      local.set 0
    end
    local.get 0)
  (func (;24;) (type 0) (result i32)
    (local i32 i32)
    i32.const 0
    call 1
    local.set 0
    block  ;; label = @1
      block  ;; label = @2
        i32.const 1
        call 1
        local.set 0
        local.get 0
        call 2
        i32.const 1
        call 1
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
        local.get 0
        call 2
        i32.const 2
        call 1
        i32.gt_s
        call 6
        local.tee 1
        call 7
        br_if 1 (;@1;)
      end
      i32.const 3
      call 1
      local.set 0
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
  (func (;25;) (type 0) (result i32)
    (local i32 i32)
    i32.const 0
    call 1
    local.set 0
    block  ;; label = @1
      block  ;; label = @2
        i32.const 1
        call 1
        local.set 0
        i32.const 6
        local.tee 1
        call 7
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        i32.const 2
        call 1
        local.set 0
        i32.const 2
        call 1
        local.tee 1
        call 7
        br_if 1 (;@1;)
      end
      i32.const 3
      call 1
      local.set 0
      i32.const 3
      call 1
      local.set 1
    end
    local.get 1
    drop
    local.get 0)
  (func (;26;)
    i32.const 9
    call 8
    global.set 9
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
    i32.const 15
    call 8
    global.set 14
    i32.const 16
    call 8
    global.set 15
    i32.const 17
    call 8
    global.set 16
    i32.const 30
    drop)
  (table (;0;) 18 funcref)
  (export "empty-or-is-false" (func 17))
  (export "or-one-false-is-false" (func 18))
  (export "or-one-non-false-value-is-value" (func 19))
  (export "or-two-non-falses-is-first-value" (func 20))
  (export "or-any-non-false-is-non-false" (func 21))
  (export "or-with-complex-expressions" (func 23))
  (export "or-evaluates-expressions-from-left-to-right" (func 24))
  (export "or-true-short-circuits-to-true" (func 25))
  (start 26)
  (elem (;0;) (i32.const 0) func 4 5 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25)
  (type (;2;) (func (param i32 i32) (result i32)))
  (type (;3;) (func)))
