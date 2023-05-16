(module
  (type (;0;) (func (result i32)))
  (type (;1;) (func (param i32 i32) (result i32)))
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
    (local i32)
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          i32.const 1
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 1
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 1
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 1
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 1
          local.tee 0
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        local.get 0
        br 1 (;@1;)
      end
      i32.const 0
    end)
  (func (;11;) (type 1) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    i32.eq)
  (func (;12;) (type 1) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    i32.gt_s)
  (func (;13;) (type 1) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    i32.lt_s)
  (func (;14;) (type 1) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    i32.ge_s)
  (func (;15;) (type 1) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    i32.le_s)
  (func (;16;) (type 0) (result i32)
    (local i32 i32 i32 i32 i32 i32)
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block (result i32)  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                i32.const 1
                call 1
                call 2
                i32.const 1
                call 1
                call 2
                i32.eq
                br_if 0 (;@6;)
                br 1 (;@5;)
              end
              block  ;; label = @6
                i32.const 1
                call 1
                call 2
                i32.const 1
                call 1
                call 2
                i32.eq
                local.tee 0
                br_if 0 (;@6;)
                br 1 (;@5;)
              end
              local.get 0
              br 1 (;@4;)
            end
            i32.const 0
          end
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          block (result i32)  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                i32.const 1
                call 1
                call 2
                i32.const 2
                call 1
                call 2
                i32.lt_s
                br_if 0 (;@6;)
                br 1 (;@5;)
              end
              block  ;; label = @6
                i32.const 2
                call 1
                call 2
                i32.const 3
                call 1
                call 2
                i32.lt_s
                br_if 0 (;@6;)
                br 1 (;@5;)
              end
              block  ;; label = @6
                i32.const 3
                call 1
                call 2
                i32.const 4
                call 1
                call 2
                i32.lt_s
                local.tee 0
                br_if 0 (;@6;)
                br 1 (;@5;)
              end
              local.get 0
              br 1 (;@4;)
            end
            i32.const 0
          end
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          block (result i32)  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                i32.const 3
                call 1
                call 2
                i32.const 2
                call 1
                call 2
                i32.gt_s
                br_if 0 (;@6;)
                br 1 (;@5;)
              end
              block  ;; label = @6
                i32.const 2
                call 1
                call 2
                i32.const 1
                call 1
                call 2
                i32.gt_s
                br_if 0 (;@6;)
                br 1 (;@5;)
              end
              block  ;; label = @6
                i32.const 1
                call 1
                call 2
                i32.const 0
                call 1
                call 2
                i32.gt_s
                br_if 0 (;@6;)
                br 1 (;@5;)
              end
              block  ;; label = @6
                i32.const 0
                call 1
                call 2
                i32.const -1
                call 1
                call 2
                i32.gt_s
                local.tee 0
                br_if 0 (;@6;)
                br 1 (;@5;)
              end
              local.get 0
              br 1 (;@4;)
            end
            i32.const 0
          end
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          block (result i32)  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                i32.const 1
                call 1
                call 2
                i32.const 2
                call 1
                call 2
                i32.le_s
                br_if 0 (;@6;)
                br 1 (;@5;)
              end
              block  ;; label = @6
                i32.const 2
                call 1
                call 2
                i32.const 2
                call 1
                call 2
                i32.le_s
                br_if 0 (;@6;)
                br 1 (;@5;)
              end
              block  ;; label = @6
                i32.const 2
                call 1
                call 2
                i32.const 3
                call 1
                call 2
                i32.le_s
                local.tee 0
                br_if 0 (;@6;)
                br 1 (;@5;)
              end
              local.get 0
              br 1 (;@4;)
            end
            i32.const 0
          end
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          block (result i32)  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                i32.const 3
                call 1
                call 2
                i32.const 2
                call 1
                call 2
                i32.ge_s
                br_if 0 (;@6;)
                br 1 (;@5;)
              end
              block  ;; label = @6
                i32.const 2
                call 1
                call 2
                i32.const 2
                call 1
                call 2
                i32.ge_s
                br_if 0 (;@6;)
                br 1 (;@5;)
              end
              block  ;; label = @6
                i32.const 2
                call 1
                call 2
                i32.const 1
                call 1
                call 2
                i32.ge_s
                local.tee 1
                br_if 0 (;@6;)
                br 1 (;@5;)
              end
              local.get 1
              br 1 (;@4;)
            end
            i32.const 0
          end
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
    (local i32 i32 i32 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        block (result i32)  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              i32.const 1
              call 1
              call 2
              i32.const 1
              call 1
              call 2
              i32.eq
              br_if 0 (;@5;)
              br 1 (;@4;)
            end
            block  ;; label = @5
              i32.const 1
              call 1
              call 2
              i32.const 0
              call 1
              call 2
              i32.eq
              local.tee 1
              br_if 0 (;@5;)
              br 1 (;@4;)
            end
            local.get 1
            br 1 (;@3;)
          end
          i32.const 0
        end
        local.tee 0
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        block (result i32)  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              i32.const 1
              call 1
              call 2
              i32.const 2
              call 1
              call 2
              i32.lt_s
              br_if 0 (;@5;)
              br 1 (;@4;)
            end
            block  ;; label = @5
              i32.const 2
              call 1
              call 2
              i32.const 4
              call 1
              call 2
              i32.lt_s
              br_if 0 (;@5;)
              br 1 (;@4;)
            end
            block  ;; label = @5
              i32.const 4
              call 1
              call 2
              i32.const 3
              call 1
              call 2
              i32.lt_s
              local.tee 1
              br_if 0 (;@5;)
              br 1 (;@4;)
            end
            local.get 1
            br 1 (;@3;)
          end
          i32.const 0
        end
        local.tee 0
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        block (result i32)  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              i32.const 3
              call 1
              call 2
              i32.const 2
              call 1
              call 2
              i32.gt_s
              br_if 0 (;@5;)
              br 1 (;@4;)
            end
            block  ;; label = @5
              i32.const 2
              call 1
              call 2
              i32.const 1
              call 1
              call 2
              i32.gt_s
              br_if 0 (;@5;)
              br 1 (;@4;)
            end
            block  ;; label = @5
              i32.const 1
              call 1
              call 2
              i32.const -1
              call 1
              call 2
              i32.gt_s
              br_if 0 (;@5;)
              br 1 (;@4;)
            end
            block  ;; label = @5
              i32.const -1
              call 1
              call 2
              i32.const 0
              call 1
              call 2
              i32.gt_s
              local.tee 1
              br_if 0 (;@5;)
              br 1 (;@4;)
            end
            local.get 1
            br 1 (;@3;)
          end
          i32.const 0
        end
        local.tee 0
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        block (result i32)  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              i32.const 1
              call 1
              call 2
              i32.const 2
              call 1
              call 2
              i32.le_s
              br_if 0 (;@5;)
              br 1 (;@4;)
            end
            block  ;; label = @5
              i32.const 2
              call 1
              call 2
              i32.const 0
              call 1
              call 2
              i32.le_s
              br_if 0 (;@5;)
              br 1 (;@4;)
            end
            block  ;; label = @5
              i32.const 0
              call 1
              call 2
              i32.const 2
              call 1
              call 2
              i32.le_s
              local.tee 1
              br_if 0 (;@5;)
              br 1 (;@4;)
            end
            local.get 1
            br 1 (;@3;)
          end
          i32.const 0
        end
        local.tee 0
        br_if 1 (;@1;)
      end
      block (result i32)  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            i32.const 3
            call 1
            call 2
            i32.const 2
            call 1
            call 2
            i32.ge_s
            br_if 0 (;@4;)
            br 1 (;@3;)
          end
          block  ;; label = @4
            i32.const 2
            call 1
            call 2
            i32.const 3
            call 1
            call 2
            i32.ge_s
            br_if 0 (;@4;)
            br 1 (;@3;)
          end
          block  ;; label = @4
            i32.const 3
            call 1
            call 2
            i32.const 2
            call 1
            call 2
            i32.ge_s
            local.tee 1
            br_if 0 (;@4;)
            br 1 (;@3;)
          end
          local.get 1
          br 1 (;@2;)
        end
        i32.const 0
      end
      local.set 0
    end
    local.get 0)
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
    i32.const 10
    global.set 12
    i32.const 0
    drop
    i32.const 11
    global.set 13
    i32.const 0
    drop
    i32.const 12
    global.set 14
    i32.const 0
    drop)
  (table (;0;) 13 funcref)
  (export "all-with-single-argument-are-true" (func 10))
  (export "binary-equal" (func 11))
  (export "binary-greater-than" (func 12))
  (export "binary-less-than" (func 13))
  (export "binary-greater-or-equal-than" (func 14))
  (export "binary-less-or-equal-than" (func 15))
  (export "more-than-two-params-true" (func 16))
  (export "more-than-two-params-false" (func 17))
  (start 18)
  (elem (;0;) (i32.const 0) func 3 4 7 8 9 10 11 12 13 14 15 16 17)
  (type (;2;) (func (param i32) (result i32)))
  (type (;3;) (func)))
