(define-library (scheme-runtime)

  (export is-runtime-library
          compile-runtime-library-definitions
          compile-runtime-library
          runtime-exports
          lookup-runtime-index)

  (import (scheme base)
          (scheme cxr)
          (lists)
          (definitions-table)
          (compiled-program)
          (wasm-syntax))

  (import (scheme-runtime-base)
          (scheme-runtime-write))

  (begin
    (define runtime-libraries-table
      (list scheme-base-table-entry
            scheme-write-table-entry))

    (define (runtime-library-entry library)
      (assoc library runtime-libraries-table))

    (define (is-runtime-library library)
      (cond ((runtime-library-entry library) #t)
            (else #f)))

    (define (runtime-library-definitions library-entry)
      (cadr library-entry))

    (define (runtime-library-definition-name definition-entry)
      (car definition-entry))

    (define (runtime-library-definition definition-entry)
      (cadr definition-entry))

    (define (runtime-library-table library-entry)
      (caddr library-entry))

    (define (runtime-library-table-entry library-table name)
      (assq name library-table))

    (define (runtime-entry-name entry)
      (car entry))

    (define (runtime-entry-exported-name entry)
      (cadr entry))

    (define (runtime-entry-definition-generator entry)
      (caddr entry))

    (define (error-unknown-library library)
      (error "Unknown runtime library" library))

    (define (compile-runtime-library-definitions library program)
      (let ((library-entry
             (cond ((runtime-library-entry library))
                   (else (error-unknown-library library)))))
        (fold
         (lambda (definition-entry program)
           (add-runtime-definition
            program
            library
            (runtime-library-definition-name definition-entry)
            #f
            (runtime-library-definition definition-entry)))
         program
         (runtime-library-definitions library-entry))))

    (define (compile-runtime-library library program)
      (let ((library-entry
             (cond ((runtime-library-entry library))
                   (else (error-unknown-library library)))))
        (fold
         (lambda (entry program)
           (add-runtime-definition
            program
            library
            (runtime-entry-name entry)
            (runtime-entry-exported-name entry)
            ((runtime-entry-definition-generator entry)
             (lambda (library/name)
               (let ((library (if (pair? library/name)
                                  (car library/name)
                                  library))
                     (name (if (pair? library/name)
                               (cadr library/name)
                               library/name)))
                 (or
                  (lookup-runtime-index
                   program
                   library
                   name)
                  (error "Unknown runtime symbol"
                         (list library
                               (runtime-entry-name entry)
                               library/name))))))))
         program
         (runtime-library-table library-entry))))

    (define (runtime-exports program library)
      (reverse
       (fold
        (lambda (definition exports)
          (let ((properties (cadr definition)))
            (cond ((and (equal? library (properties-library properties))
                        (properties-exported-name properties))
                   => (lambda (exported-name)
                        (cons (cons exported-name
                                    (properties-definition-index properties))
                              exports)))
                  (else exports))))
        '()
        (compiled-program-get-definitions program 'runtime-index))))

    (define-record-type runtime-index-properties
      (make-runtime-index-properties library name exported-name definition-index)
      runtime-index-properties?
      (library properties-library)
      (name properties-name)
      (exported-name properties-exported-name)
      (definition-index properties-definition-index))

    (define (lookup-runtime-index program library name)
      (cond
       ((lookup-definition
         (compiled-program-module-definitions program)
         (lambda (def)
           (and (eq? (car def) 'runtime-index)
                (equal? library (properties-library (cadr def)))
                (eq? name (properties-name (cadr def)))))) => (lambda (def)
                                                                (properties-definition-index (cadr def))))
       (else #f)))

    (define (add-runtime-definition program library name exported-name definition)
      (if (lookup-runtime-index program library name)
          program
          (let* ((program
                  (compiled-program-add-definition
                   program
                   definition))
                 (definition-index
                   (- (compiled-program-definitions-count
                       program
                       (wasm-definition-type definition))
                      1)))
            (compiled-program-add-definition
             program
             (list 'runtime-index
                   (make-runtime-index-properties
                    library name exported-name definition-index))))))
    ))
