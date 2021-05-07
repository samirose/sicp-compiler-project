#!r6rs
(library
 (module-compiler)

 (export compile-r7rs-library-to-wasm-module
         compile-single-exp-to-wasm-module)

 (import (rnrs base)
         (rnrs lists)
         (lists)
         (scheme-syntax)
         (scheme-r7rs-syntax)
         (scheme-libraries)
         (compilation-error)
         (lexical-env)
         (compiled-program)
         (wasm-syntax)
         (pattern-match)
         (expression-compiler))

 ;;;; SCHEME to WAT (WebAssembly Text format) compiler written in R6RS
 ;;;; BASED ON COMPILER FROM SECTION 5.5 OF
 ;;;; STRUCTURE AND INTERPRETATION OF COMPUTER PROGRAMS

 (define (compile-r7rs-library-to-wasm-module exp)
   (if (not (r7rs-library? exp))
       (raise-compilation-error "Invalid R7RS library" exp))
   (check-library-declarations exp)
   (let* ((initial-program (make-empty-compiled-program))
          (library-program (compile-library-to-program exp initial-program)))
     (compile-program-to-module library-program)))

 (define (compile-single-exp-to-wasm-module exp)
   (let ((library
          (if (r7rs-library? exp)
              exp
              (let ((sequence (if (pattern-match? `(begin ,??*) exp) exp `(begin ,exp))))
                `(define-library ,sequence)))))
     (compile-r7rs-library-to-wasm-module library)))

 (define (compile-library-to-program library program)
   (let*
       ((imports
         (library-declarations 'import library))
        (program
         (add-import-definitions imports program))
        (exp-sequence
         (if (library-has-declaration? 'begin library)
             (library-declarations 'begin library)
             (raise-compilation-error "No begin declaration in library" library)))
        (definitions-and-non-definitions
          (partition-list definition? exp-sequence))
        (definitions
          (car definitions-and-non-definitions))
        (non-definitions
          (cdr definitions-and-non-definitions))
        (definition-names
          (map definition-variable definitions))
        (exports
         (library-declarations 'export library))
        (lexical-env
         (make-global-lexical-env definition-names exports))
        (program
         (if (null? definitions)
             program
             (compile-values
              definitions
              program
              lexical-env compile)))
        (global-init-code
         (compiled-program-value-code
          program))
        (program
         (if (null? global-init-code)
             program
             (let ((global-init-func-index
                    (compiled-program-definitions-count program 'func)))
               (compiled-program-with-definitions-and-value-code
                program
                `((func ,@(wasm-local-definitions-to-top global-init-code))
                  (start ,global-init-func-index))
                '()))))
        (program
         (if (null? non-definitions)
             program
             (compile-proc-to-func
              "$main"
              '()
              non-definitions
              program
              lexical-env
              "main"
              compile)))
        (elem-defs-count
         (compiled-program-definitions-count program 'elem))
        (program
         (if (= elem-defs-count 0)
             program
             (compiled-program-add-definition
              program
              `(table ,elem-defs-count funcref)))))
     program))

 (define (compile-program-to-module program)
   (let*
       ((elem-defs
         (compiled-program-get-definitions program 'elem))
        (elem-func-indices
         (map wasm-elem-definition-func-index elem-defs))
        (elems-def
         (if (null? elem-defs)
             '()
             `((elem (i32.const 0) func ,@elem-func-indices))))
        (get-module-definitions
         (lambda (type)
           (compiled-program-get-definitions program type))))
     `(module
        ,@(get-module-definitions 'type)
        ,@(get-module-definitions 'import)
        ,@(get-module-definitions 'func)
        ,@(get-module-definitions 'table)
        ,@(get-module-definitions 'global)
        ,@(get-module-definitions 'export)
        ,@(get-module-definitions 'start)
        ,@elems-def)))

 (define (make-global-lexical-env variables exports)
   (let ((duplicate-var (first-duplicate variables)))
     (if (not (null? duplicate-var))
         (raise-compilation-error "Top-level identifier already defined" (car duplicate-var))))
   (for-each
    (lambda (export)
      (if (not (memq export variables))
          (raise-compilation-error "No top-level definition for export" export)))
    exports)
   (let
       ((additional-info
         (fold-left
          (lambda (info var)
            (if (memq var exports)
                (cons `(,var (export ,(symbol->string var)))
                      info)
                info))
          '()
          variables)))
     (add-new-lexical-frame
      (make-empty-lexical-env)
      variables
      additional-info)))
 )
