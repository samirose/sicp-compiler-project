#!r6rs
(import
 (rnrs base)
 (assert)
 (scheme-r7rs-syntax))

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
