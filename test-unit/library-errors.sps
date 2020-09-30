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

(define (assert-raises-compilation-error action expected-message expected-object description)
  (let ((expected-error (make-test-compilation-error expected-message expected-object)))
    (guard (cond
             ((test-compilation-error? cond)
              (assert-equal-test-compilation-error expected-error cond)
              expected-error))
           (let ((result (action)))
             (if (not (eq? result expected-error))
                 (error description (list (cdr expected-error) result)))))))

(define (assert-library-raises-compilation-error library expected-message expected-object description)
  (assert-raises-compilation-error
   (lambda () (compile-r7rs-library-to-wasm-module library))
   expected-message expected-object description))

(assert-library-raises-compilation-error
 'foo
 "Invalid R7RS library" 'foo
 "Symbol is not a library")

(assert-library-raises-compilation-error
 '()
 "Invalid R7RS library" '()
 "Empty list is not a library")

(assert-library-raises-compilation-error
 '(define-library)
 "No begin declaration in library" '(define-library)
 "Library must have at least a begin declaration")

(assert-library-raises-compilation-error
 '(define-library begin)
 "Illegal R7RS library declaration" 'begin
 "Library declarations must be lists")

(assert-library-raises-compilation-error
 '(define-library (foo bar))
 "Unsupported R7RS library declaration" '(foo bar)
 "Library declarations must be ones defined in R7RS")

(assert-library-raises-compilation-error
 '(define-library (begin 1) (begin 2))
 "Duplicated R7RS library declarations" '((begin 2))
 "Library declarations must not be duplicated")

(assert-library-raises-compilation-error
 '(define-library (begin (define (x) 1) 2) (export x))
 "Unexpected R7RS library declaration" '(begin (define (x) 1) 2)
 "Library declarations must be in the order specified in R7RS")

(assert-library-raises-compilation-error
 '(define-library (begin))
 "Empty begin declaration in library" '(define-library (begin))
 "Library begin declaration must not be empty")

(assert-library-raises-compilation-error
 '(define-library (export x) (begin 42))
 "No top-level definition for export" 'x
 "Export declaration must name top-level definitions")

(assert-library-raises-compilation-error
 '(define-library (begin (define (sum a b) (+ a b)) (define sum 42)))
 "Top-level identifier already defined" 'sum
 "Top-level definitions must not be duplicated")
