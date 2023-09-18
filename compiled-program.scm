(define-library (compiled-program)

  (export make-empty-compiled-program
          compiled-program-module-definitions
          compiled-program-value-code
          compiled-program-with-value-code
          compiled-program-append-value-code
          compiled-program-append-value-codes
          compiled-program-add-definition
          compiled-program-last-definition
          compiled-program-lookup-definition
          compiled-program-get-definitions
          compiled-program-contains-definition
          compiled-program-definition-index
          compiled-program-definitions-count
          compiled-program-with-definition-and-value-code
          compiled-program-with-definitions-and-value-code)

  (import (scheme base)
	  (lists)
          (definitions-table))

  (begin
    (define (make-compiled-program module-definitions value-code)
      (list module-definitions value-code))

    (define (compiled-program-module-definitions cp)
      (car cp))

    (define (compiled-program-value-code cp)
      (cadr cp))

    (define (make-empty-compiled-program)
      (make-compiled-program
       (make-empty-definitions-table)
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
       (add-definition
	(compiled-program-module-definitions cp)
	definition)
       (compiled-program-value-code cp)))

    (define (compiled-program-last-definition cp type)
      (last-definition
       (compiled-program-module-definitions cp)
       type))

    (define (compiled-program-lookup-definition cp predicate)
      (lookup-definition
       (compiled-program-module-definitions cp)
       predicate))

    (define (compiled-program-get-definitions cp type)
      (get-definitions
       (compiled-program-module-definitions cp)
       type))

    (define (compiled-program-contains-definition cp definition)
      (contains-definition
       (compiled-program-module-definitions cp)
       definition))

    (define (compiled-program-definition-index cp definition)
      (definition-index
	(compiled-program-module-definitions cp)
	definition))

    (define (compiled-program-definitions-count cp type)
      (definitions-count
	(compiled-program-module-definitions cp)
	type))

    (define (compiled-program-with-definition-and-value-code cp definition code)
      (make-compiled-program
       (add-definition
	(compiled-program-module-definitions cp)
	definition)
       code))

    (define (compiled-program-with-definitions-and-value-code cp definitions code)
      (fold
       (lambda (definition cp)
	 (compiled-program-with-definition-and-value-code cp definition code))
       cp
       definitions))
    ))
