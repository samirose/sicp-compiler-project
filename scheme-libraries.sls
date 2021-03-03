#!r6rs
(library
 (scheme-libraries)

 (export add-import-definitions)

 (import (rnrs base)
         (rnrs lists)
         (compiled-program)
         (compilation-error))

 (define library-import-definitions
   '(((scheme base)
      ("scheme base"
       ("get-error-code" (func (result i32)))
       ("i32->fixnum"    (func (param i32) (result i32)))
       ("fixnum->i32"    (func (param i32) (result i32)))
       ("number?"        (func (param i32) (result i32)))
       ("zero?"          (func (param i32) (result i32)))
       ("i32->boolean"   (func (param i32) (result i32)))
       ("boolean->i32"   (func (param i32) (result i32)))
       ("boolean?"       (func (param i32) (result i32)))))))

 (define (import-definitions library)
   (cond ((assoc library library-import-definitions)
          => (lambda (defs)
               (let ((name (caadr defs)))
                 (map (lambda (def)
                        `(import ,name ,@def))
                      (cdadr defs)))))
         (else #f)))

 (define (add-import-definitions imports program)
   (cond
     ((null? imports) program)
     ((import-definitions (car imports))
      => (lambda (defs)
           (add-import-definitions
            (cdr imports)
            (compiled-program-with-definitions-and-value-code
             program defs '()))))
     (else (raise-compilation-error "Unsupported import" (car imports)))))
 )
