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
