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
  (func (;10;) (type 0) (result i32)
    i32.const 1)
  (func (;11;) (type 0) (result i32)
    i32.const 0)
  (func (;12;) (type 0) (result i32)
    i32.const 42
    call 1
    call 2)
  (func (;13;) (type 0) (result i32)
    (local i32)
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          i32.const 1
          call 1
          call 2
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 2
          call 1
          call 2
          local.tee 0
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        local.get 0
        br 1 (;@1;)
      end
      i32.const 0
    end)
  (func (;14;) (type 0) (result i32)
    (local i32 i32)
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          i32.const 0
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 2
          call 1
          call 2
          local.tee 0
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        local.get 0
        br 1 (;@1;)
      end
      i32.const 0
    end
    if (result i32)  ;; label = @1
      i32.const 1
    else
      block (result i32)  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            i32.const 1
            call 1
            call 2
            br_if 0 (;@4;)
            br 1 (;@3;)
          end
          block  ;; label = @4
            i32.const 0
            local.tee 0
            br_if 0 (;@4;)
            br 1 (;@3;)
          end
          local.get 0
          br 1 (;@2;)
        end
        i32.const 0
      end
      if (result i32)  ;; label = @2
        i32.const 1
      else
        i32.const 0
      end
    end)
  (func (;15;) (type 1) (param i32) (result i32)
    local.get 0
    if (result i32)  ;; label = @1
      i32.const 0
    else
      i32.const 1
    end)
  (func (;16;) (type 0) (result i32)
    (local i32 i32)
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          i32.const 0
          call 1
          call 2
          i32.const 1
          call 1
          call 2
          i32.add
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 0
          i32.const 10
          call_indirect (type 1)
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 1
          call 1
          call 2
          local.set 1
          local.get 1
          i32.const 2
          call 1
          call 2
          i32.mul
          local.tee 0
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        local.get 0
        br 1 (;@1;)
      end
      i32.const 0
    end)
  (func (;17;) (type 0) (result i32)
    (local i32 i32)
    i32.const 0
    call 1
    call 2
    local.set 0
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          i32.const 1
          call 1
          call 2
          local.set 0
          i32.const 0
          drop
          i32.const 1
          call 1
          call 2
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 2
          call 1
          call 2
          local.set 0
          i32.const 0
          drop
          i32.const 2
          call 1
          call 2
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 3
          call 1
          call 2
          local.set 0
          i32.const 0
          drop
          i32.const 3
          call 1
          call 2
          local.tee 1
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        local.get 1
        br 1 (;@1;)
      end
      i32.const 0
    end
    drop
    local.get 0)
  (func (;18;) (type 0) (result i32)
    (local i32 i32)
    i32.const 0
    call 1
    call 2
    local.set 0
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          i32.const 1
          call 1
          call 2
          local.set 0
          i32.const 0
          drop
          i32.const 1
          call 1
          call 2
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 2
          call 1
          call 2
          local.set 0
          i32.const 0
          drop
          i32.const 0
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 3
          call 1
          call 2
          local.set 0
          i32.const 0
          drop
          i32.const 3
          call 1
          call 2
          local.tee 1
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        local.get 1
        br 1 (;@1;)
      end
      i32.const 0
    end
    drop
    local.get 0)
  (func (;19;)
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
    i32.const 8
    global.set 10
    i32.const 0
    drop
    i32.const 9
    global.set 11
    i32.const 0
    drop
    i32.const 11
    global.set 12
    i32.const 0
    drop
    i32.const 12
    global.set 13
    i32.const 0
    drop
    i32.const 13
    global.set 14
    i32.const 0
    drop)
  (table (;0;) 14 funcref)
  (export "empty-and-is-true" (func 10))
  (export "and-one-false-is-false" (func 11))
  (export "and-one-non-false-value-is-value" (func 12))
  (export "and-two-non-false-values-is-last-value" (func 13))
  (export "and-any-false-is-false" (func 14))
  (export "and-with-complex-expressions" (func 16))
  (export "and-evaluates-expressions-from-left-to-right" (func 17))
  (export "and-false-short-circuits-to-false" (func 18))
  (start 19)
  (elem (;0;) (i32.const 0) func 3 4 7 8 9 10 11 12 13 14 15 16 17 18)
  (type (;2;) (func (param i32 i32) (result i32)))
  (type (;3;) (func)))
