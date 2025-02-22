(module
  (type (;0;) (func (param i32 i32) (result i32)))
  (type (;1;) (func (param i32) (result i32)))
  (type (;2;) (func (result i32)))
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
  (func (;24;) (type 0) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    global.get 8
    call 8
    call_indirect (type 0))
  (func (;25;) (type 1) (param i32) (result i32)
    local.get 0
    call 3
    local.get 0
    call 3
    i32.mul
    call 1)
  (func (;26;) (type 1) (param i32) (result i32)
    local.get 0
    call 3
    local.get 0
    call 3
    i32.add
    call 1)
  (func (;27;) (type 1) (param i32) (result i32)
    local.get 0)
  (func (;28;) (type 2) (result i32)
    (local i32 i32)
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          global.get 12
          global.get 12
          global.get 8
          call 8
          call_indirect (type 0)
          call 5
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 13
          call 6
          local.set 1
          local.get 1
          local.get 1
          global.get 8
          call 8
          call_indirect (type 0)
          local.tee 0
          call 5
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        local.get 0
        br 1 (;@1;)
      end
      i32.const 6
    end)
  (func (;29;) (type 2) (result i32)
    global.get 12
    global.get 13
    global.get 8
    call 8
    call_indirect (type 0))
  (func (;30;) (type 1) (param i32) (result i32)
    local.get 0
    call 3
    local.get 0
    call 3
    i32.mul
    call 1)
  (func (;31;) (type 2) (result i32)
    global.get 12
    i32.const 16
    call 6
    global.get 8
    call 8
    call_indirect (type 0))
  (func (;32;) (type 1) (param i32) (result i32)
    local.get 0
    call 3
    i32.const 1
    i32.add
    call 1)
  (func (;33;) (type 1) (param i32) (result i32)
    local.get 0
    call 3
    i32.const 2
    i32.add
    call 1)
  (func (;34;) (type 2) (result i32)
    i32.const 18
    call 6
    i32.const 19
    call 6
    global.get 8
    call 8
    call_indirect (type 0))
  (func (;35;) (type 1) (param i32) (result i32)
    local.get 0
    call 3
    local.get 0
    call 3
    i32.mul
    call 1)
  (func (;36;) (type 1) (param i32) (result i32)
    local.get 0
    call 3
    local.get 0
    call 3
    i32.mul
    call 1)
  (func (;37;) (type 2) (result i32)
    i32.const 21
    call 6
    i32.const 22
    call 6
    global.get 8
    call 8
    call_indirect (type 0)
    global.get 3
    call 8
    call_indirect (type 1))
  (func (;38;) (type 1) (param i32) (result i32)
    local.get 0)
  (func (;39;) (type 1) (param i32) (result i32)
    local.get 0
    call 3
    i32.const 1
    i32.add
    call 1)
  (func (;40;) (type 1) (param i32) (result i32)
    (local i32)
    block  ;; label = @1
      block  ;; label = @2
        global.get 12
        local.get 0
        global.get 8
        call 8
        call_indirect (type 0)
        local.tee 1
        call 5
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        local.get 0
        global.get 12
        global.get 8
        call 8
        call_indirect (type 0)
        local.tee 1
        call 5
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        i32.const 24
        call 6
        local.get 0
        global.get 8
        call 8
        call_indirect (type 0)
        local.tee 1
        call 5
        br_if 1 (;@1;)
      end
      local.get 0
      i32.const 25
      call 6
      global.get 8
      call 8
      call_indirect (type 0)
      local.set 1
    end
    local.get 1)
  (func (;41;) (type 2) (result i32)
    i32.const 264
    i32.const 264
    global.get 8
    call 8
    call_indirect (type 0))
  (func (;42;) (type 2) (result i32)
    (local i32)
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          global.get 20
          i32.const 256
          global.get 8
          call 8
          call_indirect (type 0)
          call 5
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 256
          global.get 20
          global.get 8
          call 8
          call_indirect (type 0)
          local.tee 0
          call 5
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        local.get 0
        br 1 (;@1;)
      end
      i32.const 6
    end)
  (func (;43;) (type 2) (result i32)
    global.get 20
    global.get 20
    global.get 8
    call 8
    call_indirect (type 0))
  (func (;44;) (type 1) (param i32) (result i32)
    (local i32)
    block  ;; label = @1
      block  ;; label = @2
        i32.const 256
        local.get 0
        global.get 8
        call 8
        call_indirect (type 0)
        local.tee 1
        call 5
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        global.get 20
        local.get 0
        global.get 8
        call 8
        call_indirect (type 0)
        local.tee 1
        call 5
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        local.get 0
        i32.const 256
        global.get 8
        call 8
        call_indirect (type 0)
        local.tee 1
        call 5
        br_if 1 (;@1;)
      end
      local.get 0
      global.get 20
      global.get 8
      call 8
      call_indirect (type 0)
      local.set 1
    end
    local.get 1)
  (func (;45;) (type 1) (param i32) (result i32)
    local.get 0)
  (func (;46;) (type 1) (param i32) (result i32)
    local.get 0
    call 3
    i32.const 1
    i32.add
    call 1)
  (func (;47;) (type 2) (result i32)
    (local i32)
    block  ;; label = @1
      block  ;; label = @2
        i32.const 256
        global.get 12
        global.get 8
        call 8
        call_indirect (type 0)
        local.tee 0
        call 5
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        global.get 20
        global.get 12
        global.get 8
        call 8
        call_indirect (type 0)
        local.tee 0
        call 5
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        global.get 12
        i32.const 256
        global.get 8
        call 8
        call_indirect (type 0)
        local.tee 0
        call 5
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        global.get 12
        global.get 20
        global.get 8
        call 8
        call_indirect (type 0)
        local.tee 0
        call 5
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        i32.const 256
        i32.const 31
        call 6
        global.get 8
        call 8
        call_indirect (type 0)
        local.tee 0
        call 5
        br_if 1 (;@1;)
      end
      i32.const 32
      call 6
      global.get 20
      global.get 8
      call 8
      call_indirect (type 0)
      local.set 0
    end
    local.get 0)
  (func (;48;) (type 2) (result i32)
    (local i32 i32 i32)
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          i32.const 272
          local.set 0
          local.get 0
          local.get 0
          global.get 8
          call 8
          call_indirect (type 0)
          call 5
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 276
          local.set 1
          local.get 1
          local.get 1
          global.get 8
          call 8
          call_indirect (type 0)
          local.tee 0
          call 5
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        local.get 0
        br 1 (;@1;)
      end
      i32.const 6
    end)
  (func (;49;) (type 2) (result i32)
    (local i32)
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          i32.const 292
          i32.const 296
          global.get 8
          call 8
          call_indirect (type 0)
          global.get 3
          call 8
          call_indirect (type 1)
          call 5
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 300
          i32.const 316
          global.get 8
          call 8
          call_indirect (type 0)
          global.get 3
          call 8
          call_indirect (type 1)
          call 5
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 332
          i32.const 340
          global.get 8
          call 8
          call_indirect (type 0)
          global.get 3
          call 8
          call_indirect (type 1)
          local.tee 0
          call 5
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        local.get 0
        br 1 (;@1;)
      end
      i32.const 6
    end)
  (func (;50;) (type 1) (param i32) (result i32)
    (local i32)
    block  ;; label = @1
      block  ;; label = @2
        i32.const 348
        local.get 0
        global.get 8
        call 8
        call_indirect (type 0)
        local.tee 1
        call 5
        br_if 1 (;@1;)
      end
      local.get 0
      i32.const 356
      global.get 8
      call 8
      call_indirect (type 0)
      local.set 1
    end
    local.get 1)
  (func (;51;) (type 1) (param i32) (result i32)
    local.get 0)
  (func (;52;) (type 1) (param i32) (result i32)
    local.get 0
    call 3
    i32.const 1
    i32.add
    call 1)
  (func (;53;) (type 2) (result i32)
    (local i32)
    block  ;; label = @1
      block  ;; label = @2
        i32.const 360
        global.get 12
        global.get 8
        call 8
        call_indirect (type 0)
        local.tee 0
        call 5
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        global.get 12
        i32.const 368
        global.get 8
        call 8
        call_indirect (type 0)
        local.tee 0
        call 5
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        i32.const 372
        i32.const 37
        call 6
        global.get 8
        call 8
        call_indirect (type 0)
        local.tee 0
        call 5
        br_if 1 (;@1;)
      end
      i32.const 38
      call 6
      i32.const 384
      global.get 8
      call 8
      call_indirect (type 0)
      local.set 0
    end
    local.get 0)
  (func (;54;) (type 2) (result i32)
    (local i32)
    block  ;; label = @1
      block  ;; label = @2
        i32.const 396
        i32.const 256
        global.get 8
        call 8
        call_indirect (type 0)
        local.tee 0
        call 5
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        i32.const 256
        i32.const 404
        global.get 8
        call 8
        call_indirect (type 0)
        local.tee 0
        call 5
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        i32.const 412
        global.get 20
        global.get 8
        call 8
        call_indirect (type 0)
        local.tee 0
        call 5
        br_if 1 (;@1;)
      end
      global.get 20
      i32.const 416
      global.get 8
      call 8
      call_indirect (type 0)
      local.set 0
    end
    local.get 0)
  (func (;55;)
    i32.const 10
    call 6
    global.set 11
    i32.const 11
    call 6
    global.set 12
    i32.const 12
    call 6
    global.set 13
    i32.const 14
    call 6
    global.set 14
    i32.const 15
    call 6
    global.set 15
    i32.const 17
    call 6
    global.set 16
    i32.const 20
    call 6
    global.set 17
    i32.const 23
    call 6
    global.set 18
    i32.const 26
    call 6
    global.set 19
    i32.const 256
    global.set 20
    i32.const 27
    call 6
    global.set 21
    i32.const 28
    call 6
    global.set 22
    i32.const 29
    call 6
    global.set 23
    i32.const 30
    call 6
    global.set 24
    i32.const 33
    call 6
    global.set 25
    i32.const 34
    call 6
    global.set 26
    i32.const 35
    call 6
    global.set 27
    i32.const 36
    call 6
    global.set 28
    i32.const 39
    call 6
    global.set 29
    i32.const 40
    call 6
    global.set 30
    i32.const 30
    drop)
  (table (;0;) 41 funcref)
  (memory (;0;) 10)
  (export "memory" (memory 0))
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
  (global (;25;) (mut i32) (i32.const 46))
  (global (;26;) (mut i32) (i32.const 46))
  (global (;27;) (mut i32) (i32.const 46))
  (global (;28;) (mut i32) (i32.const 46))
  (global (;29;) (mut i32) (i32.const 46))
  (global (;30;) (mut i32) (i32.const 46))
  (export "eqv-literals" (func 24))
  (export "eqv-proc-reference-to-same-proc-reference" (func 28))
  (export "eqv-proc-reference-to-different-proc-reference" (func 29))
  (export "eqv-proc-reference-to-lambda" (func 31))
  (export "eqv-lambda-to-lambda-with-different-form" (func 34))
  (export "eqv-lambda-to-lambda-with-same-form-is-boolean" (func 37))
  (export "eqv-procedure-to-literal" (func 40))
  (export "eqv-symbol-literal-with-same-symbol-literal" (func 41))
  (export "eqv-symbol-reference-with-same-symbol-literal" (func 42))
  (export "eqv-symbol-reference-with-same-reference" (func 43))
  (export "eqv-symbol-to-literal" (func 44))
  (export "eqv-symbol-to-procedure" (func 47))
  (export "eqv-string-to-same-string-location" (func 48))
  (export "eqv-string-to-string-literal-is-boolean" (func 49))
  (export "eqv-string-to-literal" (func 50))
  (export "eqv-string-to-procedure" (func 53))
  (export "eqv-string-to-symbol" (func 54))
  (start 55)
  (elem (;0;) (i32.const 0) func 9 10 11 12 13 14 15 16 19 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54)
  (data (;0;) (i32.const 0) "\a8\01\00\00")
  (data (;1;) (i32.const 256) "\04\00\00\01symb")
  (data (;2;) (i32.const 264) "\03\00\00\01foo")
  (data (;3;) (i32.const 272) "\00\00\00\02")
  (data (;4;) (i32.const 276) "\0b\00\00\02foobarxyzzy")
  (data (;5;) (i32.const 292) "\00\00\00\02")
  (data (;6;) (i32.const 296) "\00\00\00\02")
  (data (;7;) (i32.const 300) "\0a\00\00\02foobar1234")
  (data (;8;) (i32.const 316) "\0a\00\00\02foobar1234")
  (data (;9;) (i32.const 332) "\01\00\00\02x")
  (data (;10;) (i32.const 340) "\01\00\00\02y")
  (data (;11;) (i32.const 348) "\03\00\00\02foo")
  (data (;12;) (i32.const 356) "\00\00\00\02")
  (data (;13;) (i32.const 360) "\04\00\00\02proc")
  (data (;14;) (i32.const 368) "\00\00\00\02")
  (data (;15;) (i32.const 372) "\06\00\00\02lambda")
  (data (;16;) (i32.const 384) "\06\00\00\02lambda")
  (data (;17;) (i32.const 396) "\04\00\00\02symb")
  (data (;18;) (i32.const 404) "\04\00\00\02symb")
  (data (;19;) (i32.const 412) "\00\00\00\02")
  (data (;20;) (i32.const 416) "\03\00\00\02foo")
  (type (;3;) (func (param i32 i32 i32) (result i32)))
  (type (;4;) (func)))
