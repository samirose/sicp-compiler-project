#!r6rs
(library
 (compiled-program)

 (export make-empty-compiled-program
         compiled-program-module-definitions
         compiled-program-value-code
         compiled-program-with-value-code
         compiled-program-append-value-code
         compiled-program-append-value-codes
         compiled-program-add-definition
         compiled-program-get-definitions
         compiled-program-contains-definition
         compiled-program-definition-index
         compiled-program-definitions-count
         compiled-program-with-definition-and-value-code
         compiled-program-with-definitions-and-value-code)

 (import (rnrs base)
         (rnrs lists)
         (wasm-module-definitions))

 (define (make-compiled-program module-definitions value-code)
   (list module-definitions value-code))

 (define (compiled-program-module-definitions cp)
   (car cp))

 (define (compiled-program-value-code cp)
   (cadr cp))

 (define (make-empty-compiled-program)
   (make-compiled-program
    (make-empty-wasm-module-definitions)
    '()))

 (define (compiled-program-with-value-code cp code)
   (make-compiled-program
    (compiled-program-module-definitions cp)
    code))

 (define (compiled-program-append-value-code cp code)
   (make-compiled-program
    (compiled-program-module-definitions cp)
    (append (compiled-program-value-code cp)
            code)))

 (define (compiled-program-append-value-codes cp1 cp2)
   (make-compiled-program
    (compiled-program-module-definitions cp2)
    (append (compiled-program-value-code cp1)
            (compiled-program-value-code cp2))))

  (define (compiled-program-add-definition cp definition)
    (make-compiled-program
     (wasm-module-add-definition
      (compiled-program-module-definitions cp)
      definition)
     (compiled-program-value-code cp)))

  (define (compiled-program-get-definitions cp type)
    (wasm-module-get-definitions
     (compiled-program-module-definitions cp)
     type))

  (define (compiled-program-contains-definition cp definition)
    (wasm-module-contains-definition
     (compiled-program-module-definitions cp)
     definition))

  (define (compiled-program-definition-index cp definition)
    (wasm-module-definition-index
     (compiled-program-module-definitions cp)
     definition))

  (define (compiled-program-definitions-count cp type)
    (wasm-module-definitions-count
     (compiled-program-module-definitions cp)
     type))

  (define (compiled-program-with-definition-and-value-code cp definition code)
    (make-compiled-program
     (wasm-module-add-definition
      (compiled-program-module-definitions cp)
      definition)
     code))

 (define (compiled-program-with-definitions-and-value-code cp definitions code)
   (fold-left
     (lambda (cp definition)
       (compiled-program-with-definition-and-value-code cp definition code))
     cp
     definitions))
)
