(define-library (scheme-runtime)

  (export is-runtime-library
          compile-runtime-library
          runtime-exports
          lookup-runtime-index)

  (import (scheme base)
          (scheme cxr)
          (lists)
          (definitions-table)
          (compiled-program)
          (wasm-syntax))

  (import (prefix (scheme-runtime-base) scheme-base-))

  (begin
    (define runtime-libraries-table
      `(((scheme base) ,scheme-base-definitions ,scheme-base-code-table)))

    (define (runtime-library-entry library)
      (assoc library runtime-libraries-table))

    (define (is-runtime-library library)
      (cond ((runtime-library-entry library) #t)
            (else #f)))

    (define (runtime-library-definitions library-entry)
      (cadr library-entry))

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

    (define (compile-runtime-library library program)
      (let* ((library-entry
              (cond ((runtime-library-entry library))
                    (else (error "Unknown runtime library" library))))
             (program
              (fold
               (lambda (definition program)
                 (compiled-program-add-definition
                  program
                  definition))
               program
               (runtime-library-definitions library-entry))))
        (fold
         (lambda (entry program)
           (add-runtime-definition
            program
            library
            (runtime-entry-name entry)
            (runtime-entry-exported-name entry)
            ((runtime-entry-definition-generator entry)
             (lambda (name)
               (lookup-runtime-index program library name)))))
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
