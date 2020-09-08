#!r6rs

(library
 (scheme-r7rs-syntax)
 (export r7rs-library?
         check-library-declarations
         library-declaration
         library-declarations)
 (import (rnrs base)
         (rnrs lists))

 (define (r7rs-library? exp)
   (and (pair? exp) (eq? (car exp) 'define-library)))

 (define library-decltypes
   '(export begin))

 (define (check-library-declarations library-def)
   (letrec*
    ((check-all-pairs-and-types
      (lambda (decls)
        (cond ((null? decls) #t)
              ((not (pair? (car decls)))
               (error "Illegal R7RS library declaration" (car decls)))
              ((not (memq (caar decls) library-decltypes))
               (error "Unsupported R7RS library declaration" (car decls)))
              (else (check-all-pairs-and-types (cdr decls))))))
     (check-decl-ordering
      (lambda (types decls)
        (cond ((null? decls) #t)
              ((null? types)
               (or (null? decls) (error "Duplicated R7RS library declarations" decls)))
              ((not (eq? (caar decls) (car types)))
               (error "Unexpected R7RS library declaration" (car decls)))
              (else (check-decl-ordering (cdr types) (cdr decls))))))
     (library-declarations (cdr library-def)))
    (check-all-pairs-and-types library-declarations)
    (check-decl-ordering
     (filter
      (lambda (type) (assq type library-declarations))
      library-decltypes)
     library-declarations)))

 (define (library-declaration type library-def)
   (assq type (cdr library-def)))

 (define (library-declarations type library-def)
   (let ((decl (library-declaration type library-def)))
     (if decl (cdr decl) '())))
)
