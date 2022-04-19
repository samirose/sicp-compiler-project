(import
 (scheme base)
 (definitions-table)
 (assert))

(let ((ds (make-empty-definitions-table)))

  (assert-equal
   0
   (definitions-count ds 'func)
   "Empty definitions table contains 0 func defintions")

  (assert-equal
   #f
   (definition-index ds '(func $f (result i32)))
   "Empty definitions table does not have index for a func definition")

  (assert-equal
   #f
   (contains-definition ds '())
   "Empty definitions table does not contain an empty definition")

  (assert-equal
   '()
   (get-definitions ds 'func)
   "Empty definitions table does not contain func definitions")

  (let ((ds (add-definition ds '(func $f (result i32)))))
    (assert-equal
     0
     (definitions-count ds 'global)
     "Definitions table with single func added contains 0 global definitions")

    (assert-equal
     #t
     (contains-definition ds '(func $f (result i32)))
     "Definitions table with single func added contains the func definition")

    (assert-equal
     0
     (definition-index ds '(func $f (result i32)))
     "Definitions table with single func added has index 0 for the definition")

    (assert-equal
     #f
     (contains-definition ds '(global $glob (mut i32)))
     "Definitions table with single func added does not contain a global definition")

    (assert-equal
     #f
     (definition-index ds '(global $glob (mut i32)))
     "Definitions table with single func added does not have index for a global definition")

    (assert-equal
     '()
     (get-definitions ds 'global)
     "Definitions table with single func added does not contain global definitions")

    (assert-equal
     1
     (definitions-count ds 'func)
     "Definitions table with single func added contains 1 funcs")

    (assert-equal
     '((func $f (result i32)))
     (get-definitions ds 'func)
     "Definitions table with single func added contains the func definition")

    (let ((ds (add-definition ds '(func $g (param i32) (result i32)))))
      (assert-equal
       0
       (definitions-count ds 'global)
       "Definitions table with two funcs added contains 0 global definitions")

      (assert-equal
       '()
       (get-definitions ds 'global)
       "Definitions table with two funcs added does not contain global definitions")

      (assert-equal
       2
       (definitions-count ds 'func)
       "Definitions table with two funcs added contains 2 func definitions")

      (assert-equal
       '((func $f (result i32)) (func $g (param i32) (result i32)))
       (get-definitions ds 'func)
       "Definitions table with two funcs added contains the func definitions in addition order")

      (let ((ds (add-definition ds '(global $glob (mut i32)))))
        (assert-equal
         1
         (definitions-count ds 'global)
         "Definitions table with two funcs and one global added contains 1 globals")

        (assert-equal
         #t
         (contains-definition ds '(global $glob (mut i32)))
         "Definitions table with two funcs and one global added contains the global definition")

        (assert-equal
         0
         (definition-index ds '(global $glob (mut i32)))
         "Definitions table with two funcs and one global added has index 0 for the global definition")

        (assert-equal
         #f
         (contains-definition ds '(global $other (mut i32)))
         "Definitions table with two funcs and one global added does not contain a nonmatching global definition")

        (assert-equal
         '((global $glob (mut i32)))
         (get-definitions ds 'global)
         "Definitions table with two funcs and one global added contains the global definition")

        (assert-equal
         2
         (definitions-count ds 'func)
         "Definitions table with two funcs and one global added contains 2 func definitions")

        (assert-equal
         #t
         (contains-definition ds '(func $f (result i32)))
         "Definitions table with two funcs and one global added contains the first func definition")

        (assert-equal
         #t
         (contains-definition ds '(func $g (param i32) (result i32)))
         "Definitions table with two funcs and one global added contains the second func definition")

        (assert-equal
         0
         (definition-index ds '(func $f (result i32)))
         "Definitions table with two funcs and one global added has index 0 for the first func definition")

        (assert-equal
         1
         (definition-index ds '(func $g (param i32) (result i32)))
         "Definitions table with two funcs and one global added has index 1 for the second func definition")

        (assert-equal
         '((func $f (result i32)) (func $g (param i32) (result i32)))
         (get-definitions ds 'func)
         "Definitions table with two funcs and one global added contains the func definitions in addition order")
        ))))
