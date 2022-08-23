(define-library
    (run-compiler-test)

  (export begin-compiler-test
	  end-compiler-test
	  test-eq)

  (import (scheme base)
	  (scheme process-context)
	  (srfi srfi-64))

  (begin
    (define (begin-compiler-test name)
      (test-begin name))

    (define (end-compiler-test name)
      (let ((success (= 0 (test-runner-fail-count (test-runner-current)))))
	(test-end name)
	(exit success)))))
