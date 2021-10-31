#!r6rs
(library
 (scheme-libraries)

 (export import-definitions
         import-binding
         import-definition
         import-type
         import-name
         lookup-import)

 (import (rnrs base)
         (rnrs lists)
         (compiled-program)
         (definitions-table)
         (compilation-error))

 (define library-import-table
   '(((scheme base)
      ("scheme base"
       (#f         "unspecified-value"   (global i32))
       (#f         "uninitialized-value" (global i32))
       (#f         "get-error-code"      (func (result i32)))
       (#f         "i32->fixnum"         (func (param i32) (result i32)))
       (#f         "fixnum->i32"         (func (param i32) (result i32)))
       (number?    "number?"             (func (param i32) (result i32)))
       (zero?      "zero?"               (func (param i32) (result i32)))
       (#f         "i32->boolean"        (func (param i32) (result i32)))
       (#f         "boolean->i32"        (func (param i32) (result i32)))
       (boolean?   "boolean?"            (func (param i32) (result i32)))
       (procedure? "procedure?"          (func (param i32) (result i32)))))))

 (define (library-definitions library)
   (cond ((assoc library library-import-table) => cadr)
         (else #f)))

 (define (import-binding import-def)
   (car import-def))

 (define (import-definition import-def)
   (cadr import-def))

 (define (import-type import-def)
   (car (import-definition import-def)))

 (define (import-name import-def)
   (cdadr (import-definition import-def)))

 (define (library-import-definitions library)
   (cond ((library-definitions library)
          => (lambda (defs)
               (let ((library-name (car defs))
                     (import-entries (cdr defs)))
                 (map (lambda (entry)
                        (let ((binding (car entry))
                              (import-name (cadr entry))
                              (import-type (caddr entry)))
                          `(,binding
                            (,(car import-type)
                             (import ,library-name ,import-name)
                             ,@(cdr import-type)))))
                      import-entries))))
          (else #f)))

 (define (import-definitions scheme-imports)
   (fold-left
    (lambda (definitions scheme-import)
      (let ((defs (library-import-definitions scheme-import)))
        (if (not defs) (raise-compilation-error "Unsupported import" scheme-import))
        (append definitions defs)))
    '()
    scheme-imports))

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
