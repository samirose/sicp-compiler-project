(import
 (scheme base)
 (assert)
 (module-compiler))

(install-test-compilation-error-handler!)

(define (assert-library-raises-compilation-error library expected-message expected-object description)
  (assert-raises-compilation-error
   (lambda () (compile-r7rs-library-to-wasm-module library))
   expected-message expected-object description))

(assert-library-raises-compilation-error
 '()
 "Invalid R7RS library definition"
 '()
 "Empty list is not a valid R7RS library")

(assert-library-raises-compilation-error
 'define-library
 "Invalid R7RS library definition"
 'define-library
 "Non-list is not a R7RS library definition")

(assert-library-raises-compilation-error
 '(library (name) (begin 42))
 "Invalid R7RS library definition"
 '(library (name) (begin 42))
 "Library definition should begin with define-library symbol")

(assert-library-raises-compilation-error
 '(define-library)
 "Empty library definition"
 '(define-library)
 "Library definition should be non-empty")

(assert-library-raises-compilation-error
 '(define-library name)
 "Expected list as library name"
 'name
 "Library name should be a list")

(assert-library-raises-compilation-error
 '(define-library (scheme x))
 "scheme as first library name identifier is reserved"
 '(scheme x)
 "Library name should not start with symbol scheme")

(assert-library-raises-compilation-error
 '(define-library (name "name" 1 0 1.1 -2))
 "Invalid library name identifiers"
 '("name" 1.1 -2)
 "Library name identifiers should be symbols or nonnegative integers")

(assert-library-raises-compilation-error
 '(define-library (name))
 "No begin declaration in library" '(define-library (name))
 "Library must have at least a begin declaration")

(assert-library-raises-compilation-error
 '(define-library (name) begin)
 "Illegal R7RS library declaration" 'begin
 "Library declarations must be lists")

(assert-library-raises-compilation-error
 '(define-library (name) ())
 "Illegal R7RS library declaration" '()
 "Library declarations must be non-empty lists")

(assert-library-raises-compilation-error
 '(define-library (name) (foo bar))
 "Unsupported R7RS library declaration" '(foo bar)
 "Library declarations must be ones defined in R7RS")

(assert-library-raises-compilation-error
 '(define-library (name) (begin 1) (foo bar))
 "Unsupported R7RS library declaration" '(foo bar)
 "Library declarations must be ones defined in R7RS")

(assert-library-raises-compilation-error
 '(define-library (name) (import))
 "Empty import library declaration" '(import)
 "Library import declaration must not be empty")

(assert-library-raises-compilation-error
 '(define-library (name) (export))
 "Empty export library declaration" '(export)
 "Library export declaration must not be empty")

(assert-library-raises-compilation-error
 '(define-library (name) (begin))
 "Empty begin library declaration" '(begin)
 "Library begin declaration must not be empty")

(assert-library-raises-compilation-error
 '(define-library (name) (export x) (begin 42))
 "No top-level definition for export" 'x
 "Export declaration must name top-level definitions")

(assert-library-raises-compilation-error
 '(define-library (name) (begin (define (sum a b) (+ a b)) (define sum 42)))
 "Top-level identifier already defined" 'sum
 "Top-level definitions must not be duplicated")

(assert-library-raises-compilation-error
 '(define-library (name)
    (import (scheme base))
    (import (scheme base))
    (begin 42))
 "Duplicate imported identifier" 'number?
 "It is an error to import the same identifier more than once")

(assert-library-raises-compilation-error
 '(define-library (name)
    (import (scheme base))
    (begin (set! number? 42)))
 "Cannot set! an imported identifier" 'number?
 "It is an error to mutate imported identifier")
