(module
  (type (;0;) (func (param i32) (result i32)))
  (type (;1;) (func (param i32 i32) (result i32)))
  (type (;2;) (func (result i32)))
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
  (import "scheme base" "eq?" (func (;13;) (param i32 i32) (result i32)))
  (global (;0;) i32 (i32.const 2))
  (global (;1;) i32 (i32.const 18))
  (global (;2;) i32 (i32.const 34))
  (global (;3;) i32 (i32.const 50))
  (global (;4;) i32 (i32.const 66))
  (global (;5;) i32 (i32.const 82))
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
  (global (;16;) (mut i32) (i32.const 46))
  (global (;17;) (mut i32) (i32.const 46))
  (global (;18;) (mut i32) (i32.const 46))
  (global (;19;) (mut i32) (i32.const 46))
  (global (;20;) (mut i32) (i32.const 46))
  (global (;21;) (mut i32) (i32.const 46))
  (global (;22;) (mut i32) (i32.const 46))
  (global (;23;) (mut i32) (i32.const 46))
  (global (;24;) (mut i32) (i32.const 46))
  (global (;25;) (mut i32) (i32.const 46))
  (func (;14;) (type 0) (param i32) (result i32)
    local.get 0
    global.get 0
    call 9
    call_indirect (type 0))
  (func (;15;) (type 0) (param i32) (result i32)
    local.get 0
    global.get 1
    call 9
    call_indirect (type 0))
  (func (;16;) (type 1) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    global.get 5
    call 9
    call_indirect (type 1))
  (func (;17;) (type 2) (result i32)
    i32.const 1
    i32.const 2
    i32.add
    call 1
    global.get 0
    call 9
    call_indirect (type 0))
  (func (;18;) (type 0) (param i32) (result i32)
    local.get 0
    global.get 2
    call 9
    call_indirect (type 0))
  (func (;19;) (type 2) (result i32)
    (local i32)
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          i32.const 1
          call 1
          i32.const 1
          call 1
          global.get 5
          call 9
          call_indirect (type 1)
          global.get 2
          call 9
          call_indirect (type 0)
          call 7
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 1
          call 1
          i32.const 2
          call 1
          global.get 5
          call 9
          call_indirect (type 1)
          global.get 2
          call 9
          call_indirect (type 0)
          local.tee 0
          call 7
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        local.get 0
        br 1 (;@1;)
      end
      i32.const 6
    end)
  (func (;20;) (type 2) (result i32)
    (local i32)
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          i32.const 1
          call 1
          i32.const 2
          call 1
          i32.lt_s
          call 6
          global.get 2
          call 9
          call_indirect (type 0)
          call 7
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 2
          call 1
          i32.const 1
          call 1
          i32.lt_s
          call 6
          global.get 2
          call 9
          call_indirect (type 0)
          call 7
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 1
          call 1
          i32.const 2
          call 1
          i32.le_s
          call 6
          global.get 2
          call 9
          call_indirect (type 0)
          call 7
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 2
          call 1
          i32.const 1
          call 1
          i32.le_s
          call 6
          global.get 2
          call 9
          call_indirect (type 0)
          call 7
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 1
          call 1
          i32.const 1
          call 1
          i32.eq
          call 6
          global.get 2
          call 9
          call_indirect (type 0)
          call 7
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 2
          call 1
          i32.const 1
          call 1
          i32.gt_s
          call 6
          global.get 2
          call 9
          call_indirect (type 0)
          call 7
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 1
          call 1
          i32.const 2
          call 1
          i32.gt_s
          call 6
          global.get 2
          call 9
          call_indirect (type 0)
          call 7
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 2
          call 1
          i32.const 1
          call 1
          i32.ge_s
          call 6
          global.get 2
          call 9
          call_indirect (type 0)
          call 7
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 1
          call 1
          i32.const 2
          call 1
          i32.ge_s
          call 6
          global.get 2
          call 9
          call_indirect (type 0)
          local.tee 0
          call 7
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        local.get 0
        br 1 (;@1;)
      end
      i32.const 6
    end)
  (func (;21;) (type 0) (param i32) (result i32)
    local.get 0
    global.get 3
    call 9
    call_indirect (type 0))
  (func (;22;) (type 0) (param i32) (result i32)
    local.get 0
    call 3
    local.get 0
    call 3
    i32.add
    call 1)
  (func (;23;) (type 2) (result i32)
    i32.const 14
    call 8
    global.get 3
    call 9
    call_indirect (type 0))
  (func (;24;) (type 2) (result i32)
    global.get 14
    global.get 3
    call 9
    call_indirect (type 0))
  (func (;25;) (type 2) (result i32)
    global.get 0
    global.get 3
    call 9
    call_indirect (type 0))
  (func (;26;) (type 0) (param i32) (result i32)
    local.get 0
    call 3
    local.get 0
    call 3
    i32.mul
    call 1)
  (func (;27;) (type 2) (result i32)
    (local i32)
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          i32.const 18
          call 8
          global.get 13
          call 9
          call_indirect (type 0)
          call 7
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          global.get 6
          global.get 13
          call 9
          call_indirect (type 0)
          call 7
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          global.get 1
          global.get 13
          call 9
          call_indirect (type 0)
          local.tee 0
          call 7
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        local.get 0
        br 1 (;@1;)
      end
      i32.const 6
    end)
  (func (;28;) (type 0) (param i32) (result i32)
    local.get 0
    call 3
    local.get 0
    call 3
    i32.add
    call 1)
  (func (;29;) (type 2) (result i32)
    i32.const 20
    call 8)
  (func (;30;) (type 2) (result i32)
    global.get 18
    call 9
    call_indirect (type 2)
    global.get 3
    call 9
    call_indirect (type 0))
  (func (;31;) (type 2) (result i32)
    global.get 0
    global.get 0
    global.get 5
    call 9
    call_indirect (type 1))
  (func (;32;) (type 2) (result i32)
    (local i32)
    block  ;; label = @1
      block  ;; label = @2
        global.get 0
        global.get 1
        global.get 5
        call 9
        call_indirect (type 1)
        local.tee 0
        call 7
        br_if 1 (;@1;)
      end
      global.get 1
      global.get 0
      global.get 5
      call 9
      call_indirect (type 1)
      local.set 0
    end
    local.get 0)
  (func (;33;) (type 0) (param i32) (result i32)
    global.get 0
    local.get 0
    global.get 5
    call 9
    call_indirect (type 1))
  (func (;34;) (type 2) (result i32)
    i32.const 0
    global.get 4
    call 9
    call_indirect (type 0))
  (func (;35;) (type 0) (param i32) (result i32)
    local.get 0
    global.get 4
    call 9
    call_indirect (type 0))
  (func (;36;) (type 2) (result i32)
    global.get 18
    global.get 4
    call 9
    call_indirect (type 0))
  (func (;37;)
    i32.const 6
    call 8
    global.set 6
    i32.const 7
    call 8
    global.set 7
    i32.const 8
    call 8
    global.set 8
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
    i32.const 19
    call 8
    global.set 17
    i32.const 21
    call 8
    global.set 18
    i32.const 22
    call 8
    global.set 19
    i32.const 23
    call 8
    global.set 20
    i32.const 24
    call 8
    global.set 21
    i32.const 25
    call 8
    global.set 22
    i32.const 26
    call 8
    global.set 23
    i32.const 27
    call 8
    global.set 24
    i32.const 28
    call 8
    global.set 25
    i32.const 30
    drop)
  (table (;0;) 29 funcref)
  (export "is-number?" (func 14))
  (export "is-zero?" (func 15))
  (export "is-eq?" (func 16))
  (export "numeric-exp-is-number?" (func 17))
  (export "is-boolean?" (func 18))
  (export "eq?-evaluates-to-boolean-value" (func 19))
  (export "arithmetic-comparison-operators-evaluate-to-boolean-values" (func 20))
  (export "is-procedure?" (func 21))
  (export "lambda-is-procedure?" (func 23))
  (export "defined-procedure-is-procedure?" (func 24))
  (export "imported-procedure-is-procedure?" (func 25))
  (export "procedure-argument-is-procedure?" (func 27))
  (export "procedure-from-procedure-is-procedure?" (func 30))
  (export "is-procedure-eq-to-same-procedure?" (func 31))
  (export "is-procedure-eq-to-different-procedure?" (func 32))
  (export "is-procedure-number?-eq-to" (func 33))
  (export "symbol-is-symbol?" (func 34))
  (export "is-symbol?" (func 35))
  (export "procedure-is-symbol?" (func 36))
  (start 37)
  (elem (;0;) (i32.const 0) func 4 5 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36)
  (data (;0;) (i32.const 0) "\03\00\00\01sym")
  (type (;3;) (func)))
