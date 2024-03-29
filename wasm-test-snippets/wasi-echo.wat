(module
  (import "wasi_snapshot_preview1" "fd_write"  (func $fd_write (param i32 i32 i32 i32) (result i32)))
  (import "wasi_snapshot_preview1" "fd_read"  (func $fd_read (param i32 i32 i32 i32) (result i32)))

  (memory 10)
  (export "memory" (memory 0))

  ;; WASI iovec for prompt string
  (data (i32.const 0x00) "\08\00\00\00") ;; pointer to prompt string
  (data (i32.const 0x04) "\02\00\00\00") ;; prompt string length: 2 characters
  ;; prompt string
  (data (i32.const 0x08) "> ")

  ;; WASI iovec for reading to input buffer
  (data (i32.const 0x0c) "\20\00\00\00") ;; pointer to buffer
  (data (i32.const 0x10) "\64\00\00\00") ;; buffer length 0x64=100 characters
  ;; WASI iovec for writing out input buffer
  (data (i32.const 0x14) "\20\00\00\00") ;; pointer to buffer
  (data (i32.const 0x18) "\64\00\00\00") ;; buffer length, initially 100 characters
  ;; bytes written to output
  (data (i32.const 0x1c) "\00\00\00\00")
  ;; input buffer
  (data (i32.const 0x20) "\00") ;; buffer to hold characters read

  ;; WASI main entry point
  (func $main (export "_start")
    (local $bytes_read i32)
    (local $bytes_written i32)
    (block $done
      (loop $prompt_next

        ;; write prompt
        (call $fd_write
          (i32.const 1)    ;; stdout
          (i32.const 0x00) ;; prompt string iovec address
          (i32.const 1)    ;; one iovec
          (i32.const 0x1c) ;; location to write number of bytes written
        )
        drop ;; discard result

        (loop $readloop
          ;; read input to buf, write number of bytes read to write iovec length
          (call $fd_read
            (i32.const 0)    ;; stdin
            (i32.const 0x0c) ;; input buffer iovec address
            (i32.const 1)    ;; one iovec
            (i32.const 0x18) ;; number of bytes read written directly to write iovec
          )

          ;; if result != success branch out
          i32.const 0
          i32.ne
          br_if $done

          ;; exit if bytes read is zero (end of file)
          (i32.load (i32.const 0x18))
          local.tee $bytes_read
          i32.eqz
          br_if $done

          ;; restore write iovec buffer pointer
          (i32.store (i32.const 0x14) (i32.const 0x20))

          (loop $writeall
            ;; write out bytes read into the buffer
            (call $fd_write
              (i32.const 1)    ;; stdout
              (i32.const 0x14) ;; input buffer write iovec address
              (i32.const 1)    ;; one iovec
              (i32.const 0x1c) ;; location to write number of bytes written
            )

            ;; if result != success branch out
            i32.const 0
            i32.ne
            br_if $done

            ;; check if all read bytes were written and stay in writeloop if not
            (block $writecomplete
              (i32.load (i32.const 0x1c))
              local.tee $bytes_written
              (i32.load (i32.const 0x18))
              i32.eq
              br_if $writecomplete
              ;; not all was written, update write iovec and write again
              (i32.load (i32.const 0x14))
              local.get $bytes_written
              i32.add
              (i32.store (i32.const 0x14))
              (i32.load (i32.const 0x18))
              local.get $bytes_written
              i32.sub
              (i32.store (i32.const 0x18))
              br $writeall
            )
          )

          ;; check if the buffer was full and prompt for next input if not
          local.get $bytes_read
          (i32.load (i32.const 0x10)) ;; input buffer length in read iovec
          i32.lt_s
          br_if $prompt_next

          ;; check if the read input ended in a line feed (assume line-oriented stdin)
          local.get $bytes_read
          i32.load offset=0x1f
          (i32.const 0x0a) ;; ASCII LF (line feed)
          i32.eq
          br_if $prompt_next ;; input ended in line feed, prompt for next input

          ;; read more input to buffer
          br $readloop
        )
      )
    )
  )
)
