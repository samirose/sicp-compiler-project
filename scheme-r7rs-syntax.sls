#!r6rs

(library
 (scheme-r7rs-syntax)
 (export r7rs-library?
         check-library-declarations
         library-declaration
         library-declarations)
 (import (rnrs base)
         (rnrs lists)
         (compilation-error))

 (define (r7rs-library? exp)
   (and (pair? exp)
        (eq? (car exp) 'define-library)
        (list? (cdr exp))))

 (define library-decltypes
   '(export begin))

 (define (check-library-declarations library-def)
   (letrec*
    ((check-all-lists-and-types
      (lambda (decls)
        (cond ((null? decls) 'ok)
              ((not (list? (car decls)))
               (make-compilation-error "Illegal R7RS library declaration" (car decls)))
              ((not (memq (caar decls) library-decltypes))
               (make-compilation-error "Unsupported R7RS library declaration" (car decls)))
              (else (check-all-lists-and-types (cdr decls))))))
     (check-decl-ordering
      (lambda (types decls)
        (cond ((null? decls) 'ok)
              ((null? types)
               (or (null? decls)
                   (make-compilation-error "Duplicated R7RS library declarations" decls)))
              ((not (eq? (caar decls) (car types)))
               (make-compilation-error "Unexpected R7RS library declaration" (car decls)))
              (else (check-decl-ordering (cdr types) (cdr decls))))))
     (library-declarations (cdr library-def))
     (first-result (check-all-lists-and-types library-declarations)))
    (if (compilation-error? first-result)
        first-result
        (check-decl-ordering
         (filter
          (lambda (type) (assq type library-declarations))
          library-decltypes)
         library-declarations))))

 (define (library-declaration type library-def)
   (assq type (cdr library-def)))

 (define (library-declarations type library-def)
   (let ((decl (library-declaration type library-def)))
     (if decl (cdr decl) '())))
)
