#!r6rs
(library
 (wasm-module-definitions)

 (export make-empty-wasm-module-definitions
         wasm-module-definitions-count
         wasm-module-add-definition
         wasm-module-contains-definition
         wasm-module-definition-index
         wasm-module-get-definitions)

 (import (rnrs base)
         (rnrs lists)
         (counted-set)
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
    (counted-set-add (definition-counts defs) (car def) 1)))

 (define (wasm-module-contains-definition defs def)
   (if (member def (definitions defs)) #t #f))

  (define (lookup-definition defs type predicate)
    (let loop ((ds (definitions defs))
               (count (wasm-module-definitions-count defs type)))
      (cond ((null? ds) #f)
            ((wasm-definition-type? type (car ds))
             (if (predicate (car ds))
                 (- count 1)
                 (loop (cdr ds) (- count 1))))
            (else
             (loop (cdr ds) count)))))

 (define (wasm-module-definition-index defs def)
   (lookup-definition
    defs
    (def-type def)
    (lambda (d) (equal? def d))))

 (define (wasm-module-get-definitions defs type)
   (let collect ((ds (definitions defs))
                 (result '()))
     (cond ((null? ds) result)
           ((eq? type (caar ds))
            (collect (cdr ds) (cons (car ds) result)))
           (else
            (collect (cdr ds) result)))))
 )
