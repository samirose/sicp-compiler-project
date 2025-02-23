(define-library (module-compiler)

  (export compile-r7rs-library-to-wasm-module)

  (import (scheme base)
          (lists)
          (scheme-syntax)
          (scheme-r7rs-syntax)
          (scheme-runtime)
          (compilation-error)
          (lexical-env)
          (compiled-program)
          (wasm-syntax)
          (pattern-match)
          (values)
          (expression-compiler)
          (literals-compiler))

 ;;;; SCHEME to WAT (WebAssembly Text format) compiler written in R7RS-small
 ;;;; BASED ON COMPILER FROM SECTION 5.5 OF
 ;;;; STRUCTURE AND INTERPRETATION OF COMPUTER PROGRAMS

  (begin
    (define (compile-r7rs-library-to-wasm-module exp)
      (check-library exp)
      (check-library-declarations exp)
      (let* ((initial-program (make-empty-compiled-program))
             (library-program (compile-library-to-program exp initial-program)))
	(compile-program-to-module library-program)))

    (define (compile-library-to-program library program)
      (let-values
          (((definitions non-definitions)
            (partition definition?
                       (if (library-has-declaration? 'begin library)
		           (library-declarations 'begin library)
		           (raise-compilation-error "No begin declaration in library" library)))))
        (let*
            ((imports
              (library-declarations 'import library))
             (exports
              (library-declarations 'export library))
             ;; Compile runtime library definitions to program
             (program
              (fold compile-runtime-library-definitions program imports))
             ;; Compile runtime library functions to program
             (program
              (fold compile-runtime-library program imports))
             ;; Extract runtime function bindings from program
             (runtime-bindings
              (fold
               (lambda (library bindings)
                 (append
                  (runtime-exports program library)
                  bindings))
               '()
               imports))
             ;; Add runtime function indices to function table
             (program
              (fold
               (lambda (runtime-binding program)
                 (compiled-program-add-definition
                  program
                  `(elem ,(cdr runtime-binding))))
               program
               runtime-bindings))
             (definition-names
               (map definition-variable definitions))
             ;; Create global lexical environment
             (lexical-env
              (make-global-lexical-env
               (append
                ;; Create unbound slots for globals from runtime imports
                (make-list (compiled-program-definitions-count program 'global) #f)
                (map car runtime-bindings))
               definition-names
               exports))
             ;; Add global function values for runtime functions
             (program
              (do ((bindings runtime-bindings (cdr bindings))
                   (elem-index 0 (+ elem-index 1))
                   (program program (compiled-program-add-definition
                                     program
                                     `(global i32 (i32.const ,(funcidx->procedure-value elem-index))))))
                  ((null? bindings) program)))
             ;; Add export definitions for exported runtime functions
             (program
              (fold
               (lambda (runtime-binding program)
                 (if (and (memq (car runtime-binding) exports)
                          (not (memq (car runtime-binding) definition-names)))
                     (compiled-program-add-definition
                      program
                      `(export
                        ,(symbol->string (car runtime-binding))
                        (func ,(cdr runtime-binding))))
                     program))
               program
               runtime-bindings))
             ;; Add globals for top-level variables
             (program
              (compiled-program-with-definitions-and-value-code
               program
               (make-list (length definitions)
			  `(global (mut i32) (i32.const ,uninitialized-value)))
               '()))
             ;; Compile top-level code and globals initialisation
             (program
              (let*
                  ((definitions-init-assignments
                     (map (lambda (definition)
                            `(set! ,(definition-variable definition) ,(definition-value definition)))
		          definitions))
                   (non-definitions
                    (append definitions-init-assignments non-definitions)))
                (if (null? non-definitions)
		    program
		    (let* ((program
			    (compile-sequence non-definitions program lexical-env compile))
                           (global-init-code
			    (compiled-program-value-code program))
                           (global-init-func-index
			    (compiled-program-definitions-count program 'func)))
		      (compiled-program-with-definitions-and-value-code
                       program
                       `((func
                          ,@(wasm-local-definitions-to-top global-init-code)
                          drop)
                         (start ,global-init-func-index))
                       '())))))
             ;; Add function table definition
             (program
              (let ((elem-defs-count
                     (compiled-program-definitions-count program 'elem)))
                (if (= elem-defs-count 0)
		    program
		    (compiled-program-add-definition
		     program
		     `(table ,elem-defs-count funcref))))))
	  program)))

    (define (compile-program-to-module program)
      (let*
          ((get-module-definitions
            (lambda (type)
              (compiled-program-get-definitions program type)))
           (elem-definition
            (let ((elem-func-indices
                   (map wasm-elem-definition-func-index
                        (get-module-definitions 'elem))))
              (if (null? elem-func-indices)
		  '()
		  `((elem (i32.const 0) func ,@elem-func-indices))))))
        (let-values
            (((global-imports global-definitions)
              (partition wasm-import-definition?
                         (get-module-definitions 'global)))
             ((func-imports func-definitions)
              (partition wasm-import-definition?
                         (get-module-definitions 'func))))
          `(module
            ,@(get-module-definitions 'type)
            ,@global-imports
            ,@func-imports
            ,@func-definitions
            ,@(get-module-definitions 'table)
            ,@(get-module-definitions 'memory)
            ,@global-definitions
            ,@(get-module-definitions 'export)
            ,@(get-module-definitions 'start)
            ,@elem-definition
            ,@(literal-data-definitions program)))))

    (define (make-global-lexical-env imported-identifiers defined-variables exports)
      (let ((duplicate-import (first-duplicate (filter symbol? imported-identifiers))))
	(unless (null? duplicate-import)
          (raise-compilation-error "Duplicate imported identifier" (car duplicate-import))))
      (let ((duplicate-var (first-duplicate (filter symbol? defined-variables))))
	(unless (null? duplicate-var)
          (raise-compilation-error "Top-level identifier already defined" (car duplicate-var))))
      (let ((variables (append imported-identifiers defined-variables)))
	(for-each
	 (lambda (export)
           (unless (memq export variables)
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
              (fold
               (lambda (var info)
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
    ))
