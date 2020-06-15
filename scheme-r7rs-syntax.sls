#!r6rs

(library
 (scheme-r7rs-syntax)
 (export r7rs-library? library-decl)
 (import (rnrs base)
         (rnrs lists))

 (define (r7rs-library? exp)
   (and (pair? exp) (eq? (car exp) 'define-library)))

 (define library-decltypes
   '(begin))

 (define (library-decl type library-def)
   (for-each
    (lambda (decl)
      (or (and (pair? decl) (memq (car decl) library-decltypes))
          (error "Unsupported R7RS library declaration" decl)))
    (cdr library-def))
   (assq type (cdr library-def)))
 )