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
  (global (;17;) (mut i32) (i32.const 46))
  (func (;16;) (type 1) (result i32)
    i32.const 0
    global.get 5
    call 9
    call_indirect (type 0))
  (func (;17;) (type 0) (param i32) (result i32)
    local.get 0
    global.get 5
    call 9
    call_indirect (type 0))
  (func (;18;) (type 1) (result i32)
    i32.const 20)
  (func (;19;) (type 1) (result i32)
    (local i32 i32)
    i32.const 36
    local.set 0
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          i32.const 52
          global.get 10
          call 9
          call_indirect (type 0)
          call 7
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          global.get 9
          global.get 10
          call 9
          call_indirect (type 0)
          call 7
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          global.get 11
          call 9
          call_indirect (type 1)
          global.get 5
          call 9
          call_indirect (type 0)
          call 7
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          local.get 0
          global.get 5
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
  (func (;20;) (type 1) (result i32)
    (local i32)
    i32.const 64
    local.set 0
    local.get 0
    global.get 5
    call 9
    call_indirect (type 0))
  (func (;21;) (type 1) (result i32)
    i32.const 112
    i32.const 116
    global.get 6
    call 9
    call_indirect (type 2))
  (func (;22;) (type 1) (result i32)
    i32.const 120
    i32.const 156
    global.get 6
    call 9
    call_indirect (type 2))
  (func (;23;) (type 1) (result i32)
    i32.const 192
    i32.const 204
    global.get 6
    call 9
    call_indirect (type 2))
  (func (;24;) (type 1) (result i32)
    i32.const 216
    i32.const 228
    global.get 6
    call 9
    call_indirect (type 2))
  (func (;25;)
    i32.const 8
    call 8
    global.set 8
    i32.const 8
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
    i32.const 12
    call 8
    global.set 13
    i32.const 13
    call 8
    global.set 14
    i32.const 14
    call 8
    global.set 15
    i32.const 15
    call 8
    global.set 16
    i32.const 16
    call 8
    global.set 17
    i32.const 30
    drop)
  (table (;0;) 17 funcref)
  (export "literal-string-is-string" (func 16))
  (export "literal-strings-as-values-are-strings" (func 19))
  (export "string-may-contain-special-characters" (func 20))
  (export "string=?-empty-literal-strings" (func 21))
  (export "string=?-literal-strings-with-equal-content" (func 22))
  (export "string=?-literal-strings-with-same-length-nonequal-content" (func 23))
  (export "string=?-literal-strings-with-different-length" (func 24))
  (start 25)
  (elem (;0;) (i32.const 0) func 4 5 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24)
  (data (;0;) (i32.const 0) "\03\00\00\02foo")
  (data (;1;) (i32.const 8) "\06\00\00\02foobar")
  (data (;2;) (i32.const 20) "\0a\00\00\02got string")
  (data (;3;) (i32.const 36) "\0c\00\00\02bound string")
  (data (;4;) (i32.const 52) "\06\00\00\02foobar")
  (data (;5;) (i32.const 64) ")\00\00\02foo \09\0a\0d\5c'bar' \f0\9f\98\80 \f0\9f\a4\a6\f0\9f\8f\bc\e2\80\8d\e2\99\82\ef\b8\8f !@\7f\07")
  (data (;6;) (i32.const 112) "\00\00\00\02")
  (data (;7;) (i32.const 116) "\00\00\00\02")
  (data (;8;) (i32.const 120) " \00\00\02:foo#\f0\9f\98\80\f0\9f\a4\a6\f0\9f\8f\bc\e2\80\8d\e2\99\82\ef\b8\8fbar!\0d\0a")
  (data (;9;) (i32.const 156) " \00\00\02:foo#\f0\9f\98\80\f0\9f\a4\a6\f0\9f\8f\bc\e2\80\8d\e2\99\82\ef\b8\8fbar!\0d\0a")
  (data (;10;) (i32.const 192) "\08\00\00\02:foobar#")
  (data (;11;) (i32.const 204) "\08\00\00\02:foobaz#")
  (data (;12;) (i32.const 216) "\08\00\00\02:foobar#")
  (data (;13;) (i32.const 228) "\09\00\00\02:foobazz#")
  (type (;3;) (func)))
