#!r6rs
(import
 (rnrs base)
 (rnrs exceptions)
 (lists)
 (assert)
 (compilation-error)
 (module-compiler))

(define last-message '())
(define last-object '())

(define (error-handler message object)
  (set! last-message message)
  (set! last-object object)
  (raise 'compilation-error))

(set-compilation-error-handler! error-handler)

(define (assert-raises-compilation-error action expected-message expected-object)
  (let ((expected-error-properties (list expected-message expected-object)))
    (guard (cond
             ((eq? cond 'compilation-error)
              (assert-equal expected-message last-message "Unexpected error message")
              (assert-equal expected-object last-object "Unexpected error object")
              expected-error-properties))
           (if (not (eq? (action) expected-error-properties))
               (error "Expected compilation error" expected-error-properties)))))

(assert-raises-compilation-error
 (lambda () (compile-r7rs-library-to-wasm-module 'foo))
 "Invalid R7RS library" 'foo)
