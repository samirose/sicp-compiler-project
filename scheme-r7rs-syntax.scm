(define-library (scheme-r7rs-syntax)

  (export check-library
          check-library-declarations
          library-has-declaration?
          library-declarations)

  (import (scheme base)
	  (lists)
          (pattern-match)
          (compilation-error))

  (begin
    (define (check-library exp)
      (cond
       ((pattern-match? `(define-library (,?? ,??*) ,??*) exp)
	(let ((identifiers (cadr exp)))
          (if (pattern-match? `(scheme ,??*) identifiers)
              (raise-compilation-error "scheme as first library name identifier is reserved" identifiers))
          (let ((invalid-identifiers
		 (filter
                  (lambda (identifier)
                    (not
                     (or (symbol? identifier)
			 (and (number? identifier) (integer? identifier) (>= identifier 0)))))
                  identifiers)))
            (if (not (null? invalid-identifiers))
		(raise-compilation-error "Invalid library name identifiers" invalid-identifiers)))))
       ((pattern-match? `(define-library) exp)
	(raise-compilation-error "Empty library definition" exp))
       ((pattern-match? `(define-library ,??) exp)
	(raise-compilation-error "Expected list as library name" (cadr exp)))
       (else
	(raise-compilation-error "Invalid R7RS library definition" exp))))

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
      (for-each check-declaration (cddr library-def)))

    (define (library-has-declaration? type library-def)
      (and (assq type (cddr library-def)) #t))

    (define (library-declarations type library-def)
      (let collect ((decls (cddr library-def))
                    (decl '())
                    (result '()))
	(cond ((null? decl)
               (cond ((null? decls) (reverse result))
                     ((eq? (caar decls) type) (collect (cdr decls) (cdar decls) result))
                     (else (collect (cdr decls) '() result))))
              (else (collect decls (cdr decl) (cons (car decl) result))))))
    ))
