#!r6rs
(library
 (scheme-libraries)

 (export add-import-definitions
         lookup-import)

 (import (rnrs base)
         (rnrs lists)
         (compiled-program)
         (definitions-table)
         (compilation-error))

 (define library-import-definitions
   '(((scheme base)
      ("scheme base"
       ("unspecified-value"   (global i32))
       ("uninitialized-value" (global i32))
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
               (let ((library-name (caadr defs)))
                 (map (lambda (def)
                        (let ((import-name (car def))
                              (import-type (cadr def)))
                          `(,(car import-type) (import ,library-name ,import-name)  ,@(cdr import-type))))
                      (cdadr defs)))))
         (else #f)))

 (define (add-import-definitions imports program)
   (fold-left
    (lambda (program import)
      (let ((defs (import-definitions import)))
        (if (not defs) (raise-compilation-error "Unsupported import" import))
        (compiled-program-with-definitions-and-value-code program defs '())))
    program
    imports))

 (define (lookup-import program type module name)
   (let* ((import-def `(import ,module, name))
          (index
           (lookup-definition-index
            (compiled-program-module-definitions program)
            type
            (lambda (def) (member import-def def)))))
     (if index
         index
         (raise-compilation-error "Import not found" import-def))))
 )
