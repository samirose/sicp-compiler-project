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

 (define (check-declaration decl)
   (cond ((pattern-match? `(export ,?? ,??*) decl))
         ((pattern-match? '(export) decl)
          (raise-compilation-error "Empty export library declaration" decl))
         ((pattern-match? `(import ,?? ,??*) decl))
         ((pattern-match? '(import) decl)
          (raise-compilation-error "Empty import library declaration" decl))
         ((pattern-match? `(begin ,?? ,??*) decl))
         ((pattern-match? '(begin) decl)
          (raise-compilation-error "Empty begin library declaration" decl))
         ((pattern-match? `(,?? ,??*) decl)
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
