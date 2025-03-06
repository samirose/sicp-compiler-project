(define-library (literals-compiler)

  (export
   compile-literal-symbol
   compile-literal-string
   literal-data-definitions)

  (import
   (scheme base)
   (scheme cxr)
   (srfi srfi-60)
   (lists)
   (values)
   (wasm-syntax)
   (compiled-program)
   (runtime-memory))

  (begin
    (define (align-address address alignment)
      (* (quotient (+ address (- alignment 1)) alignment)
         alignment))

    (define (next-literal-address program alignment)
      (align-address
       (cond ((compiled-program-last-definition
               program
               'literal-data-definition)
              => (lambda (def)
                   (+ (literal-data-attribute-value 'address def)
                      (literal-data-attribute-value 'length def))))
             (else literal-memory-start-address))
       alignment))

    (define (compile-literal-symbol symbol program)
      (cond ((let ((symbol-def
                    (compiled-program-lookup-definition
                     program
                     (lambda (def)
                       (and (literal-data-definition? def)
                            (eq? (literal-data-attribute-value 'symbol def) symbol))))))
               (and symbol-def
                    (literal-data-attribute-value 'address symbol-def)))
             => (lambda (address)
                  (compiled-program-with-value-code
                   program
                   `(i32.const ,address))))
            (else
             (let*-values
                 (((symbol-data symbol-data-length)
                   (string-as-wasm-data (symbol->string symbol)))
                  ((symbol-header-data symbol-header-length)
                   (i32-as-wasm-data (symbol-literal-header symbol-data-length))))
               (let ((address (next-literal-address program 4)))
                 (compiled-program-with-definition-and-value-code
                  program
                  (literal-data-definition
                   `((symbol . ,symbol)
                     (address . ,address)
                     (length . ,(+ symbol-header-length symbol-data-length)))
                   (list symbol-header-data symbol-data))
                  `(i32.const ,address)))))))

    (define (compile-literal-string string program)
      (let*-values
          (((string-data string-data-length)
            (string-as-wasm-data string))
           ((string-header-data string-header-length)
            (i32-as-wasm-data (string-literal-header string-data-length))))
        (let ((address (next-literal-address program 4)))
          (compiled-program-with-definition-and-value-code
           program
           (literal-data-definition
            `((address . ,address)
              (length . ,(+ string-header-length string-data-length)))
            (list string-header-data string-data))
           `(i32.const ,address)))))

    (define (literal-data-definition? exp)
      (eq? (car exp) 'literal-data-definition))

    (define (literal-data-attributes exp)
      (cadr exp))

    (define (literal-data-attribute-value attr exp)
      (cond ((assq attr (literal-data-attributes exp)) => cdr)
            (else #f)))

    (define (literal-data-values exp)
      (cddr exp))

    (define (literal-data-definition attributes values)
      `(literal-data-definition ,attributes ,@values))

    (define (last-literal-data-address program)
      (compiled-program-fold-definitions
       program
       (lambda (def max-address)
         (if (literal-data-definition? def)
             (let ((last-address
                    (+ (literal-data-attribute-value 'address def)
                       (literal-data-attribute-value 'length def))))
               (if (> last-address max-address)
                   last-address
                   max-address))
             max-address))
       literal-memory-start-address))

    (define (literal-data-definitions program)
      (let-values
          (((first-heap-address-data _)
            (i32-as-wasm-data (align-address (last-literal-data-address program) 4))))
        (cons
         `(data (i32.const ,heap-memory-start-vector) ,first-heap-address-data)
         (compiled-program-flatmap-definitions
          program
          (lambda (def)
            (if (literal-data-definition? def)
                `((data
                   (i32.const ,(literal-data-attribute-value 'address def))
                   ,@(literal-data-values def)))
                '()))))))
    )
  )
