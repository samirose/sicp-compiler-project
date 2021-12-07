#!r6rs
(import
 (rnrs base)
 (assert)
 (module-compiler))

(install-test-compilation-error-handler!)

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
 '(define-library ())
 "Illegal R7RS library declaration" '()
 "Library declarations must be non-empty lists")

(assert-library-raises-compilation-error
 '(define-library (foo bar))
 "Unsupported R7RS library declaration" '(foo bar)
 "Library declarations must be ones defined in R7RS")

(assert-library-raises-compilation-error
 '(define-library (begin 1) (foo bar))
 "Unsupported R7RS library declaration" '(foo bar)
 "Library declarations must be ones defined in R7RS")

(assert-library-raises-compilation-error
 '(define-library (import))
 "Empty import library declaration" '(import)
 "Library import declaration must not be empty")

(assert-library-raises-compilation-error
 '(define-library (export))
 "Empty export library declaration" '(export)
 "Library export declaration must not be empty")

(assert-library-raises-compilation-error
 '(define-library (begin))
 "Empty begin library declaration" '(begin)
 "Library begin declaration must not be empty")

(assert-library-raises-compilation-error
 '(define-library (export x) (begin 42))
 "No top-level definition for export" 'x
 "Export declaration must name top-level definitions")

(assert-library-raises-compilation-error
 '(define-library (begin (define (sum a b) (+ a b)) (define sum 42)))
 "Top-level identifier already defined" 'sum
 "Top-level definitions must not be duplicated")

(assert-library-raises-compilation-error
 '(define-library
    (import (scheme base))
    (import (scheme base))
    (begin 42))
 "Duplicate imported identifier" 'number?
 "It is an error to import the same identifier more than once")
