#!r6rs
(import
 (rnrs base)
 (rnrs exceptions)
 (lists)
 (assert)
 (compilation-error)
 (module-compiler))

(define (make-test-compilation-error message object)
  (list 'test-compilation-error message object))

(define (test-compilation-error? e)
  (and (list? e) (eq? (car e) 'test-compilation-error)))

(define (assert-equal-test-compilation-error expected actual)
  (assert-equal (cadr expected) (cadr actual) "Error messages should be equal")
  (assert-equal (caddr expected) (caddr actual) "Error objects should be equal"))

(define (error-handler message object)
  (raise (make-test-compilation-error message object)))

(set-compilation-error-handler! error-handler)

(define (assert-raises-compilation-error action expected-message expected-object)
  (let ((expected-error (make-test-compilation-error expected-message expected-object)))
    (guard (cond
             ((test-compilation-error? cond)
              (assert-equal-test-compilation-error expected-error cond)
              expected-error))
           (if (not (eq? (action) expected-error))
               (error "Expected compilation error" expected-error)))))

(assert-raises-compilation-error
 (lambda () (compile-r7rs-library-to-wasm-module 'foo))
 "Invalid R7RS library" 'foo)
