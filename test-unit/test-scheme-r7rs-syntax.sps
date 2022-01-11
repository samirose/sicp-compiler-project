#!r6rs
(import
 (rnrs base)
 (assert)
 (scheme-r7rs-syntax))

(define test-library
  '(define-library (name 1 0)
     (import lib1)
     (export square)
     (import lib2)
     (begin
       (define (square x) (* x x))
       (square 5))))

(check-library test-library)

(assert-equal
 #t
 (library-has-declaration? 'export test-library)
 "library-has-declaration? returns true when matching declaration is in a library")

(assert-equal
 #f
 (library-has-declaration? 'include test-library)
 "library-has-declaration? returns false when no matching declaration is found in a library")

(assert-equal
 '((define (square x) (* x x)) (square 5))
 (library-declarations 'begin test-library)
 "library-declarations returns the contents of a single matching declaration in a library")

(assert-equal
 '(lib1 lib2)
 (library-declarations 'import test-library)
 "library-declarations returns the contents of multiple matching declarations in a library in declaration order")
