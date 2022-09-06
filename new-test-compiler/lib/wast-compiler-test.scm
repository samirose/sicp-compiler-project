(define-library (wast-compiler-test)

  (export compiler-test-begin
	  compiler-test-end
	  compiler-test-eq)

  (import (scheme base)
	  (scheme write))

  (begin
    (define test-exports '())
    (define test-definitions '())

    (define (compiler-test-begin name-symbol)
      (set! test-exports '())
      (set! test-definitions '()))

    (define-syntax compiler-test-eq
      (syntax-rules ()
	((test-eq symbol-name desc expected expr)
	 (begin
	   (set! test-exports
		 (cons 'symbol-name test-exports))
	   (set! test-definitions
		 (cons `(define (symbol-name)
			   (eq? expected expr))
		       test-definitions))))))

    (define (compiler-test-end name-symbol)
      (display
       `(define-library (,name-symbol)
	  (export ,@(reverse test-exports))
	  (import (scheme base))
	  (begin
	    ,@(reverse test-definitions)))))))
