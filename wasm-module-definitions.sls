#!r6rs
(library
 (wasm-module-definitions)

 (export make-empty-wasm-module-definitions
         wasm-module-definitions-count
         wasm-module-add-definition
         wasm-module-get-definitions)

 (import (rnrs)
         (lists)
         (wasm-syntax))

 (define (make-wasm-module-definitions defs def-counts)
   (list defs def-counts))

 (define (make-empty-wasm-module-definitions)
   (make-wasm-module-definitions '() (make-counted-set)))

 (define (definitions defs)
   (car defs))

 (define (definition-counts defs)
   (cadr defs))

 (define (wasm-module-definitions-count defs type)
   (counted-set-count (definition-counts defs) type))

 (define (def-type def)
   (car def))

 (define (wasm-module-add-definition defs def)
   (make-wasm-module-definitions
    (cons def (definitions defs))
    (counted-set-add (definition-counts defs) (car def))))

 (define (wasm-module-get-definitions defs type)
   (let collect ((ds (definitions defs))
                 (result '()))
     (cond ((null? ds) result)
           ((eq? type (caar ds))
            (collect (cdr ds) (cons (car ds) result)))
           (else
            (collect (cdr ds) result)))))
 )
