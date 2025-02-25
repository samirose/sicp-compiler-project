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
             (let* ((address (next-literal-address program 4))
                    (symbol-string (symbol->string symbol))
                    (symbol-data-value (string-as-wasm-data symbol-string))
                    (symbol-length (cdr symbol-data-value))
                    (symbol-header-value
                     (i32-as-wasm-data (symbol-literal-header symbol-length)))
                    (symbol-header-length (cdr symbol-header-value))
                    (symbol-data-length (+ symbol-header-length symbol-length))
                    (symbol-data-values
                     (list (car symbol-header-value) (car symbol-data-value)))
                    (symbol-data-definition
                     (literal-data-definition
                      `((symbol . ,symbol)
                        (address . ,address)
                        (length . ,symbol-data-length))
                      symbol-data-values)))
               (compiled-program-with-definition-and-value-code
                program
                symbol-data-definition
                `(i32.const ,address))))))

    (define (compile-literal-string string program)
      (let* ((address (next-literal-address program 4))
             (string-data-value (string-as-wasm-data string))
             (string-length (cdr string-data-value))
             (string-header-value
              (i32-as-wasm-data (string-literal-header string-length)))
             (string-header-length (cdr string-header-value))
             (string-data-length (+ string-header-length string-length))
             (string-data-values
              (list (car string-header-value) (car string-data-value)))
             (string-data-definition
              (literal-data-definition
               `((address . ,address)
                 (length . ,string-data-length))
               string-data-values)))
        (compiled-program-with-definition-and-value-code
         program
         string-data-definition
         `(i32.const ,address))))

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
      (let ((first-heap-address
             (align-address (last-literal-data-address program) 4)))
        (cons
         `(data (i32.const ,heap-memory-start-vector)
                ,(car (i32-as-wasm-data first-heap-address)))
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
