#!r6rs
(import
 (rnrs base)
 (lexical-env)
 (assert))

(let ((env (make-empty-lexical-env)))
  (assert-equal
   #f
   (global-lexical-env? env)
   "Empty lexical env is not the global lexical env")

  (assert-equal
   'not-found
   (find-variable 'x env)
   "A variable is not found from an empty lexical env")

  (assert-equal
   '()
   (current-exported-binding env)
   "Current exported binding is empty until set")

  (let ((env (add-new-lexical-frame '(a b) env)))
    (assert-equal
     #t
     (global-lexical-env? env)
     "Lexical env containing one frame is the global lexical env")

    (assert-equal
     #t
     (global-address? (find-variable 'a env))
     "Address of a variable in the only frame is a global address")

    (assert-equal
     '(0 0)
     (let ((address (find-variable 'a env)))
       (list (frame-index address) (var-index address)))
     "find-variable of first variable in the only frame returns frame-index 0 and var-index 0")

    (assert-equal
     '(0 1)
     (let ((address (find-variable 'b env)))
       (list (frame-index address) (var-index address)))
     "find-variable of second variable in the only frame returns frame-index 0 and var-index 1")

    (assert-equal
     'not-found
     (find-variable 'x env)
     "Variable not defined in the only frame is not found")

    (assert-equal
     '()
     (current-exported-binding env)
     "Current exported binding is empty until set")

    (let ((env-with-exported-binding (with-current-exported-binding env 'b)))
      (assert-equal
       'b
       (current-exported-binding env-with-exported-binding)
       "with-current-exported-binding sets the exported binding")

      (assert-equal
       (current-env env)
       (current-env env-with-exported-binding)
       "with-current-exported-binding does not affect the lexical-env environment")

      (assert-equal
       '()
       (current-exported-binding (with-current-exported-binding-removed env-with-exported-binding))
       "with-current-exported-binding-removed removes the exported binding")

      (assert-equal
       env
       (with-current-exported-binding-removed env-with-exported-binding)
       "with-current-exported-binding-removed restores the lexical env to the state before adding the binding"))

    (let ((env (add-new-lexical-frame '(x a) env)))
      (assert-equal
       #f
       (global-lexical-env? env)
       "Lexical frame containing two frames is not the global lexical env")

      (assert-equal
       #f
       (global-address? (find-variable 'a env))
       "Address of a variable in the second frame is not a global address")

      (assert-equal
       '(0 0)
       (let ((address (find-variable 'x env)))
         (list (frame-index address) (var-index address)))
       "find-variable of first variable in the last added frame returns frame-index 0 and var-index 0")

      (assert-equal
       '(0 1)
       (let ((address (find-variable 'a env)))
         (list (frame-index address) (var-index address)))
       "Variable with identical name is found first in the last added frame")

      (assert-equal
       '(1 1)
       (let ((address (find-variable 'b env)))
         (list (frame-index address) (var-index address)))
       "find-variable will return frame-index of 1 and correct var-index for variable found in the next frame")

      (assert-equal
       'not-found
       (find-variable 'y env)
       "Variable not defined in any frame is not found"))))
