(define-library (host-compiler-test)

  (export compiler-test-begin
	  compiler-test-end
	  compiler-test-eq)

  (import (scheme base)
	  (scheme process-context)
	  (srfi srfi-64))

  (begin
    (define (compiler-test-begin name-symbol)
      (test-begin (symbol->string name-symbol)))

    (define-syntax compiler-test-eq
      (syntax-rules ()
	((compiler-test-eq name-symbol desc . rest)
	 (test-eq desc . rest))))

    (define (compiler-test-end name-symbol)
      (let ((success (= 0 (test-runner-fail-count (test-runner-current)))))
	(test-end (symbol->string name-symbol))
	(exit success)))))
