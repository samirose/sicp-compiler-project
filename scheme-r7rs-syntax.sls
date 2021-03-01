#!r6rs

(library
 (scheme-r7rs-syntax)
 (export r7rs-library?
         check-library-declarations
         library-declaration
         library-declarations)
 (import (rnrs base)
         (rnrs lists)
         (pattern-match)
         (compilation-error))

 (define (r7rs-library? exp)
   (pattern-match? `(define-library ,??*) exp))

 (define library-decltypes
   '(export begin))

 (define (library-decltype? type)
   (and (memq type library-decltypes) #t))

 (define (check-library-declarations library-def)
   (letrec*
    ((check-declaration
      (lambda (decl)
        (cond ((pattern-match? `(,library-decltype? ,??*) decl))
              ((pattern-match? `(,(lambda (d) (not (library-decltype? d))) ,??*) decl)
               (raise-compilation-error "Unsupported R7RS library declaration" decl))
              ((not (pattern-match? `(,?? ,??*) decl))
               (raise-compilation-error "Illegal R7RS library declaration" decl)))))
     (check-decl-ordering
      (lambda (types decls)
        (cond ((null? decls))
              ((null? types)
               (or (null? decls)
                   (raise-compilation-error "Duplicated R7RS library declarations" decls)))
              ((not (eq? (caar decls) (car types)))
               (raise-compilation-error "Unexpected R7RS library declaration" (car decls)))
              (else (check-decl-ordering (cdr types) (cdr decls))))))
     (library-declarations (cdr library-def)))
    (for-each check-declaration library-declarations)
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
