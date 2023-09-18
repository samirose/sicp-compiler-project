(import
 (scheme base)
 (compiled-program)
 (assert))

(let ((cp (make-empty-compiled-program)))

  (assert-equal
   '()
   (compiled-program-get-definitions cp 'func)
   "Empty compiled program does not contain function definitions")

  (assert-equal
   '()
   (compiled-program-value-code cp)
   "Empty compiled program does not have value code")

  (let ((cp (compiled-program-add-definition
             cp
             '(global (mut i32) (i32.const 42)))))

    (assert-equal
     #t
     (compiled-program-contains-definition cp '(global (mut i32) (i32.const 42)))
     "Compiled program contains definition added to it")

    (let ((cp (compiled-program-with-value-code
               cp
               '(i32.const 53 global.set 0))))

      (assert-equal
       '(i32.const 53 global.set 0)
       (compiled-program-value-code cp)
       "compiled-program-with-value-code sets the value code of the program")

    (assert-equal
     #t
     (compiled-program-contains-definition cp '(global (mut i32) (i32.const 42)))
     "compiled-program-with-value-code retains the program definitions")

    (let ((cp (compiled-program-with-value-code
               cp '(drop))))
      (assert-equal
       '(drop)
       (compiled-program-value-code cp)
       "compiled-program-with-value-code overrides existing value code of the program"))

    (let ((cp (compiled-program-append-value-code
               cp
               '(global.get 0 i32.const 1 i32.add))))
      (assert-equal
       '(i32.const 53 global.set 0 global.get 0 i32.const 1 i32.add)
       (compiled-program-value-code cp)
       "compiled-progam-appen-value-code appends new value code to the end of existing code"))

    (let ((cp (compiled-program-append-value-codes
               cp
               (compiled-program-with-definition-and-value-code
                (make-empty-compiled-program)
                '(global (mut i32) (i32.const -1))
                '(global.get 0 i32.const 1 i32.add)))))

      (assert-equal
       #t
       (compiled-program-contains-definition cp '(global (mut i32) (i32.const -1)))
       "compiled-program-append-value-codes takes definitions from the second program given to it")

      (assert-equal
       1
       (length (compiled-program-get-definitions cp 'global))
       "compiled-program-append-value-codes takes definitions from the second program given to it")

      (assert-equal
       '(i32.const 53 global.set 0 global.get 0 i32.const 1 i32.add)
       (compiled-program-value-code cp)
       "compiled-progam-append-value-codes appends value codes of the programs"))

    (let ((cp (compiled-program-with-definition-and-value-code
                cp
                '(func (result i32) (i32.const 53))
                '(global.get 0 call 0 i32.add))))
      (assert-equal
       '(global.get 0 call 0 i32.add)
       (compiled-program-value-code cp)
       "compiled-program-with-definition-and-value-code sets the value code of the program")

      (assert-equal
       '((func (result i32) (i32.const 53)))
       (compiled-program-get-definitions cp 'func)
       "compiled-program-with-definition-and-value-code adds the definition to the program")

      (assert-equal
       '((global (mut i32) (i32.const 42)))
       (compiled-program-get-definitions cp 'global)
       "compiled-program-with-definition-and-value-code retains the program's existing definitions")

      (assert-equal
       '(func (result i32) (i32.const 53))
       (compiled-program-last-definition cp 'func)
       "compiled-program-last-definition returns the last defintion of specified type added to the program")

      (assert-equal
       '(global (mut i32) (i32.const 42))
       (compiled-program-last-definition cp 'global)
       "compiled-program-last-definition returns the last definition of specified type added to the program")

      (assert-equal
       '(func (result i32) (i32.const 53))
       (compiled-program-lookup-definition cp (lambda (d) (eq? (car d) 'func)))
       "compiled-program-lookup-definition returns the last defintion that matches the predicate")

      (assert-equal
       #f
       (compiled-program-lookup-definition cp (lambda (d) #f))
       "compiled-program-lookup-definition returns false when predicate returns false for all definitions"))))

  (let ((cp (compiled-program-with-definitions-and-value-code
             cp
             '((global (i32) i32.const 42) (func (result i32) global.get 1))
             '(call 0))))
    (assert-equal
     '((global (i32) i32.const 42))
     (compiled-program-get-definitions cp 'global)
     "compiled-program-with-definitions-and-value-code adds the definitions to the program")

    (assert-equal
     '((func (result i32) global.get 1))
     (compiled-program-get-definitions cp 'func)
     "compiled-program-with-definitions-and-value-code adds the definitions to the program")

    (assert-equal
     '(call 0)
     (compiled-program-value-code cp)
     "compiled-program-with-definitions-and-value-code sets the value code of the program"))
  )
