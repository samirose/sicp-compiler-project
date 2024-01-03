(module
  (type (;0;) (func (param i32 i32) (result i32)))
  (type (;1;) (func (param i32) (result i32)))
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
  (import "scheme base" "string?" (func (;13;) (param i32) (result i32)))
  (import "scheme base" "symbol=?" (func (;14;) (param i32 i32) (result i32)))
  (import "scheme base" "string=?" (func (;15;) (param i32 i32) (result i32)))
  (import "scheme base" "eq?" (func (;16;) (param i32 i32) (result i32)))
  (import "scheme base" "eq?" (func (;17;) (param i32 i32) (result i32)))
  (global (;0;) i32 (i32.const 2))
  (global (;1;) i32 (i32.const 18))
  (global (;2;) i32 (i32.const 34))
  (global (;3;) i32 (i32.const 50))
  (global (;4;) i32 (i32.const 66))
  (global (;5;) i32 (i32.const 82))
  (global (;6;) i32 (i32.const 98))
  (global (;7;) i32 (i32.const 114))
  (global (;8;) i32 (i32.const 130))
  (global (;9;) i32 (i32.const 146))
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
  (global (;26;) (mut i32) (i32.const 46))
  (global (;27;) (mut i32) (i32.const 46))
  (global (;28;) (mut i32) (i32.const 46))
  (global (;29;) (mut i32) (i32.const 46))
  (func (;18;) (type 0) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    global.get 9
    call 9
    call_indirect (type 0))
  (func (;19;) (type 1) (param i32) (result i32)
    local.get 0
    call 3
    local.get 0
    call 3
    i32.mul
    call 1)
  (func (;20;) (type 1) (param i32) (result i32)
    local.get 0
    call 3
    local.get 0
    call 3
    i32.add
    call 1)
  (func (;21;) (type 1) (param i32) (result i32)
    local.get 0)
  (func (;22;) (type 2) (result i32)
    (local i32 i32)
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          global.get 11
          global.get 11
          global.get 9
          call 9
          call_indirect (type 0)
          call 7
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 13
          call 8
          local.set 1
          local.get 1
          local.get 1
          global.get 9
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
  (func (;23;) (type 2) (result i32)
    global.get 11
    global.get 12
    global.get 9
    call 9
    call_indirect (type 0))
  (func (;24;) (type 1) (param i32) (result i32)
    local.get 0
    call 3
    local.get 0
    call 3
    i32.mul
    call 1)
  (func (;25;) (type 2) (result i32)
    global.get 11
    i32.const 16
    call 8
    global.get 9
    call 9
    call_indirect (type 0))
  (func (;26;) (type 1) (param i32) (result i32)
    local.get 0
    call 3
    i32.const 1
    i32.add
    call 1)
  (func (;27;) (type 1) (param i32) (result i32)
    local.get 0
    call 3
    i32.const 2
    i32.add
    call 1)
  (func (;28;) (type 2) (result i32)
    i32.const 18
    call 8
    i32.const 19
    call 8
    global.get 9
    call 9
    call_indirect (type 0))
  (func (;29;) (type 1) (param i32) (result i32)
    local.get 0
    call 3
    local.get 0
    call 3
    i32.mul
    call 1)
  (func (;30;) (type 1) (param i32) (result i32)
    local.get 0
    call 3
    local.get 0
    call 3
    i32.mul
    call 1)
  (func (;31;) (type 2) (result i32)
    i32.const 21
    call 8
    i32.const 22
    call 8
    global.get 9
    call 9
    call_indirect (type 0)
    global.get 2
    call 9
    call_indirect (type 1))
  (func (;32;) (type 1) (param i32) (result i32)
    local.get 0)
  (func (;33;) (type 1) (param i32) (result i32)
    local.get 0
    call 3
    i32.const 1
    i32.add
    call 1)
  (func (;34;) (type 1) (param i32) (result i32)
    (local i32)
    block  ;; label = @1
      block  ;; label = @2
        global.get 11
        local.get 0
        global.get 9
        call 9
        call_indirect (type 0)
        local.tee 1
        call 7
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        local.get 0
        global.get 11
        global.get 9
        call 9
        call_indirect (type 0)
        local.tee 1
        call 7
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        i32.const 24
        call 8
        local.get 0
        global.get 9
        call 9
        call_indirect (type 0)
        local.tee 1
        call 7
        br_if 1 (;@1;)
      end
      local.get 0
      i32.const 25
      call 8
      global.get 9
      call 9
      call_indirect (type 0)
      local.set 1
    end
    local.get 1)
  (func (;35;) (type 2) (result i32)
    i32.const 8
    i32.const 8
    global.get 9
    call 9
    call_indirect (type 0))
  (func (;36;) (type 2) (result i32)
    (local i32)
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          global.get 19
          i32.const 0
          global.get 9
          call 9
          call_indirect (type 0)
          call 7
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 0
          global.get 19
          global.get 9
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
  (func (;37;) (type 2) (result i32)
    global.get 19
    global.get 19
    global.get 9
    call 9
    call_indirect (type 0))
  (func (;38;) (type 1) (param i32) (result i32)
    (local i32)
    block  ;; label = @1
      block  ;; label = @2
        i32.const 0
        local.get 0
        global.get 9
        call 9
        call_indirect (type 0)
        local.tee 1
        call 7
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        global.get 19
        local.get 0
        global.get 9
        call 9
        call_indirect (type 0)
        local.tee 1
        call 7
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        local.get 0
        i32.const 0
        global.get 9
        call 9
        call_indirect (type 0)
        local.tee 1
        call 7
        br_if 1 (;@1;)
      end
      local.get 0
      global.get 19
      global.get 9
      call 9
      call_indirect (type 0)
      local.set 1
    end
    local.get 1)
  (func (;39;) (type 1) (param i32) (result i32)
    local.get 0)
  (func (;40;) (type 1) (param i32) (result i32)
    local.get 0
    call 3
    i32.const 1
    i32.add
    call 1)
  (func (;41;) (type 2) (result i32)
    (local i32)
    block  ;; label = @1
      block  ;; label = @2
        i32.const 0
        global.get 11
        global.get 9
        call 9
        call_indirect (type 0)
        local.tee 0
        call 7
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        global.get 19
        global.get 11
        global.get 9
        call 9
        call_indirect (type 0)
        local.tee 0
        call 7
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        global.get 11
        i32.const 0
        global.get 9
        call 9
        call_indirect (type 0)
        local.tee 0
        call 7
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        global.get 11
        global.get 19
        global.get 9
        call 9
        call_indirect (type 0)
        local.tee 0
        call 7
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        i32.const 0
        i32.const 31
        call 8
        global.get 9
        call 9
        call_indirect (type 0)
        local.tee 0
        call 7
        br_if 1 (;@1;)
      end
      i32.const 32
      call 8
      global.get 19
      global.get 9
      call 9
      call_indirect (type 0)
      local.set 0
    end
    local.get 0)
  (func (;42;) (type 2) (result i32)
    (local i32 i32 i32)
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          i32.const 16
          local.set 0
          local.get 0
          local.get 0
          global.get 9
          call 9
          call_indirect (type 0)
          call 7
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 20
          local.set 1
          local.get 1
          local.get 1
          global.get 9
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
  (func (;43;) (type 2) (result i32)
    (local i32)
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          i32.const 36
          i32.const 40
          global.get 9
          call 9
          call_indirect (type 0)
          global.get 2
          call 9
          call_indirect (type 1)
          call 7
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 44
          i32.const 60
          global.get 9
          call 9
          call_indirect (type 0)
          global.get 2
          call 9
          call_indirect (type 1)
          call 7
          br_if 0 (;@3;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          i32.const 76
          i32.const 84
          global.get 9
          call 9
          call_indirect (type 0)
          global.get 2
          call 9
          call_indirect (type 1)
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
  (func (;44;) (type 1) (param i32) (result i32)
    (local i32)
    block  ;; label = @1
      block  ;; label = @2
        i32.const 92
        local.get 0
        global.get 9
        call 9
        call_indirect (type 0)
        local.tee 1
        call 7
        br_if 1 (;@1;)
      end
      local.get 0
      i32.const 100
      global.get 9
      call 9
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
        i32.const 104
        global.get 11
        global.get 9
        call 9
        call_indirect (type 0)
        local.tee 0
        call 7
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        global.get 11
        i32.const 112
        global.get 9
        call 9
        call_indirect (type 0)
        local.tee 0
        call 7
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        i32.const 116
        i32.const 37
        call 8
        global.get 9
        call 9
        call_indirect (type 0)
        local.tee 0
        call 7
        br_if 1 (;@1;)
      end
      i32.const 38
      call 8
      i32.const 128
      global.get 9
      call 9
      call_indirect (type 0)
      local.set 0
    end
    local.get 0)
  (func (;48;) (type 2) (result i32)
    (local i32)
    block  ;; label = @1
      block  ;; label = @2
        i32.const 140
        i32.const 0
        global.get 9
        call 9
        call_indirect (type 0)
        local.tee 0
        call 7
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        i32.const 0
        i32.const 148
        global.get 9
        call 9
        call_indirect (type 0)
        local.tee 0
        call 7
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        i32.const 156
        global.get 19
        global.get 9
        call 9
        call_indirect (type 0)
        local.tee 0
        call 7
        br_if 1 (;@1;)
      end
      global.get 19
      i32.const 160
      global.get 9
      call 9
      call_indirect (type 0)
      local.set 0
    end
    local.get 0)
  (func (;49;)
    i32.const 10
    call 8
    global.set 10
    i32.const 11
    call 8
    global.set 11
    i32.const 12
    call 8
    global.set 12
    i32.const 14
    call 8
    global.set 13
    i32.const 15
    call 8
    global.set 14
    i32.const 17
    call 8
    global.set 15
    i32.const 20
    call 8
    global.set 16
    i32.const 23
    call 8
    global.set 17
    i32.const 26
    call 8
    global.set 18
    i32.const 0
    global.set 19
    i32.const 27
    call 8
    global.set 20
    i32.const 28
    call 8
    global.set 21
    i32.const 29
    call 8
    global.set 22
    i32.const 30
    call 8
    global.set 23
    i32.const 33
    call 8
    global.set 24
    i32.const 34
    call 8
    global.set 25
    i32.const 35
    call 8
    global.set 26
    i32.const 36
    call 8
    global.set 27
    i32.const 39
    call 8
    global.set 28
    i32.const 40
    call 8
    global.set 29
    i32.const 30
    drop)
  (table (;0;) 41 funcref)
  (export "eqv-literals" (func 18))
  (export "eqv-proc-reference-to-same-proc-reference" (func 22))
  (export "eqv-proc-reference-to-different-proc-reference" (func 23))
  (export "eqv-proc-reference-to-lambda" (func 25))
  (export "eqv-lambda-to-lambda-with-different-form" (func 28))
  (export "eqv-lambda-to-lambda-with-same-form-is-boolean" (func 31))
  (export "eqv-procedure-to-literal" (func 34))
  (export "eqv-symbol-literal-with-same-symbol-literal" (func 35))
  (export "eqv-symbol-reference-with-same-symbol-literal" (func 36))
  (export "eqv-symbol-reference-with-same-reference" (func 37))
  (export "eqv-symbol-to-literal" (func 38))
  (export "eqv-symbol-to-procedure" (func 41))
  (export "eqv-string-to-same-string-location" (func 42))
  (export "eqv-string-to-string-literal-is-boolean" (func 43))
  (export "eqv-string-to-literal" (func 44))
  (export "eqv-string-to-procedure" (func 47))
  (export "eqv-string-to-symbol" (func 48))
  (start 49)
  (elem (;0;) (i32.const 0) func 4 5 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48)
  (data (;0;) (i32.const 0) "\04\00\00\01symb")
  (data (;1;) (i32.const 8) "\03\00\00\01foo")
  (data (;2;) (i32.const 16) "\00\00\00\02")
  (data (;3;) (i32.const 20) "\0b\00\00\02foobarxyzzy")
  (data (;4;) (i32.const 36) "\00\00\00\02")
  (data (;5;) (i32.const 40) "\00\00\00\02")
  (data (;6;) (i32.const 44) "\0a\00\00\02foobar1234")
  (data (;7;) (i32.const 60) "\0a\00\00\02foobar1234")
  (data (;8;) (i32.const 76) "\01\00\00\02x")
  (data (;9;) (i32.const 84) "\01\00\00\02y")
  (data (;10;) (i32.const 92) "\03\00\00\02foo")
  (data (;11;) (i32.const 100) "\00\00\00\02")
  (data (;12;) (i32.const 104) "\04\00\00\02proc")
  (data (;13;) (i32.const 112) "\00\00\00\02")
  (data (;14;) (i32.const 116) "\06\00\00\02lambda")
  (data (;15;) (i32.const 128) "\06\00\00\02lambda")
  (data (;16;) (i32.const 140) "\04\00\00\02symb")
  (data (;17;) (i32.const 148) "\04\00\00\02symb")
  (data (;18;) (i32.const 156) "\00\00\00\02")
  (data (;19;) (i32.const 160) "\03\00\00\02foo")
  (type (;3;) (func)))
