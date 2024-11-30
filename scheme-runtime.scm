(define-library (scheme-runtime)

  (export is-runtime-library
          compile-runtime-library
          runtime-exports
          lookup-runtime-index)

  (import (scheme base)
          (scheme cxr)
          (lists)
          (values)
          (definitions-table)
          (compiled-program)
          (wasm-syntax)
          (compilation-error))

  (begin
    (define (macro-raise-error runtime-index)
      `(global.set ,(runtime-index '$error-code)
        unreachable))

    (define macro-is-not-heap-obj
      `(i32.const ,immediate-value-mask
        i32.and))

    (define macro-is-heap-obj
      `(,@macro-is-not-heap-obj
        i32.eqz))

    (define (macro-is-heap-obj-type heap-obj-type)
      `(i32.const ,heap-object-type-mask
        i32.and
        i32.const ,heap-obj-type
        i32.eq))

    (define scheme-base-definitions
      '((memory (export "$heap") 1)))

    (define scheme-base-code-table
      `(($error-code
         #f
         ,(lambda (runtime-index)
            `(global (mut i32) (i32.const ,error-no-error))))
        ($get-error-code
         #f
         ,(lambda (runtime-index)
            (let ((error-code-index (runtime-index '$error-code)))
              `(func (export "get-error-code") (result i32)
                     global.get ,error-code-index
                     i32.const ,error-no-error
                     global.set ,error-code-index))))
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
                   ,@(macro-raise-error runtime-index)
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
        ($funcidx->procedure
         #f
         ,(lambda (runtime-index)
            `(func (param $funcidx i32) (result i32)
                   local.get $funcidx
                   i32.const ,immediate-shift
                   i32.shl
                   i32.const ,procedure-tag
                   i32.or)))
        ($check-procedure
         #f
         ,(lambda (runtime-index)
            `(func (param $obj i32) (result i32)
                   local.get $obj
                   local.get $obj
                   i32.const ,immediate-mask
                   i32.and
                   i32.const ,procedure-tag
                   i32.ne
                   if
                   i32.const ,error-expected-procedure
                   ,@(macro-raise-error runtime-index)
                   end)))
        ($procedure->funcidx
         #f
         ,(lambda (runtime-index)
            `(func (param $obj i32) (result i32)
                   local.get $obj
                   call ,(runtime-index '$check-procedure)
                   i32.const ,immediate-shift
                   i32.shr_u)))
        ($number?
         number?
         ,(lambda (runtime-index)
            `(func (param $obj i32) (result i32)
                   local.get $obj
                   i32.const ,fixnum-mask
                   i32.and
                   call ,(runtime-index '$i32->boolean))))
        ($zero?
         zero?
         ,(lambda (runtime-index)
            `(func (param $obj i32) (result i32)
                   local.get $obj
                   call ,(runtime-index '$fixnum->i32)
                   i32.eqz
                   call ,(runtime-index '$i32->boolean))))
        ($boolean?
         boolean?
         ,(lambda (runtime-index)
            `(func (param $obj i32) (result i32)
                   local.get $obj
                   i32.const ,immediate-mask
                   i32.and
                   i32.const ,boolean-tag
                   i32.eq
                   call ,(runtime-index '$i32->boolean))))
        ($procedure?
         procedure?
         ,(lambda (runtime-index)
            `(func (param $obj i32) (result i32)
                   local.get $obj
                   i32.const ,immediate-mask
                   i32.and
                   i32.const ,procedure-tag
                   i32.eq
                   call ,(runtime-index '$i32->boolean))))
        ($symbol?
         symbol?
         ,(lambda (runtime-index)
            `(func (param $obj i32) (result i32)
                   local.get $obj
                   ,@macro-is-heap-obj
                   if (result i32)
                   local.get $obj
                   i32.load
                   ,@(macro-is-heap-obj-type heap-object-type-symbol)
                   call ,(runtime-index '$i32->boolean)
                   else
                   i32.const ,false-value
                   end)))
        ($string?
         string?
         ,(lambda (runtime-index)
            `(func (param $obj i32) (result i32)
                   local.get $obj
                   ,@macro-is-heap-obj
                   if (result i32)
                   local.get $obj
                   i32.load
                   ,@(macro-is-heap-obj-type heap-object-type-string)
                   call ,(runtime-index '$i32->boolean)
                   else
                   i32.const ,false-value
                   end)))
        ($eq?
         eq?
         ,(lambda (runtime-index)
            `(func (param $obj1 i32) (param $obj2 i32) (result i32)
                   local.get $obj1
                   local.get $obj2
                   i32.eq
                   call ,(runtime-index '$i32->boolean))))
        ($eqv?
         eqv?
         ,(lambda (runtime-index)
            `(func (param $obj1 i32) (param $obj2 i32) (result i32)
                   local.get $obj1
                   local.get $obj2
                   call ,(runtime-index '$eq?))))
        ($check-heap-obj-type
         #f
         ,(lambda (runtime-index)
            ;; Checks that $obj is a heap object of type $type.
            ;; Returns $obj on success or raises error $error.
            `(func (param $obj i32)
                   (param $type i32)
                   (param $error i32)
                   (result i32)
                   block $error
                   local.get $obj
                   ,@macro-is-not-heap-obj
                   br_if $error
                   local.get $obj
                   i32.load
                   i32.const ,heap-object-type-mask
                   i32.and
                   local.get $type
                   i32.ne
                   br_if $error
                   local.get $obj
                   return
                   end
                   local.get $error
                   ,@(macro-raise-error runtime-index))))
        ($check-symbol-type
         #f
         ,(lambda (runtime-index)
            ;; Returns $obj if it is of symbol type.
            ;; Raises error-expected-symbol otherwise.
            `(func (param $obj i32) (result i32)
                   local.get $obj
                   i32.const ,heap-object-type-symbol
                   i32.const ,error-expected-symbol
                   call ,(runtime-index '$check-heap-obj-type))))
        ($symbol=?
         symbol=?
         ,(lambda (runtime-index)
            `(func (param $s1 i32) (param $s2 i32) (result i32)
                   local.get $s1
                   call ,(runtime-index '$check-symbol-type)
                   local.get $s2
                   call ,(runtime-index '$check-symbol-type)
                   i32.eq
                   call ,(runtime-index '$i32->boolean))))
        ($check-heap-obj
         #f
         ,(lambda (runtime-index)
            ;; Checks that $obj is a heap object of type $type.
            ;; Returns the header of the heap object on success or raises $error.
            `(func (param $obj i32)
                   (param $type i32)
                   (param $error i32)
                   (result i32)
                   (local $heap-obj i32)
                   block $error
                   local.get $obj
                   ,@macro-is-not-heap-obj
                   br_if $error
                   local.get $obj
                   i32.load
                   local.tee $heap-obj
                   i32.const ,heap-object-type-mask
                   i32.and
                   local.get $type
                   i32.ne
                   br_if $error
                   local.get $heap-obj
                   return
                   end
                   local.get $error
                   ,@(macro-raise-error runtime-index))))
        ($check-string
         #f
         ,(lambda (runtime-index)
            ;; Returns heap object header pointed by $obj if it is a heap object of type string.
            ;; Raises error-expected-string otherwise.
            `(func (param $obj i32) (result i32)
                   local.get $obj
                   i32.const ,heap-object-type-string
                   i32.const ,error-expected-string
                   call ,(runtime-index '$check-heap-obj))))
        ($equal-words
         #f
         ,(lambda (runtime-index)
            `(func (param $addr1 i32) (param $addr2 i32) (param $n i32) (result i32)
                   block $equal_contents
                   block $compare_words
                   loop $loop
                   local.get $n
                   i32.eqz
                   br_if $compare_words
                   local.get $addr1
                   i32.load
                   local.get $addr1
                   i32.const ,i32-size
                   i32.add
                   local.set $addr1
                   local.get $addr2
                   i32.load
                   local.get $addr2
                   i32.const ,i32-size
                   i32.add
                   local.set $addr2
                   local.get $n
                   i32.const 1
                   i32.sub
                   local.set $n
                   i32.eq
                   br_if $loop
                   br $equal_contents
                   end
                   end
                   i32.const 1
                   return
                   end
                   i32.const 0)))
        ($string=?
         string=?
         ,(lambda (runtime-index)
            `(func (param $s1 i32) (param $s2 i32) (result i32)
                   (local $len i32)
                   local.get $s1
                   call ,(runtime-index '$check-string)
                   i32.const ,heap-object-size-mask
                   i32.and
                   local.tee $len
                   local.get $s2
                   call ,(runtime-index '$check-string)
                   i32.const ,heap-object-size-mask
                   i32.and
                   i32.eq
                   if (result i32)
                   local.get $s1
                   i32.const ,heap-object-header-size
                   i32.add
                   local.get $s2
                   i32.const ,heap-object-header-size
                   i32.add
                   local.get $len
                   ,@(macro-align-heap-address)
                   call ,(runtime-index '$equal-words)
                   call ,(runtime-index '$i32->boolean)
                   else
                   i32.const ,false-value
                   end)))
        ))

    (define runtime-libraries-table
      (list (list '(scheme base) scheme-base-definitions scheme-base-code-table)))

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
