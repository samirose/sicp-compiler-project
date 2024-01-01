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
  (import "scheme base" "string=?" (func (;14;) (param i32 i32) (result i32)))
  (import "scheme base" "eq?" (func (;15;) (param i32 i32) (result i32)))
  (global (;0;) i32 (i32.const 2))
  (global (;1;) i32 (i32.const 18))
  (global (;2;) i32 (i32.const 34))
  (global (;3;) i32 (i32.const 50))
  (global (;4;) i32 (i32.const 66))
  (global (;5;) i32 (i32.const 82))
  (global (;6;) i32 (i32.const 98))
  (global (;7;) i32 (i32.const 114))
  (global (;8;) (mut i32) (i32.const 46))
  (global (;9;) (mut i32) (i32.const 46))
  (global (;10;) (mut i32) (i32.const 46))
  (global (;11;) (mut i32) (i32.const 46))
  (global (;12;) (mut i32) (i32.const 46))
  (global (;13;) (mut i32) (i32.const 46))
  (global (;14;) (mut i32) (i32.const 46))
  (global (;15;) (mut i32) (i32.const 46))
  (global (;16;) (mut i32) (i32.const 46))
  (func (;16;) (type 1) (result i32)
    i32.const 0
    global.get 4
    call 9
    call_indirect (type 0))
  (func (;17;) (type 1) (result i32)
    (local i32)
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          i32.const 0
          i32.const 0
          global.get 7
          call 9
          call_indirect (type 2)
          call 7
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          global.get 9
          i32.const 0
          global.get 7
          call 9
          call_indirect (type 2)
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
  (func (;18;) (type 1) (result i32)
    (local i32)
    block  ;; label = @1
      block  ;; label = @2
        i32.const 20
        global.get 9
        global.get 7
        call 9
        call_indirect (type 2)
        local.tee 0
        call 7
        br_if 1 (;@1;)
      end
      global.get 9
      global.get 10
      global.get 7
      call 9
      call_indirect (type 2)
      local.set 0
    end
    local.get 0)
  (func (;19;) (type 0) (param i32) (result i32)
    local.get 0
    global.get 4
    call 9
    call_indirect (type 0))
  (func (;20;) (type 1) (result i32)
    i32.const 28)
  (func (;21;) (type 1) (result i32)
    (local i32 i32)
    i32.const 44
    local.set 0
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          i32.const 8
          global.get 13
          call 9
          call_indirect (type 0)
          call 7
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          global.get 10
          global.get 13
          call 9
          call_indirect (type 0)
          call 7
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          global.get 14
          call 9
          call_indirect (type 1)
          global.get 4
          call 9
          call_indirect (type 0)
          call 7
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          local.get 0
          global.get 4
          call 9
          call_indirect (type 0)
          local.tee 1
          call 7
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        local.get 1
        br 1 (;@1;)
      end
      i32.const 6
    end)
  (func (;22;) (type 1) (result i32)
    (local i32)
    i32.const 60
    local.set 0
    local.get 0
    global.get 4
    call 9
    call_indirect (type 0))
  (func (;23;)
    i32.const 8
    call 8
    global.set 8
    i32.const 0
    global.set 9
    i32.const 8
    global.set 10
    i32.const 9
    call 8
    global.set 11
    i32.const 10
    call 8
    global.set 12
    i32.const 11
    call 8
    global.set 13
    i32.const 12
    call 8
    global.set 14
    i32.const 13
    call 8
    global.set 15
    i32.const 14
    call 8
    global.set 16
    i32.const 30
    drop)
  (table (;0;) 15 funcref)
  (export "literal-symbol-is-symbol" (func 16))
  (export "literal-symbols-with-same-name-are-eq" (func 17))
  (export "literal-symbols-with-different-name-are-not-eq" (func 18))
  (export "literal-symbols-as-values-are-symbols" (func 21))
  (export "symbol-may-contain-special-characters" (func 22))
  (start 23)
  (elem (;0;) (i32.const 0) func 4 5 10 11 12 13 14 15 16 17 18 19 20 21 22)
  (data (;0;) (i32.const 0) "\03\00\00\01foo")
  (data (;1;) (i32.const 8) "\06\00\00\01foobar")
  (data (;2;) (i32.const 20) "\03\00\00\01baz")
  (data (;3;) (i32.const 28) "\0a\00\00\01got-symbol")
  (data (;4;) (i32.const 44) "\0c\00\00\01bound-symbol")
  (data (;5;) (i32.const 60) "\17\00\00\01\22foo\22 \09\0a\0d\5c'bar'\f0\9f\98\80!@\7f\07")
  (type (;3;) (func)))
