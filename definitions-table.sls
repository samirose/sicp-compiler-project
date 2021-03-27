#!r6rs
(library
 (definitions-table)

 (export make-empty-definitions-table
         definitions-count
         add-definition
         contains-definition
         definition-index
         get-definitions)

 (import (rnrs base)
         (rnrs lists)
         (counted-set)
         (wasm-syntax))

 (define (make-definitions-table defs def-counts)
   (list defs def-counts))

 (define (make-empty-definitions-table)
   (make-definitions-table '() (make-counted-set)))

 (define (definitions defs)
   (car defs))

 (define (definition-counts defs)
   (cadr defs))

 (define (definitions-count defs type)
   (counted-set-count (definition-counts defs) type))

 (define (def-type def)
   (car def))

 (define (add-definition defs def)
   (make-definitions-table
    (cons def (definitions defs))
    (counted-set-add (definition-counts defs) (car def) 1)))

 (define (contains-definition defs def)
   (if (member def (definitions defs)) #t #f))

 (define (lookup-definition defs type predicate)
   (let loop ((ds (definitions defs))
              (count (definitions-count defs type)))
     (cond ((null? ds) #f)
           ((wasm-definition-type? type (car ds))
            (if (predicate (car ds))
                (- count 1)
                (loop (cdr ds) (- count 1))))
           (else
            (loop (cdr ds) count)))))

 (define (definition-index defs def)
   (lookup-definition
    defs
    (def-type def)
    (lambda (d) (equal? def d))))

 (define (get-definitions defs type)
   (let collect ((ds (definitions defs))
                 (result '()))
     (cond ((null? ds) result)
           ((eq? type (caar ds))
            (collect (cdr ds) (cons (car ds) result)))
           (else
            (collect (cdr ds) result)))))
 )
