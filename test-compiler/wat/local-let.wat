(module
  (type (;0;) (func (result i32)))
  (type (;1;) (func (param i32) (result i32)))
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
  (func (;24;) (type 0) (result i32)
    (local i32)
    i32.const 2
    call 1
    local.set 0
    i32.const 40
    local.get 0
    call 3
    i32.add
    call 1)
  (func (;25;) (type 0) (result i32)
    (local i32)
    i32.const 2
    i32.const 3
    i32.mul
    call 1
    local.set 0
    i32.const 5
    local.get 0
    call 3
    i32.mul
    call 1)
  (func (;26;) (type 0) (result i32)
    (local i32 i32)
    i32.const 2
    call 1
    local.set 0
    i32.const 3
    call 1
    local.set 1
    local.get 0
    call 3
    local.get 1
    call 3
    i32.mul
    call 1)
  (func (;27;) (type 0) (result i32)
    (local i32 i32)
    i32.const 2
    call 1
    local.set 0
    i32.const 3
    call 1
    local.set 1
    local.get 0
    call 3
    local.get 1
    call 3
    i32.mul
    call 1)
  (func (;28;) (type 0) (result i32)
    (local i32 i32)
    i32.const 2
    call 1
    local.set 0
    local.get 0
    call 3
    i32.const 1
    i32.add
    call 1
    local.set 1
    local.get 0
    call 3
    local.get 1
    call 3
    i32.mul
    call 1)
  (func (;29;) (type 0) (result i32)
    (local i32 i32 i32)
    i32.const 2
    call 1
    local.set 0
    i32.const 3
    call 1
    local.set 1
    i32.const 5
    call 1
    local.set 2
    local.get 0
    call 3
    local.get 2
    call 3
    i32.mul
    call 1)
  (func (;30;) (type 1) (param i32) (result i32)
    (local i32)
    i32.const 2
    call 1
    local.set 1
    local.get 1
    call 3
    local.get 0
    call 3
    i32.mul
    call 1)
  (func (;31;) (type 0) (result i32)
    i32.const 5
    call 1
    i32.const 16
    call_indirect (type 1))
  (func (;32;) (type 1) (param i32) (result i32)
    (local i32)
    local.get 0
    call 3
    i32.const 2
    i32.mul
    call 1
    local.set 1
    local.get 1
    call 3
    local.get 0
    call 3
    i32.mul
    call 1)
  (func (;33;) (type 0) (result i32)
    i32.const 3
    call 1
    i32.const 18
    call_indirect (type 1))
  (func (;34;) (type 1) (param i32) (result i32)
    (local i32)
    local.get 0
    call 3
    i32.const 2
    i32.mul
    call 1
    local.set 1
    local.get 1
    call 3
    local.get 1
    call 3
    i32.mul
    call 1)
  (func (;35;) (type 0) (result i32)
    i32.const 3
    call 1
    i32.const 20
    call_indirect (type 1))
  (func (;36;) (type 1) (param i32) (result i32)
    local.get 0
    call 3
    local.get 0
    call 3
    i32.add
    call 1)
  (func (;37;) (type 0) (result i32)
    (local i32 i32)
    i32.const 2
    i32.const 3
    i32.mul
    call 1
    local.set 0
    i32.const 22
    call 6
    local.set 1
    local.get 0
    local.get 1
    call 8
    call_indirect (type 1))
  (func (;38;) (type 0) (result i32)
    (local i32 i32 i32)
    i32.const 1
    call 1
    local.set 0
    i32.const 2
    call 1
    local.set 1
    i32.const 3
    call 1
    local.set 2
    local.get 1
    local.set 0
    local.get 2
    local.set 1
    local.get 2
    call 3
    i32.const 1
    i32.add
    call 1
    local.set 2
    local.get 0
    call 3
    local.get 1
    call 3
    i32.add
    local.get 2
    call 3
    i32.add
    call 1)
  (func (;39;) (type 0) (result i32)
    global.get 22)
  (func (;40;) (type 0) (result i32)
    global.get 24)
  (func (;41;)
    (local i32 i32 i32 i32 i32)
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
    i32.const 17
    call 6
    global.set 17
    i32.const 19
    call 6
    global.set 18
    i32.const 21
    call 6
    global.set 19
    i32.const 23
    call 6
    global.set 20
    i32.const 24
    call 6
    global.set 21
    i32.const 2
    call 1
    local.set 0
    i32.const 3
    call 1
    local.set 1
    local.get 0
    call 3
    local.get 1
    call 3
    i32.add
    call 1
    global.set 22
    i32.const 25
    call 6
    global.set 23
    i32.const 0
    call 1
    global.set 24
    i32.const 26
    call 6
    global.set 25
    i32.const 2
    call 1
    local.set 0
    i32.const 3
    call 1
    local.set 1
    i32.const 4
    call 1
    local.set 2
    local.get 0
    call 3
    local.get 1
    call 3
    i32.add
    local.get 2
    call 3
    i32.add
    call 1
    global.set 24
    i32.const 30
    drop)
  (table (;0;) 27 funcref)
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
  (export "constant-let" (func 24))
  (export "expression-let" (func 25))
  (export "multi-variable-let" (func 26))
  (export "nested-let" (func 27))
  (export "nested-let-referring-outer-let" (func 28))
  (export "let-shadowing-let" (func 29))
  (export "let-in-lambda" (func 31))
  (export "let-value-referring-lambda-arg" (func 33))
  (export "let-value-shadowing-lambda-arg" (func 35))
  (export "lambda-as-let-value" (func 37))
  (export "mutate-locals" (func 38))
  (export "get-global-with-let-value" (func 39))
  (export "get-global-assigned-with-let-value" (func 40))
  (start 41)
  (elem (;0;) (i32.const 0) func 9 10 11 12 13 14 15 16 19 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40)
  (data (;0;) (i32.const 0) "\00\01\00\00")
  (type (;2;) (func (param i32 i32) (result i32)))
  (type (;3;) (func (param i32 i32 i32) (result i32)))
  (type (;4;) (func)))
