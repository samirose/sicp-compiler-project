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
         (compilation-error)
         (lexical-env)
         (compiled-program)
         (wasm-module-definitions)
         (wasm-syntax)
         (expression-compiler))

 ;;;; SCHEME to WAT (WebAssembly Text format) compiler written in R6RS
 ;;;; BASED ON COMPILER FROM SECTION 5.5 OF
 ;;;; STRUCTURE AND INTERPRETATION OF COMPUTER PROGRAMS

 (define (compile-r7rs-library-to-wasm-module exp)
   (if (not (r7rs-library? exp))
       (raise-compilation-error "Invalid R7RS library" exp))
   (raise-if-error (check-library-declarations exp))
   (compile-program-to-module (compile-library-to-program exp)))

 (define (compile-single-exp-to-wasm-module exp)
   (let ((library
          (if (r7rs-library? exp)
              exp
              (let ((sequence (if (begin? exp) exp `(begin ,exp))))
                `(define-library ,sequence)))))
     (compile-r7rs-library-to-wasm-module library)))

 (define (compile-library-to-program library)
   (let*
       ((exp-sequence
         (let* ((exps
                 (or (library-declaration 'begin library)
                     (raise-compilation-error "No begin declaration in library" library)))
                (actions (begin-actions exps)))
           (if (null? actions)
               (raise-compilation-error "Empty begin declaration in library" library)
               actions)))
        (definitions
          (filter definition? exp-sequence))
        (non-definitions
          (reject definition? exp-sequence))
        (definition-names
          (map definition-variable definitions))
        (exports
         (library-declarations 'export library))
        (lexical-env
         (make-global-lexical-env definition-names exports))
        (definitions-program
            (if (null? definitions)
                (make-empty-compiled-program)
                (compile-sequence
                 definitions
                 (make-empty-compiled-program)
                 lexical-env compile))))
     (if (null? non-definitions)
         definitions-program
         (compile-sequence
          non-definitions
          definitions-program
          lexical-env compile))))

 (define (compile-program-to-module program)
   (let*
       ((get-module-definitions
         (let ((module-definitions
                (compiled-program-module-definitions program)))
           (lambda (type)
             (wasm-module-get-definitions
              module-definitions
              type))))
        (elem-defs
         (get-module-definitions 'elem))
        (elem-func-indices
         (map wasm-elem-definition-func-index elem-defs))
        (table-definition
         (if (null? elem-func-indices)
             '()
             `((table ,(length elem-func-indices) funcref))))
        (elem-definition
         (if (null? elem-func-indices)
             '()
             `((elem (i32.const 0) func ,@elem-func-indices))))
        (global-init-defs
         (map cdr (get-module-definitions 'global-init)))
        (global-init-func
         (if (null? global-init-defs)
             '()
             `((func $global-init
                     ,@(flatten-n 2 global-init-defs))
               (start $global-init))))
        (top-level-code
         (compiled-program-value-code program)))
     `(module
        ,@(get-module-definitions 'type)
        ,@(get-module-definitions 'func)
        (func $main (result i32)
              ,@top-level-code)
        ,@table-definition
        ,@(get-module-definitions 'global)
        ,@global-init-func
        (export "main" (func $main))
        ,@elem-definition
        ,@(get-module-definitions 'export))))

 (define (make-global-lexical-env variables exports)
   (let ((duplicate-var (first-duplicate variables)))
     (if (not (null? duplicate-var))
         (raise-compilation-error "Top-level identifier already defined" (car duplicate-var))))
   (for-each
    (lambda (export)
      (if (not (memq export variables))
          (raise-compilation-error "No top-level definition for export" export)))
    exports)
   (add-new-lexical-frame
    (make-empty-lexical-env)
    (make-lexical-frame
     variables
     (fold-left
      (lambda (additional-info var)
        (if (memq var exports)
            (cons `(,var (export ,(symbol->string var)))
                  additional-info)
            additional-info))
      '()
      variables))))

 )
