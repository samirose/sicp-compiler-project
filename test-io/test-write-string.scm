(define-library (test-write-string)

  (export _start)

  (import (scheme base)
          (scheme write))

  (begin
    (define (_start)
      (write-string "Hello world!\n"))
    ))
