(define-library (wast-compiler-test)

  (export compiler-test-begin
	  compiler-test-end
	  compiler-test-eq)

  (import (scheme base)
	  (scheme process-context)
	  (scheme write))

  (begin
    (define (compiler-test-begin name)
      (write "compiler-test-begin ")
      (display name)
      (newline))

    (define-syntax compiler-test-eq
      (syntax-rules ()
	((test-eq symbol-name desc expected expr)
	 (begin
	   (display "test-eq ")
	   (write 'symbol-name)
	   (display " ")
	   (write desc)
	   (display " ")
	   (display expected)
	   (display "=")
	   (display expr)
	   (display " ")
	   (display 'expr)
	   (newline)))))

    (define (compiler-test-end name)
      (display "compiler-test-end ")
      (display name)
      (newline))))
