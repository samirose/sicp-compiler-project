(import (compiler-test)
	(define))

(compiler-test-begin "define")

(compiler-test-eq
 "define creates top-level bindings from constants"
 42 (define-constants))

(compiler-test-eq
 "define creates top-level bindings from combinations"
 43 (define-combinations))

(compiler-test-eq
 "define creates top-level binding from lambda expression result"
 22 (define-lambda-combination))

(compiler-test-eq
 "define creates top-level procedure binding"
 16 (define-procedure))

(compiler-test-eq
 "define creates top-level procedure binding from lambda expression"
 25 (define-procedure-with-lambda))

(compiler-test-end "define")
