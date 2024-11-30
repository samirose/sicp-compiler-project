(module
  (type (;0;) (func (param i32) (result i32)))
  (type (;1;) (func (result i32)))
  (type (;2;) (func (param i32 i32) (result i32)))
  (memory (;0;) 1)
  (export "$heap" (memory 0))
  (global (;0;) (mut i32) (i32.const 0))
  (global (;1;) i32 (i32.const 2))
  (global (;2;) i32 (i32.const 18))
  (global (;3;) i32 (i32.const 34))
  (global (;4;) i32 (i32.const 50))
  (global (;5;) i32 (i32.const 66))
  (global (;6;) i32 (i32.const 82))
  (global (;7;) i32 (i32.const 98))
  (global (;8;) i32 (i32.const 114))
  (global (;9;) i32 (i32.const 130))
  (global (;10;) i32 (i32.const 146))
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
  (func (;0;) (result i32)
    global.get 0
    i32.const 0
    global.set 0)
  (export "get-error-code" (func 0))
  (func (;1;) (param $value i32) (result i32)
    local.get $value
    i32.const 1
    i32.shl
    i32.const 1
    i32.or)
  (func (;2;) (param $obj i32) (result i32)
    local.get $obj
    local.get $obj
    i32.const 1
    i32.and
    i32.const 1
    i32.ne
    if  ;; label = @1
      i32.const 2
      global.set 0
      unreachable
    end)
  (func (;3;) (param $obj i32) (result i32)
    local.get $obj
    call 2
    i32.const 1
    i32.shr_s)
  (func (;4;) (param $value i32) (result i32)
    i32.const 22
    i32.const 6
    local.get $value
    select)
  (func (;5;) (param $obj i32) (result i32)
    i32.const 0
    i32.const 1
    local.get $obj
    i32.const 6
    i32.eq
    select)
  (func (;6;) (param $funcidx i32) (result i32)
    local.get $funcidx
    i32.const 4
    i32.shl
    i32.const 2
    i32.or)
  (func (;7;) (param $obj i32) (result i32)
    local.get $obj
    local.get $obj
    i32.const 15
    i32.and
    i32.const 2
    i32.ne
    if  ;; label = @1
      i32.const 3
      global.set 0
      unreachable
    end)
  (func (;8;) (param $obj i32) (result i32)
    local.get $obj
    call 7
    i32.const 4
    i32.shr_u)
  (func (;9;) (param $obj i32) (result i32)
    local.get $obj
    i32.const 1
    i32.and
    call 4)
  (func (;10;) (param $obj i32) (result i32)
    local.get $obj
    call 3
    i32.eqz
    call 4)
  (func (;11;) (param $obj i32) (result i32)
    local.get $obj
    i32.const 15
    i32.and
    i32.const 6
    i32.eq
    call 4)
  (func (;12;) (param $obj i32) (result i32)
    local.get $obj
    i32.const 15
    i32.and
    i32.const 2
    i32.eq
    call 4)
  (func (;13;) (param $obj i32) (result i32)
    local.get $obj
    i32.const 3
    i32.and
    i32.eqz
    if (result i32)  ;; label = @1
      local.get $obj
      i32.load
      i32.const 251658240
      i32.and
      i32.const 16777216
      i32.eq
      call 4
    else
      i32.const 6
    end)
  (func (;14;) (param $obj i32) (result i32)
    local.get $obj
    i32.const 3
    i32.and
    i32.eqz
    if (result i32)  ;; label = @1
      local.get $obj
      i32.load
      i32.const 251658240
      i32.and
      i32.const 33554432
      i32.eq
      call 4
    else
      i32.const 6
    end)
  (func (;15;) (param $obj1 i32) (param $obj2 i32) (result i32)
    local.get $obj1
    local.get $obj2
    i32.eq
    call 4)
  (func (;16;) (param $obj1 i32) (param $obj2 i32) (result i32)
    local.get $obj1
    local.get $obj2
    call 15)
  (func (;17;) (param $obj i32) (param $type i32) (param $error i32) (result i32)
    block $error
      local.get $obj
      i32.const 3
      i32.and
      br_if $error
      local.get $obj
      i32.load
      i32.const 251658240
      i32.and
      local.get $type
      i32.ne
      br_if $error
      local.get $obj
      return
    end
    local.get $error
    global.set 0
    unreachable)
  (func (;18;) (param $obj i32) (result i32)
    local.get $obj
    i32.const 16777216
    i32.const 4
    call 17)
  (func (;19;) (param $s1 i32) (param $s2 i32) (result i32)
    local.get $s1
    call 18
    local.get $s2
    call 18
    i32.eq
    call 4)
  (func (;20;) (param $obj i32) (param $type i32) (param $error i32) (result i32)
    (local $heap-obj i32)
    block $error
      local.get $obj
      i32.const 3
      i32.and
      br_if $error
      local.get $obj
      i32.load
      local.tee $heap-obj
      i32.const 251658240
      i32.and
      local.get $type
      i32.ne
      br_if $error
      local.get $heap-obj
      return
    end
    local.get $error
    global.set 0
    unreachable)
  (func (;21;) (param $obj i32) (result i32)
    local.get $obj
    i32.const 33554432
    i32.const 5
    call 20)
  (func (;22;) (param $addr1 i32) (param $addr2 i32) (param $n i32) (result i32)
    block $equal_contents
      block $compare_words
        loop $loop
          local.get $n
          i32.eqz
          br_if $compare_words
          local.get $addr1
          i32.load
          local.get $addr1
          i32.const 4
          i32.add
          local.set $addr1
          local.get $addr2
          i32.load
          local.get $addr2
          i32.const 4
          i32.add
          local.set $addr2
          local.get $n
          i32.const 1
          i32.sub
          local.set $n
          i32.eq
          br_if $loop
          br $equal_contents
        end
      end
      i32.const 1
      return
    end
    i32.const 0)
  (func (;23;) (param $s1 i32) (param $s2 i32) (result i32)
    (local $len i32)
    local.get $s1
    call 21
    i32.const 16777215
    i32.and
    local.tee $len
    local.get $s2
    call 21
    i32.const 16777215
    i32.and
    i32.eq
    if (result i32)  ;; label = @1
      local.get $s1
      i32.const 4
      i32.add
      local.get $s2
      i32.const 4
      i32.add
      local.get $len
      i32.const 3
      i32.add
      i32.const 2
      i32.shr_u
      call 22
      call 4
    else
      i32.const 6
    end)
  (func (;24;) (type 1) (result i32)
    i32.const 0
    global.get 6
    call 8
    call_indirect (type 0))
  (func (;25;) (type 0) (param i32) (result i32)
    local.get 0
    global.get 6
    call 8
    call_indirect (type 0))
  (func (;26;) (type 1) (result i32)
    i32.const 20)
  (func (;27;) (type 1) (result i32)
    (local i32 i32)
    i32.const 36
    local.set 0
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          i32.const 52
          global.get 13
          call 8
          call_indirect (type 0)
          call 5
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          global.get 12
          global.get 13
          call 8
          call_indirect (type 0)
          call 5
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          global.get 14
          call 8
          call_indirect (type 1)
          global.get 6
          call 8
          call_indirect (type 0)
          call 5
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          local.get 0
          global.get 6
          call 8
          call_indirect (type 0)
          local.tee 1
          call 5
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        local.get 1
        br 1 (;@1;)
      end
      i32.const 6
    end)
  (func (;28;) (type 1) (result i32)
    (local i32)
    i32.const 64
    local.set 0
    local.get 0
    global.get 6
    call 8
    call_indirect (type 0))
  (func (;29;) (type 1) (result i32)
    i32.const 112
    i32.const 116
    global.get 10
    call 8
    call_indirect (type 2))
  (func (;30;) (type 1) (result i32)
    i32.const 120
    i32.const 128
    global.get 10
    call 8
    call_indirect (type 2))
  (func (;31;) (type 1) (result i32)
    i32.const 136
    i32.const 144
    global.get 10
    call 8
    call_indirect (type 2))
  (func (;32;) (type 1) (result i32)
    i32.const 152
    i32.const 188
    global.get 10
    call 8
    call_indirect (type 2))
  (func (;33;) (type 1) (result i32)
    i32.const 224
    i32.const 236
    global.get 10
    call 8
    call_indirect (type 2))
  (func (;34;) (type 1) (result i32)
    i32.const 248
    i32.const 260
    global.get 10
    call 8
    call_indirect (type 2))
  (func (;35;) (type 1) (result i32)
    i32.const 42
    call 1
    global.get 12
    global.get 10
    call 8
    call_indirect (type 2))
  (func (;36;) (type 1) (result i32)
    i32.const 276
    i32.const 284
    global.get 10
    call 8
    call_indirect (type 2))
  (func (;37;)
    i32.const 10
    call 6
    global.set 11
    i32.const 8
    global.set 12
    i32.const 11
    call 6
    global.set 13
    i32.const 12
    call 6
    global.set 14
    i32.const 13
    call 6
    global.set 15
    i32.const 14
    call 6
    global.set 16
    i32.const 15
    call 6
    global.set 17
    i32.const 16
    call 6
    global.set 18
    i32.const 17
    call 6
    global.set 19
    i32.const 18
    call 6
    global.set 20
    i32.const 19
    call 6
    global.set 21
    i32.const 20
    call 6
    global.set 22
    i32.const 21
    call 6
    global.set 23
    i32.const 22
    call 6
    global.set 24
    i32.const 30
    drop)
  (table (;0;) 23 funcref)
  (export "literal-string-is-string" (func 24))
  (export "literal-strings-as-values-are-strings" (func 27))
  (export "string-may-contain-special-characters" (func 28))
  (export "string=?-empty-literal-strings" (func 29))
  (export "string=?-one-char-equal-strings" (func 30))
  (export "string=?-one-char-nonequal-strings" (func 31))
  (export "string=?-literal-strings-with-equal-content" (func 32))
  (export "string=?-literal-strings-with-same-length-nonequal-content" (func 33))
  (export "string=?-literal-strings-with-different-length" (func 34))
  (export "string=?-expects-string-first-argument" (func 35))
  (export "string=?-expects-string-second-argument" (func 36))
  (start 37)
  (elem (;0;) (i32.const 0) func 9 10 11 12 13 14 15 16 19 23 24 25 26 27 28 29 30 31 32 33 34 35 36)
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
  (data (;18;) (i32.const 276) "\04\00\00\02symb")
  (data (;19;) (i32.const 284) "\04\00\00\01symb")
  (type (;3;) (func (param i32 i32 i32) (result i32)))
  (type (;4;) (func)))
