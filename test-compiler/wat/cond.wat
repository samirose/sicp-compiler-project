(module
  (type (;0;) (func (param i32) (result i32)))
  (type (;1;) (func (result i32)))
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
    (local i32)
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          local.tee 1
          local.get 1
          call 5
          br_if 2 (;@1;)
          drop
        end
      end
      i32.const 30
    end)
  (func (;25;) (type 0) (param i32) (result i32)
    (local i32)
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          local.tee 1
          local.get 1
          call 5
          br_if 2 (;@1;)
          drop
        end
      end
      i32.const 2
      call 1
    end)
  (func (;26;) (type 0) (param i32) (result i32)
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            call 2
            i32.const 1
            call 1
            i32.eq
            br_if 0 (;@4;)
            br 1 (;@3;)
          end
          local.get 0
          call 3
          i32.const 1
          i32.add
          call 1
          br 2 (;@1;)
        end
      end
      i32.const 30
    end)
  (func (;27;) (type 0) (param i32) (result i32)
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            call 2
            i32.const 10
            call 1
            i32.lt_s
            br_if 0 (;@4;)
            br 1 (;@3;)
          end
          local.get 0
          call 3
          i32.const 1
          i32.add
          call 1
          br 2 (;@1;)
        end
      end
      local.get 0
      call 3
      i32.const 1
      i32.sub
      call 1
    end)
  (func (;28;) (type 1) (result i32)
    block (result i32)  ;; label = @1
      block  ;; label = @2
      end
      i32.const 42
      call 1
    end)
  (func (;29;) (type 0) (param i32) (result i32)
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            call 2
            i32.const 10
            call 1
            i32.lt_s
            br_if 0 (;@4;)
            br 1 (;@3;)
          end
          block (result i32)  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  local.get 0
                  call 2
                  i32.const 0
                  call 1
                  i32.gt_s
                  br_if 0 (;@7;)
                  br 1 (;@6;)
                end
                local.get 0
                call 3
                i32.const 1
                i32.add
                call 1
                br 2 (;@4;)
              end
            end
            i32.const 0
            call 1
          end
          br 2 (;@1;)
        end
      end
      local.get 0
      call 3
      i32.const 1
      i32.sub
      call 1
    end)
  (func (;30;) (type 0) (param i32) (result i32)
    (local i32)
    i32.const 0
    call 1
    local.set 1
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            call 2
            i32.const 1
            call 1
            i32.gt_s
            br_if 0 (;@4;)
            br 1 (;@3;)
          end
          local.get 1
          call 3
          i32.const 2
          i32.add
          call 1
          local.set 1
          i32.const 30
          br 2 (;@1;)
        end
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            call 2
            i32.const 0
            call 1
            i32.gt_s
            br_if 0 (;@4;)
            br 1 (;@3;)
          end
          local.get 1
          call 3
          i32.const 1
          i32.add
          call 1
          local.set 1
          i32.const 30
          br 2 (;@1;)
        end
      end
      local.get 1
      call 3
      i32.const 3
      i32.add
      call 1
      local.set 1
      i32.const 30
    end
    drop
    local.get 1)
  (func (;31;) (type 0) (param i32) (result i32)
    (local i32)
    i32.const 0
    call 1
    local.set 1
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            call 2
            i32.const 1
            call 1
            i32.gt_s
            br_if 0 (;@4;)
            br 1 (;@3;)
          end
          local.get 1
          call 3
          i32.const 2
          i32.add
          call 1
          local.set 1
          local.get 1
          br 2 (;@1;)
        end
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            call 2
            i32.const 0
            call 1
            i32.gt_s
            br_if 0 (;@4;)
            br 1 (;@3;)
          end
          local.get 1
          call 3
          i32.const 1
          i32.add
          call 1
          local.set 1
          local.get 1
          br 2 (;@1;)
        end
      end
      local.get 1
      call 3
      i32.const 3
      i32.add
      call 1
      local.set 1
      local.get 1
    end)
  (func (;32;) (type 0) (param i32) (result i32)
    local.get 0
    call 3
    i32.const 2
    i32.add
    call 1)
  (func (;33;) (type 0) (param i32) (result i32)
    local.get 0
    call 3
    i32.const 1
    i32.add
    call 1)
  (func (;34;) (type 0) (param i32) (result i32)
    local.get 0
    call 3
    i32.const 3
    i32.add
    call 1)
  (func (;35;) (type 0) (param i32) (result i32)
    local.get 0
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            call 2
            i32.const 1
            call 1
            i32.gt_s
            br_if 0 (;@4;)
            br 1 (;@3;)
          end
          i32.const 18
          call 6
          br 2 (;@1;)
        end
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            call 2
            i32.const 0
            call 1
            i32.gt_s
            br_if 0 (;@4;)
            br 1 (;@3;)
          end
          i32.const 19
          call 6
          br 2 (;@1;)
        end
      end
      i32.const 20
      call 6
    end
    call 8
    call_indirect (type 0))
  (func (;36;)
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
    i32.const 21
    call 6
    global.set 19
    i32.const 30
    drop)
  (table (;0;) 22 funcref)
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
  (export "single-exp" (func 24))
  (export "single-exp-else" (func 25))
  (export "test-and-exp" (func 26))
  (export "test-and-exp-else" (func 27))
  (export "only-else" (func 28))
  (export "nested" (func 29))
  (export "short-circuit" (func 30))
  (export "sequence-exps" (func 31))
  (export "lambda-exps" (func 35))
  (start 36)
  (elem (;0;) (i32.const 0) func 9 10 11 12 13 14 15 16 19 23 24 25 26 27 28 29 30 31 32 33 34 35)
  (data (;0;) (i32.const 0) "\00\01\00\00")
  (type (;2;) (func (param i32 i32) (result i32)))
  (type (;3;) (func (param i32 i32 i32) (result i32)))
  (type (;4;) (func)))
