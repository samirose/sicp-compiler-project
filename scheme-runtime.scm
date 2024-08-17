;;(define-library (scheme-runtime)

(import (scheme base)
        (scheme cxr)
        (lists)
        (values)
        (definitions-table)
        (compiled-program)
        (wasm-syntax)
        (compilation-error))

(begin
  (define scheme-base-code-table
    `(($error-code
       #f
       ,(lambda (runtime-index)
          `(global (mut i32) (i32.const ,error-no-error))))
      ($get-error-code
       #f
       ,(lambda (runtime-index)
          (let ((error-code-index (runtime-index '$error-code)))
            `(func (result i32)
                   global.get ,error-code-index
                   i32.const ,error-no-error
                   global.set ,error-code-index))))
      ($raise-error
       #f
       ,(lambda (runtime-index)
          `(func (param $error i32)
                 local.get $error
                 global.set ,(runtime-index '$error-code)
                 unreachable)))
      ($i32->fixnum
       #f
       ,(lambda (runtime-index)
          `(func (param $value i32) (result i32)
                 local.get $value
                 i32.const ,fixnum-shift
                 i32.shl
                 i32.const ,fixnum-mask
                 i32.or)))
      ($check-fixnum
       #f
       ,(lambda (runtime-index)
          `(func (param $obj i32) (result i32)
                 local.get $obj
                 local.get $obj
                 i32.const ,fixnum-mask
                 i32.and
                 i32.const ,fixnum-mask
                 i32.ne
                 if
                 i32.const ,error-expected-number
                 call ,(runtime-index '$raise-error)
                 end)))

      ($fixnum->i32
       #f
       ,(lambda (runtime-index)
          `(func (param $obj i32) (result i32)
                 local.get $obj
                 call ,(runtime-index '$check-fixnum)
                 i32.const ,fixnum-shift
                 i32.shr_s)))
      ($i32->boolean
       #f
       ,(lambda (runtime-index)
          `(func (param $value i32) (result i32)
                 i32.const ,true-value
                 i32.const ,false-value
                 local.get $value
                 select)))
      ($boolean->i32
       #f
       ,(lambda (runtime-index)
          `(func (param $obj i32) (result i32)
                 i32.const 0
                 i32.const 1
                 local.get $obj
                 i32.const ,false-value
                 i32.eq
                 select)))
      ))

  (define runtime-libraries-table
    (list (cons '(scheme base) scheme-base-code-table)))

  (define (runtime-library-table library)
    (assoc library runtime-libraries-table))

  (define (runtime-library-table-entry code-table name)
    (assq name code-table))

  (define (runtime-entry-name entry)
    (car entry))

  (define (runtime-entry-exported-name entry)
    (cadr entry))

  (define (runtime-entry-definition-generator entry)
    (caddr entry))

  (define (definition-dependencies code-table entry)
    (let immediate-dependencies ((current-entry entry))
      (let ((entry-dependencies '()))
        ((runtime-entry-definition-generator current-entry)
         (lambda (dependency-name)
           (cond
            ((assq dependency-name code-table) =>
             (lambda (dependency-entry)
               (unless (memq dependency-entry entry-dependencies)
                 (set! entry-dependencies (cons dependency-entry entry-dependencies)))))
            (else (error "Unknown runtime dependency" dependency-name)))))
        (fold
         (lambda (dependency-entry dependencies)
           (if (eq? dependency-entry entry)
               (error "Dependency cycle detected" entry))
           (append (immediate-dependencies dependency-entry) dependencies))
         entry-dependencies
         entry-dependencies))))

  (define (lookup-runtime-index program library name)
    (cond
     ((lookup-definition
       (compiled-program-module-definitions program)
       (lambda (def)
         (and (eq? (car def) 'runtime-index)
              (equal? (cadr def) library)
              (eq? (caddr def) name)))) => cadddr)
     (else #f)))

  (define (add-runtime-definition program library name definition)
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
           (list 'runtime-index library name definition-index)))))

  (define (compile-runtime-call program library name)
    (let ((index (lookup-runtime-index program library name)))
      (if index
          (compiled-program-append-value-code
           program
           `(call ,index))
          (let* ((code-table (or (runtime-library-table library)
                                 (raise-compilation-error "Unknown library" library)))
                 (entry (or (runtime-library-table-entry code-table name)
                            (raise-compilation-error "Unknown procedure" (list library name))))
                 (dependencies (definition-dependencies code-table entry))
                 (program
                  (fold (lambda (e p)
                          (add-runtime-definition
                           p
                           library
                           (runtime-entry-name e)
                           ((runtime-entry-definition-generator e)
                            (lambda (n) (lookup-runtime-index p library n)))))
                        program
                        dependencies)))
            (add-runtime-definition
             program
             library
             name
             ((runtime-entry-definition-generator entry)
              (lambda (n) (lookup-runtime-index program library n))))))))

  )
;;)
