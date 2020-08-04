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
   '()
   (wasm-module-get-definitions ds 'func)
   "Empty module definitions does not contain func definitions")

  (let ((ds (wasm-module-add-definition ds '(func $f (result i32)))))
    (assert-equal
     0
     (wasm-module-definitions-count ds 'global)
     "Module definitions with single func added contains 0 global definitions")

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
         '((global $glob (mut i32)))
         (wasm-module-get-definitions ds 'global)
         "Module definitions with two funcs and one global added contains the global definition")

        (assert-equal
         2
         (wasm-module-definitions-count ds 'func)
         "Module definitions with two funcs and one global added contains 2 func definitions")

        (assert-equal
         '((func $f (result i32)) (func $g (param i32) (result i32)))
         (wasm-module-get-definitions ds 'func)
         "Module definitions with two funcs and one global added contains the func definitions in addition order")

        (let* ((ds1 (wasm-module-add-definition (make-empty-wasm-module-definitions) '(global $glob1 i32 (i32.const 42))))
               (ds2 (wasm-module-add-definition ds1 '(type $t1 (func (result i32)))))
               (ds (wasm-module-append ds ds2)))
          (assert-equal
           2
           (wasm-module-definitions-count ds 'func)
           "Module definitions with two funcs added and none appended contains 2 func definitions")

          (assert-equal
           '((func $f (result i32)) (func $g (param i32) (result i32)))
           (wasm-module-get-definitions ds 'func)
           "Module definitions with two funcs added and none appended contains the func definitions in addition order")

          (assert-equal
           2
           (wasm-module-definitions-count ds 'global)
           "Module definitions with one global and one global appended contains 2 global definitions")

          (assert-equal
           '((global $glob (mut i32)) (global $glob1 i32 (i32.const 42)))
           (wasm-module-get-definitions ds 'global)
           "Module definitions with one global and one global appended contains the global definitions in addition order")

          (assert-equal
           1
           (wasm-module-definitions-count ds 'type)
           "Module definitions with no types and one type appended contains 1 type")

          (assert-equal
           '((type $t1 (func (result i32))))
           (wasm-module-get-definitions ds 'type)
           "Module definitions with no types and one type appended contains the added type")
          )))))
