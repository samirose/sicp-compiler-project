(define-library (scheme-runtime-write)

  (export scheme-write-table-entry)

  (import (scheme base)
          (scheme-runtime-base)
          (runtime-memory)
          (values))

  (begin
    (define definitions
      '(($fd_write
         (func (import "wasi_snapshot_preview1" "fd_write")
               (param i32 i32 i32 i32) (result i32)))))

    (define code-table
      `(($write-string
         write-string
         ,(lambda (runtime-index)
            `(func (param $obj i32) (result i32)
                   (local $bytes_written i32)
                     ;; TEST==>
                     ;; (local $simulate_partial i32) (local $temp i32)
                     ;; <==TEST
                   ;; set up iovec from the string contents
                   i32.const ,write-string-length-addr
                   local.get $obj
                   call ,(runtime-index '((scheme base) $check-string))
                   i32.const ,heap-object-size-mask
                   i32.and
                     ;; TEST==>
                     ;; i32.const 7
                     ;; local.tee $simulate_partial
                     ;; i32.sub
                     ;; <==TEST
                   i32.store
                   i32.const ,write-string-pointer-addr
                   local.get $obj
                   i32.const ,heap-object-header-size
                   i32.add
                   i32.store
                   ;; start writing loop
                   loop $write
                     block $result_ok
                       ;; call WASI fd_write with iovec
                       i32.const 1 ;; stdout
                       i32.const ,write-string-pointer-addr
                       i32.const 1 ;; one iovec
                       i32.const ,write-string-bytes-written-addr
                       call ,(runtime-index '$fd_write)
                       ;; check for errors
                       i32.eqz
                       br_if $result_ok
                       i32.const ,error-io-write
                       ,@(macro-raise-error runtime-index)
                     end ;; block $result_ok
                     block $done
                         ;; TEST ==>
                         ;; i32.const ,write-string-length-addr
                         ;; i32.load
                         ;; local.get $simulate_partial
                         ;; i32.add
                         ;; local.tee $temp
                         ;; i32.const ,write-string-length-addr
                         ;; local.get $temp
                         ;; i32.store
                         ;; i32.const 0
                         ;; local.set $simulate_partial
                         ;; <== TEST
                       ;; check for partial write
                       i32.const ,write-string-bytes-written-addr
                       i32.load
                       local.tee $bytes_written
                       i32.const ,write-string-length-addr
                       i32.load
                       i32.eq
                       br_if $done
                       ;; partial write, setup iovec for next write
                       i32.const ,write-string-pointer-addr
                       i32.const ,write-string-pointer-addr
                       i32.load
                       local.get $bytes_written
                       i32.add
                       i32.store
                       i32.const ,write-string-length-addr
                       i32.const ,write-string-length-addr
                       i32.load
                       local.get $bytes_written
                       i32.sub
                       i32.store
                       br $write
                     end ;; block $done
                   end ;; loop $write
                   i32.const ,unspecified-value)))))

    (define scheme-write-table-entry
      `((scheme write) ,definitions ,code-table))
    )
  )
