(import (scheme base))
(import (scheme write))
(import (values))

(define macro-is-not-heap-obj
  `(i32.const ,immediate-value-mask
    i32.and))

(define macro-is-heap-obj
  `(,@macro-is-not-heap-obj
    i32.eqz))

(define (macro-is-heap-obj-type heap-obj-type)
  `(i32.const ,heap-object-type-mask
    i32.and
    i32.const ,heap-obj-type
    i32.eq))

(define (macro-raise-error error)
  `(i32.const ,error
    global.set $error-code
    unreachable))

(define scheme-base-wat
  `(module
    $scheme-base

    (memory $heap (export "$heap") 1)

    (global $error-code (mut i32) (i32.const ,error-no-error))

    (func (export "get-error-code") (result i32)
          global.get $error-code
          i32.const ,error-no-error
          global.set $error-code)

    (func (export "i32->fixnum") (param $value i32) (result i32)
          local.get $value
          i32.const ,fixnum-shift
          i32.shl
          i32.const ,fixnum-mask
          i32.or)

    (func $check-fixnum (export "check-fixnum") (param $obj i32) (result i32)
          local.get $obj
          local.get $obj
          i32.const ,fixnum-mask
          i32.and
          i32.const ,fixnum-mask
          i32.ne
          if
          ,@(macro-raise-error error-expected-number)
          end)

    (func $fixnum->i32 (export "fixnum->i32") (param $obj i32) (result i32)
          local.get $obj
          call $check-fixnum
          i32.const ,fixnum-shift
          i32.shr_s)

    (func $i32->boolean  (export "i32->boolean") (param $value i32) (result i32)
          i32.const ,true-value
          i32.const ,false-value
          local.get $value
          select)

    (func (export "boolean->i32") (param $obj i32) (result i32)
          i32.const 0
          i32.const 1
          local.get $obj
          i32.const ,false-value
          i32.eq
          select)

    (func (export "funcidx->procedure") (param $funcidx i32) (result i32)
          local.get $funcidx
          i32.const ,immediate-shift
          i32.shl
          i32.const ,procedure-tag
          i32.or)

    (func $check-procedure (param $obj i32) (result i32)
          local.get $obj
          local.get $obj
          i32.const ,immediate-mask
          i32.and
          i32.const ,procedure-tag
          i32.ne
          if
          ,@(macro-raise-error error-expected-procedure)
          end)

    (func (export "procedure->funcidx") (param $obj i32) (result i32)
          local.get $obj
          call $check-procedure
          i32.const ,immediate-shift
          i32.shr_u)

    (func (export "boolean?") (param $obj i32) (result i32)
          local.get $obj
          i32.const ,immediate-mask
          i32.and
          i32.const ,boolean-tag
          i32.eq
          call $i32->boolean)

    (func (export "number?") (param $obj i32) (result i32)
          local.get $obj
          i32.const ,fixnum-mask
          i32.and
          call $i32->boolean)

    (func (export "zero?") (param $obj i32) (result i32)
          local.get $obj
          call $fixnum->i32
          i32.eqz
          call $i32->boolean)

    (func (export "procedure?") (param $obj i32) (result i32)
          local.get $obj
          i32.const ,immediate-mask
          i32.and
          i32.const ,procedure-tag
          i32.eq
          call $i32->boolean)

    (func (export "symbol?") (param $obj i32) (result i32)
          local.get $obj
          ,@macro-is-heap-obj
          if (result i32)
            local.get $obj
            i32.load
            ,@(macro-is-heap-obj-type heap-object-type-symbol)
            call $i32->boolean
          else
            i32.const ,false-value
          end)

    (func (export "string?") (param $obj i32) (result i32)
          local.get $obj
          ,@macro-is-heap-obj
          if (result i32)
            local.get $obj
            i32.load
            ,@(macro-is-heap-obj-type heap-object-type-string)
            call $i32->boolean
          else
            i32.const ,false-value
          end)

    (func (export "eq?") (param $obj1 i32) (param $obj2 i32) (result i32)
          local.get $obj1
          local.get $obj2
          i32.eq
          call $i32->boolean)

    (func (export "check-initialized") (param $obj i32) (result i32)
          local.get $obj
          local.get $obj
          i32.const ,uninitialized-value
          i32.eq
          if
          ,@(macro-raise-error error-uninitialized)
          end)

    (func (export "symbol=?") (param $s1 i32) (param $s2 i32) (result i32)
          local.get $s1
          call $check-symbol-type
          local.get $s2
          call $check-symbol-type
          i32.eq
          call $i32->boolean)

    (func (export "string=?") (param $s1 i32) (param $s2 i32) (result i32)
          (local $len i32)
          local.get $s1
          call $check-string
          i32.const ,heap-object-size-mask
          i32.and
          local.tee $len
          local.get $s2
          call $check-string
          i32.const ,heap-object-size-mask
          i32.and
          i32.eq
          if (result i32)
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
            call $equal-words
            call $i32->boolean
          else
            i32.const ,false-value
          end)

    (func $equal-words (param $addr1 i32) (param $addr2 i32) (param $n i32) (result i32)
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

    ;; Checks that $obj is a heap object of $type.
    ;; Returns $obj on success or raises $error.
    (func $check-heap-obj-type
          (param $obj i32)
          (param $type i32)
          (param $error i32)
          (result i32)
          block $error
            local.get $obj
            ,@macro-is-not-heap-obj
            br_if $error
            local.get $obj
            i32.load
            i32.const ,heap-object-type-mask
            i32.and
            local.get $type
            i32.ne
            br_if $error
            local.get $obj
            return
          end
          local.get $error
          global.set $error-code
          unreachable)

    ;; Checks that $obj is a heap object of $type.
    ;; Returns the header of the heap object on success or raises $error.
    (func $check-heap-obj
          (param $obj i32)
          (param $type i32)
          (param $error i32)
          (result i32)
          (local $heap-obj i32)
          block $error
            local.get $obj
            ,@macro-is-not-heap-obj
            br_if $error
            local.get $obj
            i32.load
            local.tee $heap-obj
            i32.const ,heap-object-type-mask
            i32.and
            local.get $type
            i32.ne
            br_if $error
            local.get $heap-obj
            return
          end
          local.get $error
          global.set $error-code
          unreachable)

    ;; Returns heap object header pointed by $obj if it is a heap object of type string.
    ;; Raises error-expected-string otherwise.
    (func $check-string (param $obj i32) (result i32)
          local.get $obj
          i32.const ,heap-object-type-string
          i32.const ,error-expected-string
          call $check-heap-obj)

    ;; Returns $obj if it is of symbol type.
    ;; Raises error-expected-symbol otherwise.
    (func $check-symbol-type (param $obj i32) (result i32)
          local.get $obj
          i32.const ,heap-object-type-symbol
          i32.const ,error-expected-symbol
          call $check-heap-obj-type)
    ))

(write scheme-base-wat)
(newline)
