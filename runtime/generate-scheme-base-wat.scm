(import (scheme base))
(import (scheme write))
(import (values))

(define macro-is-heap-obj
  `(i32.const ,immediate-value-mask
    i32.and
    i32.eqz))

(define (macro-is-heap-obj-type heap-obj-type)
  `(i32.const ,heap-object-type-mask
    i32.and
    i32.const ,heap-obj-type
    i32.eq))

(define (macro-raise-error error)
  `(i32.const ,error
    call $raise-error))

(define scheme-base-wat
  `(module
    $scheme-base

    (memory $heap (export "$heap") 1)

    (global $error-code (mut i32) (i32.const ,error-no-error))

    (func (export "get-error-code") (result i32)
          global.get $error-code
          i32.const ,error-no-error
          global.set $error-code)

    (func $raise-error (export "raise-error") (param $error-code i32)
          local.get $error-code
          global.set $error-code
          unreachable)

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
          i32.const ,error-expected-number
          call $raise-error
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
          i32.const ,error-expected-procedure
          call $raise-error
          end)

    (func (export "procedure->funcidx") (param $obj i32) (result i32)
          local.get $obj
          call $check-procedure
          i32.const ,immediate-shift
          i32.shr_s)

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
          i32.const ,error-uninitialized
          call $raise-error
          end)

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
            call $memequal
            call $i32->boolean
          else
            i32.const ,false-value
          end)

  (func $memequal (param $addr1 i32) (param $addr2 i32) (param $len i32) (result i32)
        block $same_contents
          block $process_words
            loop $compare_words
              ;; exit loop if length less than word size
              local.get $len
              i32.const 4
              i32.lt_u
              br_if $process_words
              ;; load word from addr1 and increment it by word
              local.get $addr1
              i32.load
              local.get $addr1
              i32.const 4
              i32.add
              local.set $addr1
              ;; load word from addr2 and increment it by word
              local.get $addr2
              i32.load
              local.get $addr2
              i32.const 4
              i32.add
              local.set $addr2
              ;; subtract word from len
              local.get $len
              i32.const 4
              i32.sub
              local.set $len
              ;; compare words
              i32.eq
              br_if $compare_words
              br $same_contents
            end
          end
          block $process_bytes
            loop $compare_bytes
              ;; exit when length reaches zero
              local.get $len
              i32.eqz
              br_if $process_bytes
              ;; load byte from addr1 and increment it by one
              local.get $addr1
              i32.load8_u
              local.get $addr1
              i32.const 1
              i32.add
              local.set $addr1
              ;; load byte from addr2 and increment it by one
              local.get $addr2
              i32.load8_u
              local.get $addr2
              i32.const 1
              i32.add
              local.set $addr2
              ;; subtract one from len
              local.get $len
              i32.const 1
              i32.sub
              local.set $len
              ;; compare bytes
              i32.eq
              br_if $compare_bytes
              br $same_contents
            end
          end
          ;; all elements were equal
          i32.const 1
          return
        end
        ;; an element was not equal
        i32.const 0)

    (func $check-string (param $obj i32) (result i32)
          (local $str i32)
          block $is_string
            block $is_heap_obj
              local.get $obj
              ,@macro-is-heap-obj
              br_if $is_heap_obj
              ,@(macro-raise-error error-expected-string)
            end
            local.get $obj
            i32.load
            local.tee $str
            ,@(macro-is-heap-obj-type heap-object-type-string)
            br_if $is_string
            ,@(macro-raise-error error-expected-string)
          end
          local.get $str)
    ))

(write scheme-base-wat)
(newline)
