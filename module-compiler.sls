#!r6rs
(library
 (module-compiler)

 (export compile-r7rs-library-to-wasm-module)

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

 (define (compile-library-to-program library program)
   (let*
       ((imports
         (library-declarations 'import library))
        (import-definitions (import-definitions imports))
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
        (global-imports
         (filter (lambda (import-def) (eq? (import-type import-def) 'global))
                 import-definitions))
        (global-import-bindings
         (map import-binding global-imports))
        (func-imports
         (filter (lambda (import-def) (eq? (import-type import-def) 'func))
                 import-definitions))
        (func-import-bindings
         (filter (lambda (b) b) (map import-binding func-imports)))
        (import-bindings
         (append global-import-bindings func-import-bindings))
        (lexical-env
         (make-global-lexical-env import-bindings definition-names exports))
        (program
         (compiled-program-with-definitions-and-value-code
          program
          (map import-definition import-definitions)
          '()))
        (bound-import-func-definitions
         (let loop ((func-imports func-imports)
                    (func-index 0)
                    (definitions '()))
           (let ((next
                  (lambda (definitions)
                    (loop (cdr func-imports) (+ func-index 1) definitions))))
             (cond ((null? func-imports) (reverse definitions))
                   ((import-binding (car func-imports))
                    => (lambda (binding)
                         (let ((definitions
                                 (cons `(elem ,func-index) definitions))
                               (next
                                (lambda (definitions)
                                  (loop (cdr func-imports) (+ func-index 1) definitions))))
                           (if (and (memq binding exports) (not (memq binding definition-names)))
                               (next (cons `(export ,(symbol->string binding) (func ,func-index)) definitions))
                               (next definitions)))))
                   (else (next definitions))))))
        (program
         (compiled-program-with-definitions-and-value-code
          program
          bound-import-func-definitions
          '()))
        (program
         (compiled-program-with-definitions-and-value-code
          program
          (make-list `(global (mut i32) ,uninitialized-value)
                     (+ (length func-import-bindings) (length definitions)))
          '()))
        (imported-func-values-init-code
         (let loop ((bindings func-import-bindings)
                    (elem-index 0)
                    (global-index (length global-import-bindings))
                    (init-code '()))
           (cond ((null? bindings) (reverse init-code))
                 (else
                  (loop (cdr bindings)
                        (+ elem-index 1)
                        (+ global-index 1)
                        (cons `(global.set ,global-index (i32.const ,elem-index))
                              init-code))))))
        (globals-init-assignments
         (map (lambda (definition)
                `(set! ,(definition-variable definition) ,(definition-value definition)))
              definitions))
        (non-definitions
         (append globals-init-assignments non-definitions))
        (program
         (if (null? non-definitions)
             program
             (let* ((program
                     (compile-sequence non-definitions program lexical-env compile))
                    (global-init-code
                     (append
                      imported-func-values-init-code
                      (compiled-program-value-code program)))
                    (global-init-func-index
                     (compiled-program-definitions-count program 'func)))
               (compiled-program-with-definitions-and-value-code
                program
                `((func
                   ,@(wasm-local-definitions-to-top global-init-code)
                   drop)
                  (start ,global-init-func-index))
                '()))))
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
           (compiled-program-get-definitions program type)))
        (not-import-definition?
         (lambda (def) (not (wasm-import-definition? def))))
        (imported-globals
         (filter wasm-import-definition? (get-module-definitions 'global)))
        (module-globals
         (filter not-import-definition? (get-module-definitions 'global)))
        (imported-funcs
         (filter wasm-import-definition? (get-module-definitions 'func)))
        (module-funcs
         (filter not-import-definition? (get-module-definitions 'func))))
     `(module
        ,@(get-module-definitions 'type)
        ,@(get-module-definitions 'import)
        ,@imported-globals
        ,@imported-funcs
        ,@module-globals
        ,@module-funcs
        ,@(get-module-definitions 'table)
        ,@(get-module-definitions 'export)
        ,@(get-module-definitions 'start)
        ,@elems-def)))

 (define (make-global-lexical-env imported-identifiers defined-variables exports)
   (let ((duplicate-import (first-duplicate (filter symbol? imported-identifiers))))
     (if (not (null? duplicate-import))
         (raise-compilation-error "Duplicate imported identifier" (car duplicate-import))))
   (let ((duplicate-var (first-duplicate (filter symbol? defined-variables))))
     (if (not (null? duplicate-var))
         (raise-compilation-error "Top-level identifier already defined" (car duplicate-var))))
   (let ((variables (append imported-identifiers defined-variables)))
     (for-each
      (lambda (export)
        (if (not (memq export variables))
            (raise-compilation-error "No top-level definition for export" export)))
      exports)
     (let*
         ((import-variables
           (filter (lambda (imported-identifier) (not (memq imported-identifier defined-variables)))
                   imported-identifiers))
          (additional-info
           (map (lambda (import-variable) `(,import-variable import))
                import-variables))
          (additional-info
           (fold-left
            (lambda (info var)
              (if (memq var exports)
                  (cons `(,var (export ,(symbol->string var)))
                        info)
                  info))
            additional-info
            variables)))
       (add-new-top-level-frame
        (make-empty-lexical-env)
        0
        variables
        additional-info))))
 )
