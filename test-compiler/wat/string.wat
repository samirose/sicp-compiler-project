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
  (global (;17;) (mut i32) (i32.const 46))
  (global (;18;) (mut i32) (i32.const 46))
  (global (;19;) (mut i32) (i32.const 46))
  (global (;20;) (mut i32) (i32.const 46))
  (func (;17;) (type 1) (result i32)
    i32.const 0
    global.get 5
    call 9
    call_indirect (type 0))
  (func (;18;) (type 0) (param i32) (result i32)
    local.get 0
    global.get 5
    call 9
    call_indirect (type 0))
  (func (;19;) (type 1) (result i32)
    i32.const 20)
  (func (;20;) (type 1) (result i32)
    (local i32 i32)
    i32.const 36
    local.set 0
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          i32.const 52
          global.get 11
          call 9
          call_indirect (type 0)
          call 7
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          global.get 10
          global.get 11
          call 9
          call_indirect (type 0)
          call 7
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          global.get 12
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
  (func (;21;) (type 1) (result i32)
    (local i32)
    i32.const 64
    local.set 0
    local.get 0
    global.get 5
    call 9
    call_indirect (type 0))
  (func (;22;) (type 1) (result i32)
    i32.const 112
    i32.const 116
    global.get 7
    call 9
    call_indirect (type 2))
  (func (;23;) (type 1) (result i32)
    i32.const 120
    i32.const 128
    global.get 7
    call 9
    call_indirect (type 2))
  (func (;24;) (type 1) (result i32)
    i32.const 136
    i32.const 144
    global.get 7
    call 9
    call_indirect (type 2))
  (func (;25;) (type 1) (result i32)
    i32.const 152
    i32.const 188
    global.get 7
    call 9
    call_indirect (type 2))
  (func (;26;) (type 1) (result i32)
    i32.const 224
    i32.const 236
    global.get 7
    call 9
    call_indirect (type 2))
  (func (;27;) (type 1) (result i32)
    i32.const 248
    i32.const 260
    global.get 7
    call 9
    call_indirect (type 2))
  (func (;28;)
    i32.const 9
    call 8
    global.set 9
    i32.const 8
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
    i32.const 17
    call 8
    global.set 18
    i32.const 18
    call 8
    global.set 19
    i32.const 19
    call 8
    global.set 20
    i32.const 30
    drop)
  (table (;0;) 20 funcref)
  (export "literal-string-is-string" (func 17))
  (export "literal-strings-as-values-are-strings" (func 20))
  (export "string-may-contain-special-characters" (func 21))
  (export "string=?-empty-literal-strings" (func 22))
  (export "string=?-one-char-equal-strings" (func 23))
  (export "string=?-one-char-nonequal-strings" (func 24))
  (export "string=?-literal-strings-with-equal-content" (func 25))
  (export "string=?-literal-strings-with-same-length-nonequal-content" (func 26))
  (export "string=?-literal-strings-with-different-length" (func 27))
  (start 28)
  (elem (;0;) (i32.const 0) func 4 5 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27)
  (data (;0;) (i32.const 0) "\03\00\00\02foo")
  (data (;1;) (i32.const 8) "\06\00\00\02foobar")
  (data (;2;) (i32.const 20) "\0a\00\00\02got string")
  (data (;3;) (i32.const 36) "\0c\00\00\02bound string")
  (data (;4;) (i32.const 52) "\06\00\00\02foobar")
  (data (;5;) (i32.const 64) ")\00\00\02foo \09\0a\0d\5c'bar' \f0\9f\98\80 \f0\9f\a4\a6\f0\9f\8f\bc\e2\80\8d\e2\99\82\ef\b8\8f !@\7f\07")
  (data (;6;) (i32.const 112) "\00\00\00\02")
  (data (;7;) (i32.const 116) "\00\00\00\02")
  (data (;8;) (i32.const 120) "\01\00\00\02a")
  (data (;9;) (i32.const 128) "\01\00\00\02a")
  (data (;10;) (i32.const 136) "\01\00\00\02a")
  (data (;11;) (i32.const 144) "\01\00\00\02b")
  (data (;12;) (i32.const 152) " \00\00\02:foo#\f0\9f\98\80\f0\9f\a4\a6\f0\9f\8f\bc\e2\80\8d\e2\99\82\ef\b8\8fbar!\0d\0a")
  (data (;13;) (i32.const 188) " \00\00\02:foo#\f0\9f\98\80\f0\9f\a4\a6\f0\9f\8f\bc\e2\80\8d\e2\99\82\ef\b8\8fbar!\0d\0a")
  (data (;14;) (i32.const 224) "\08\00\00\02:foobar#")
  (data (;15;) (i32.const 236) "\08\00\00\02:foobaz#")
  (data (;16;) (i32.const 248) "\08\00\00\02:foobar#")
  (data (;17;) (i32.const 260) "\09\00\00\02:foobazz#")
  (type (;3;) (func)))
