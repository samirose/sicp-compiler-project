#!r6rs
(import
 (rnrs base)
 (assert)
 (scheme-r7rs-syntax)
 (compilation-error))

(assert-equal
 #t
 (r7rs-library? '(define-library (begin 42)))
 "List starting with symbol define-library is r7rs-library?")

(assert-equal
 #f
 (r7rs-library? '())
 "Empty list is not r7rs-library?")

(assert-equal
 #f
 (r7rs-library? 'define-library)
 "Non-pair is not r7rs-library?")

(assert-equal
 #f
 (r7rs-library? (cons 'define-library 'begin))
 "Non-list is not r7rs-library?")

(assert-equal
 "Illegal R7RS library declaration"
 (compilation-error-message (check-library-declarations '(define-library begin)))
 "A symbol is not a valid library declaration")

(assert-equal
 "Illegal R7RS library declaration"
 (compilation-error-message (check-library-declarations (list 'define-library (cons 'begin 42))))
 "A pair is not a valid library declaration")

(assert-equal
 'ok
 (check-library-declarations '(define-library (begin 42)))
 "Library declarations may consist of only a begin declaration (not valid in R7RS)")

(assert-equal
 'ok
 (check-library-declarations '(define-library (export foo) (begin 42)))
 "Library declarations may consist of single export and begin declarations")

(assert-equal
 "Unsupported R7RS library declaration"
 (compilation-error-message (check-library-declarations '(define-library (foo 42))))
 "A library declaration must be a list that starts with a supported section symbol")

(assert-equal
 "Duplicated R7RS library declarations"
 (compilation-error-message (check-library-declarations '(define-library (begin 42) (begin 53))))
 "Library declarations must not be duplicated")

(assert-equal
 "Unexpected R7RS library declaration"
  (compilation-error-message (check-library-declarations '(define-library (begin 42) (export foo))))
 "Library declarations must be declared in the order specified in the R7RS spec")

(define test-library
  '(define-library
     (export square)
     (begin
       (define (square x) (* x x))
       (square 5))))

(assert-equal
 '(export square)
 (library-declaration 'export test-library)
 "library-declaration returns the whole matching declaration in a library")

(assert-equal
 #f
 (library-declaration 'import test-library)
 "library-declaration returns #f when no matching declaration is found in a library")

(assert-equal
 '((define (square x) (* x x)) (square 5))
 (library-declarations 'begin test-library)
 "library-declarations returns the contents of a matching declaration in a library")

(assert-equal
 '()
 (library-declarations 'import test-library)
 "library-declarations returns an empty list when no matching declaration is found in a library")
