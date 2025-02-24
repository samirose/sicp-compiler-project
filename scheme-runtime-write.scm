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
                   block $success
                   i32.const ,write-string-length-addr
                   local.get $obj
                   call ,(runtime-index '((scheme base) $check-string))
                   i32.const ,heap-object-size-mask
                   i32.and
                   i32.store
                   i32.const ,write-string-pointer-addr
                   local.get $obj
                   i32.const ,heap-object-header-size
                   i32.add
                   i32.store
                   i32.const 1 ;; stdout
                   i32.const ,write-string-pointer-addr
                   i32.const 1 ;; one iovec
                   i32.const ,write-string-bytes-written-addr
                   call ,(runtime-index '$fd_write)
                   i32.eqz
                   br_if $success
                   i32.const ,error-io-write
                   ,@(macro-raise-error runtime-index)
                   end ;; $success
                   i32.const ,unspecified-value)))))

    (define scheme-write-table-entry
      `((scheme write) ,definitions ,code-table))
    )
  )
