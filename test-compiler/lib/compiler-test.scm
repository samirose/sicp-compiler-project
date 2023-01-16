(define-library (compiler-test)

  (export compiler-test-begin
	  compiler-test-end
	  compiler-test-eq
	  compiler-test-invoke)

  (import (scheme base)
	  (scheme process-context)
	  (srfi srfi-64))

  (begin
    (define (compiler-test-begin name)
      (test-begin name))

    (define-syntax compiler-test-eq
      (syntax-rules ()
	((compiler-test-eq test-name expected test-expr)
	 (test-eq test-name expected test-expr))))

    (define-syntax compiler-test-invoke
      (syntax-rules ()
	((compiler-test-invoke proc args ...)
	 (proc args ...))))

    (define (compiler-test-end name)
      (let ((fail-count (test-runner-fail-count (test-runner-current))))
	(test-end name)
	(if (> fail-count 0)
	    (exit #f))))))
