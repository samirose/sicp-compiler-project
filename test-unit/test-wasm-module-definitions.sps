#!r6rs
(import
 (rnrs base)
 (wasm-module-definitions)
 (assert))

(let ((ds (make-empty-wasm-module-definitions)))

  (assert-equal
   0
   (wasm-module-definitions-count ds 'func)
   "Empty module definitions contains 0 func defintions")

  (assert-equal
   #f
   (wasm-module-definition-index ds '(func $f (result i32)))
   "Empty module definitions does not have index for a func definition")

  (assert-equal
   #f
   (wasm-module-contains-definition ds '())
   "Empty module definitions does not contain an empty definition")

  (assert-equal
   '()
   (wasm-module-get-definitions ds 'func)
   "Empty module definitions does not contain func definitions")

  (let ((ds (wasm-module-add-definition ds '(func $f (result i32)))))
    (assert-equal
     0
     (wasm-module-definitions-count ds 'global)
     "Module definitions with single func added contains 0 global definitions")

    (assert-equal
     #t
     (wasm-module-contains-definition ds '(func $f (result i32)))
     "Module definitions with single func added contains the func definition")

    (assert-equal
     0
     (wasm-module-definition-index ds '(func $f (result i32)))
     "Module definitions with single func added has index 0 for the definition")

    (assert-equal
     #f
     (wasm-module-contains-definition ds '(global $glob (mut i32)))
     "Module definitions with single func added does not contain a global definition")

    (assert-equal
     #f
     (wasm-module-definition-index ds '(global $glob (mut i32)))
     "Module definitions with single func added does not have index for a global definition")

    (assert-equal
     '()
     (wasm-module-get-definitions ds 'global)
     "Module definitions with single func added does not contain global definitions")

    (assert-equal
     1
     (wasm-module-definitions-count ds 'func)
     "Module definitions with single func added contains 1 funcs")

    (assert-equal
     '((func $f (result i32)))
     (wasm-module-get-definitions ds 'func)
     "Module definitions with single func added contains the func definition")

    (let ((ds (wasm-module-add-definition ds '(func $g (param i32) (result i32)))))
      (assert-equal
       0
       (wasm-module-definitions-count ds 'global)
       "Module definitions with two funcs added contains 0 global definitions")

      (assert-equal
       '()
       (wasm-module-get-definitions ds 'global)
       "Module definitions with two funcs added does not contain global definitions")

      (assert-equal
       2
       (wasm-module-definitions-count ds 'func)
       "Module definitions with two funcs added contains 2 func definitions")

      (assert-equal
       '((func $f (result i32)) (func $g (param i32) (result i32)))
       (wasm-module-get-definitions ds 'func)
       "Module definitions with two funcs added contains the func definitions in addition order")

      (let ((ds (wasm-module-add-definition ds '(global $glob (mut i32)))))
        (assert-equal
         1
         (wasm-module-definitions-count ds 'global)
         "Module definitions with two funcs and one global added contains 1 globals")

        (assert-equal
         #t
         (wasm-module-contains-definition ds '(global $glob (mut i32)))
         "Module definitions with two funcs and one global added contains the global definition")

        (assert-equal
         0
         (wasm-module-definition-index ds '(global $glob (mut i32)))
         "Module definitions with two funcs and one global added has index 0 for the global definition")

        (assert-equal
         #f
         (wasm-module-contains-definition ds '(global $other (mut i32)))
         "Module definitions with two funcs and one global added does not contain a nonmatching global definition")

        (assert-equal
         '((global $glob (mut i32)))
         (wasm-module-get-definitions ds 'global)
         "Module definitions with two funcs and one global added contains the global definition")

        (assert-equal
         2
         (wasm-module-definitions-count ds 'func)
         "Module definitions with two funcs and one global added contains 2 func definitions")

        (assert-equal
         #t
         (wasm-module-contains-definition ds '(func $f (result i32)))
         "Module definitions with two funcs and one global added contains the first func definition")

        (assert-equal
         #t
         (wasm-module-contains-definition ds '(func $g (param i32) (result i32)))
         "Module definitions with two funcs and one global added contains the second func definition")

        (assert-equal
         0
         (wasm-module-definition-index ds '(func $f (result i32)))
         "Module definitions with two funcs and one global added has index 0 for the first func definition")

        (assert-equal
         1
         (wasm-module-definition-index ds '(func $g (param i32) (result i32)))
         "Module definitions with two funcs and one global added has index 1 for the second func definition")

        (assert-equal
         '((func $f (result i32)) (func $g (param i32) (result i32)))
         (wasm-module-get-definitions ds 'func)
         "Module definitions with two funcs and one global added contains the func definitions in addition order")
        ))))
