#!r6rs

(library
 (scheme-r7rs-syntax)
 (export r7rs-library?
         check-library-declarations
         library-has-declaration?
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

 (define (check-declaration decl)
   (cond ((pattern-match? `(,library-decltype? ,??*) decl))
         ((pattern-match? `(,(lambda (d) (not (library-decltype? d))) ,??*) decl)
          (raise-compilation-error "Unsupported R7RS library declaration" decl))
         ((not (pattern-match? `(,?? ,??*) decl))
          (raise-compilation-error "Illegal R7RS library declaration" decl))))

 (define (check-library-declarations library-def)
   (for-each check-declaration (cdr library-def)))

 (define (library-has-declaration? type library-def)
   (and (assq type (cdr library-def)) #t))

 (define (library-declarations type library-def)
   (let collect ((decls (cdr library-def))
                 (decl '())
                 (result '()))
     (cond ((null? decl)
            (cond ((null? decls) (reverse result))
                  ((eq? (caar decls) type) (collect (cdr decls) (cdar decls) result))
                  (else (collect (cdr decls) '() result))))
           (else (collect decls (cdr decl) (cons (car decl) result))))))
 )
