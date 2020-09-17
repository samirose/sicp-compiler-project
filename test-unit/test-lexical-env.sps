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

  (let ((env (add-new-lexical-frame '(a b) env)))
    (assert-equal
     #t
     (global-lexical-env? env)
     "Lexical env containing one frame is the global lexical env")

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

    (let ((env (add-new-lexical-frame '(x a) env)))
      (assert-equal
       #f
       (global-lexical-env? env)
       "Lexical frame containing two frames is not the global lexical env")

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
