(module
  (type (;0;) (func (param i32) (result i32)))
  (type (;1;) (func (param i32 i32) (result i32)))
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
  (func (;24;) (type 0) (param i32) (result i32)
    local.get 0
    global.get 1
    call 8
    call_indirect (type 0))
  (func (;25;) (type 0) (param i32) (result i32)
    local.get 0
    global.get 2
    call 8
    call_indirect (type 0))
  (func (;26;) (type 1) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    global.get 7
    call 8
    call_indirect (type 1))
  (func (;27;) (type 2) (result i32)
    i32.const 1
    i32.const 2
    i32.add
    call 1
    global.get 1
    call 8
    call_indirect (type 0))
  (func (;28;) (type 0) (param i32) (result i32)
    local.get 0
    global.get 3
    call 8
    call_indirect (type 0))
  (func (;29;) (type 2) (result i32)
    (local i32)
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          i32.const 1
          call 1
          i32.const 1
          call 1
          global.get 7
          call 8
          call_indirect (type 1)
          global.get 3
          call 8
          call_indirect (type 0)
          call 5
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 1
          call 1
          i32.const 2
          call 1
          global.get 7
          call 8
          call_indirect (type 1)
          global.get 3
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
  (func (;30;) (type 2) (result i32)
    (local i32)
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          i32.const 1
          call 1
          i32.const 2
          call 1
          i32.lt_s
          call 4
          global.get 3
          call 8
          call_indirect (type 0)
          call 5
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 2
          call 1
          i32.const 1
          call 1
          i32.lt_s
          call 4
          global.get 3
          call 8
          call_indirect (type 0)
          call 5
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 1
          call 1
          i32.const 2
          call 1
          i32.le_s
          call 4
          global.get 3
          call 8
          call_indirect (type 0)
          call 5
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 2
          call 1
          i32.const 1
          call 1
          i32.le_s
          call 4
          global.get 3
          call 8
          call_indirect (type 0)
          call 5
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 1
          call 1
          i32.const 1
          call 1
          i32.eq
          call 4
          global.get 3
          call 8
          call_indirect (type 0)
          call 5
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 2
          call 1
          i32.const 1
          call 1
          i32.gt_s
          call 4
          global.get 3
          call 8
          call_indirect (type 0)
          call 5
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 1
          call 1
          i32.const 2
          call 1
          i32.gt_s
          call 4
          global.get 3
          call 8
          call_indirect (type 0)
          call 5
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 2
          call 1
          i32.const 1
          call 1
          i32.ge_s
          call 4
          global.get 3
          call 8
          call_indirect (type 0)
          call 5
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 1
          call 1
          i32.const 2
          call 1
          i32.ge_s
          call 4
          global.get 3
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
  (func (;31;) (type 0) (param i32) (result i32)
    local.get 0
    global.get 4
    call 8
    call_indirect (type 0))
  (func (;32;) (type 0) (param i32) (result i32)
    local.get 0
    call 3
    local.get 0
    call 3
    i32.add
    call 1)
  (func (;33;) (type 2) (result i32)
    i32.const 18
    call 6
    global.get 4
    call 8
    call_indirect (type 0))
  (func (;34;) (type 2) (result i32)
    global.get 19
    global.get 4
    call 8
    call_indirect (type 0))
  (func (;35;) (type 2) (result i32)
    global.get 1
    global.get 4
    call 8
    call_indirect (type 0))
  (func (;36;) (type 0) (param i32) (result i32)
    local.get 0
    call 3
    local.get 0
    call 3
    i32.mul
    call 1)
  (func (;37;) (type 2) (result i32)
    (local i32)
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          i32.const 22
          call 6
          global.get 18
          call 8
          call_indirect (type 0)
          call 5
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          global.get 11
          global.get 18
          call 8
          call_indirect (type 0)
          call 5
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          global.get 2
          global.get 18
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
  (func (;38;) (type 0) (param i32) (result i32)
    local.get 0
    call 3
    local.get 0
    call 3
    i32.add
    call 1)
  (func (;39;) (type 2) (result i32)
    i32.const 24
    call 6)
  (func (;40;) (type 2) (result i32)
    global.get 23
    call 8
    call_indirect (type 2)
    global.get 4
    call 8
    call_indirect (type 0))
  (func (;41;) (type 2) (result i32)
    global.get 1
    global.get 1
    global.get 7
    call 8
    call_indirect (type 1))
  (func (;42;) (type 2) (result i32)
    (local i32)
    block  ;; label = @1
      block  ;; label = @2
        global.get 1
        global.get 2
        global.get 7
        call 8
        call_indirect (type 1)
        local.tee 0
        call 5
        br_if 1 (;@1;)
      end
      global.get 2
      global.get 1
      global.get 7
      call 8
      call_indirect (type 1)
      local.set 0
    end
    local.get 0)
  (func (;43;) (type 0) (param i32) (result i32)
    global.get 1
    local.get 0
    global.get 7
    call 8
    call_indirect (type 1))
  (func (;44;) (type 2) (result i32)
    i32.const 256
    global.get 5
    call 8
    call_indirect (type 0))
  (func (;45;) (type 0) (param i32) (result i32)
    local.get 0
    global.get 5
    call 8
    call_indirect (type 0))
  (func (;46;) (type 2) (result i32)
    global.get 23
    global.get 5
    call 8
    call_indirect (type 0))
  (func (;47;) (type 2) (result i32)
    i32.const 264
    global.get 5
    call 8
    call_indirect (type 0))
  (func (;48;) (type 2) (result i32)
    i32.const 272
    global.get 6
    call 8
    call_indirect (type 0))
  (func (;49;) (type 0) (param i32) (result i32)
    local.get 0
    global.get 6
    call 8
    call_indirect (type 0))
  (func (;50;) (type 2) (result i32)
    global.get 23
    global.get 6
    call 8
    call_indirect (type 0))
  (func (;51;) (type 2) (result i32)
    i32.const 280
    global.get 6
    call 8
    call_indirect (type 0))
  (func (;52;)
    i32.const 10
    call 6
    global.set 11
    i32.const 11
    call 6
    global.set 12
    i32.const 12
    call 6
    global.set 13
    i32.const 13
    call 6
    global.set 14
    i32.const 14
    call 6
    global.set 15
    i32.const 15
    call 6
    global.set 16
    i32.const 16
    call 6
    global.set 17
    i32.const 17
    call 6
    global.set 18
    i32.const 19
    call 6
    global.set 19
    i32.const 20
    call 6
    global.set 20
    i32.const 21
    call 6
    global.set 21
    i32.const 23
    call 6
    global.set 22
    i32.const 25
    call 6
    global.set 23
    i32.const 26
    call 6
    global.set 24
    i32.const 27
    call 6
    global.set 25
    i32.const 28
    call 6
    global.set 26
    i32.const 29
    call 6
    global.set 27
    i32.const 30
    call 6
    global.set 28
    i32.const 31
    call 6
    global.set 29
    i32.const 32
    call 6
    global.set 30
    i32.const 33
    call 6
    global.set 31
    i32.const 34
    call 6
    global.set 32
    i32.const 35
    call 6
    global.set 33
    i32.const 36
    call 6
    global.set 34
    i32.const 37
    call 6
    global.set 35
    i32.const 30
    drop)
  (table (;0;) 38 funcref)
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
  (global (;31;) (mut i32) (i32.const 46))
  (global (;32;) (mut i32) (i32.const 46))
  (global (;33;) (mut i32) (i32.const 46))
  (global (;34;) (mut i32) (i32.const 46))
  (global (;35;) (mut i32) (i32.const 46))
  (export "is-number?" (func 24))
  (export "is-zero?" (func 25))
  (export "is-eq?" (func 26))
  (export "numeric-exp-is-number?" (func 27))
  (export "is-boolean?" (func 28))
  (export "eq?-evaluates-to-boolean-value" (func 29))
  (export "arithmetic-comparison-operators-evaluate-to-boolean-values" (func 30))
  (export "is-procedure?" (func 31))
  (export "lambda-is-procedure?" (func 33))
  (export "defined-procedure-is-procedure?" (func 34))
  (export "imported-procedure-is-procedure?" (func 35))
  (export "procedure-argument-is-procedure?" (func 37))
  (export "procedure-from-procedure-is-procedure?" (func 40))
  (export "is-procedure-eq-to-same-procedure?" (func 41))
  (export "is-procedure-eq-to-different-procedure?" (func 42))
  (export "is-procedure-number?-eq-to" (func 43))
  (export "symbol-is-symbol?" (func 44))
  (export "is-symbol?" (func 45))
  (export "procedure-is-symbol?" (func 46))
  (export "string-is-symbol?" (func 47))
  (export "string-is-string?" (func 48))
  (export "is-string?" (func 49))
  (export "procedure-is-string?" (func 50))
  (export "symbol-is-string?" (func 51))
  (start 52)
  (elem (;0;) (i32.const 0) func 9 10 11 12 13 14 15 16 19 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51)
  (data (;0;) (i32.const 0) " \01\00\00")
  (data (;1;) (i32.const 256) "\03\00\00\01sym")
  (data (;2;) (i32.const 264) "\03\00\00\02bar")
  (data (;3;) (i32.const 272) "\03\00\00\02foo")
  (data (;4;) (i32.const 280) "\04\00\00\01test")
  (type (;3;) (func (param i32 i32 i32) (result i32)))
  (type (;4;) (func)))
