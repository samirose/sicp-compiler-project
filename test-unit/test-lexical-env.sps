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
   0
   (env-var-index-offset env)
   "env-var-index-offset of the empty lexical env is zero")

  (assert-equal
   #f
   (find-variable 'x env)
   "A variable is not found from an empty lexical env")

  (let ((env (add-new-lexical-frame env '(a b) '((b (export "func_b"))))))
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
     '((export "func_b"))
     (additional-info (find-variable 'b env))
     "find-variable of a variable with additional info returns the info")

    (assert-equal
     '()
     (additional-info (find-variable 'a env))
     "find-variable of a variable without additional info returns empty info")

    (assert-equal
     '((export "func_b"))
     (env-get-additional-info 'b env)
     "env-get-additional-info of a variable with additional info returns the info")

    (assert-equal
     '()
     (env-get-additional-info 'a env)
     "env-get-additional-info of a variable without additional info returns empty info")

    (let ((env (env-add-additional-info env 'b 'test-flag)))
      (assert-equal
       '(test-flag (export "func_b"))
       (env-get-additional-info 'b env)
       "env-get-additional-info of a variable with additional info returns env with added info"))

    (assert-equal
     #f
     (find-variable 'x env)
     "Variable not defined in the only frame is not found")

    (let ((local-env (add-new-local-frame env '(b c) '())))
      (assert-equal
       0
       (env-var-index-offset local-env)
       "env-var-index-offset of a local env following the global lexical env is zero")

      (assert-equal
       '(0 0)
       (let ((address (find-variable 'a local-env)))
         (list (frame-index address) (var-index address)))
       "find-variable of first variable in the global env returns frame-index 0 and var-index 0")

      (assert-equal
       '(0 0)
       (let ((address (find-variable 'b local-env)))
         (list (frame-index address) (var-index address)))
       "find-variable of first variable in the local env following the global env returns frame-index 0 and var-index 0")

      (assert-equal
       #f
       (global-address? (find-variable 'b local-env))
       "Address of a variable in local env is not a global address")

      (assert-equal
       '(0 1)
       (let ((address (find-variable 'c local-env)))
         (list (frame-index address) (var-index address)))
       "find-variable of second variable in the local env following the global env returns frame-index 0 and var-index 1"))

    (let ((env (add-new-lexical-frame env '(x a) '())))
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
       '()
       (env-get-additional-info 'b env)
       "env-get-additional-info returns info only from the topmost frame")

      (assert-equal
       #f
       (find-variable 'y env)
       "Variable not defined in any frame is not found")

      (let* ((prev-frame-size 2)
             (env (add-new-local-frame env '(y a) '())))
        (assert-equal
         prev-frame-size
         (env-var-index-offset env)
         "env-var-index-offset with local frame added returns the length of the previous frame")

        (assert-equal
         `(0 ,prev-frame-size)
         (let ((address (find-variable 'y env)))
           (list (frame-index address) (var-index address)))
         "find-variable of first variable in the last added local frame returns frame-index 0 and var-index (length of previous frame)")

        (assert-equal
         `(0 ,(+ prev-frame-size 1))
         (let ((address (find-variable 'a env)))
           (list (frame-index address) (var-index address)))
         "Variable with identical name is found first in the last added local frame")

        (assert-equal
         '(0 0)
         (let ((address (find-variable 'x env)))
           (list (frame-index address) (var-index address)))
         "find-variable of first variable in the last preceeding lexical frame returns frame-index 0 and var-index 0")

        (let ((prev-frames-size 4)
              (env (add-new-local-frame env '(z) '())))
          (assert-equal
           prev-frames-size
           (env-var-index-offset env)
           "env-var-index-offset with local frame added returns the length of the previous local frame and its preceeding frame")

          (assert-equal
           `(0 ,prev-frames-size)
           (let ((address (find-variable 'z env)))
             (list (frame-index address) (var-index address)))
           "find-variable of first variable in the last added local frame returns frame-index 0 and var-index (length of previous local frame and its preceedign frame)")

          (assert-equal
           '(1 1)
           (let ((address (find-variable 'b env)))
             (list (frame-index address) (var-index address)))
           "find-variable will return frame-index of 1 and correct var-index for variable found in the next lexical frame")

          (let ((prev-frames-size 5)
                (env (add-new-local-temporaries-frame env 2)))
            (assert-equal
             prev-frames-size
             (env-var-index-offset env)
             "env-var-index-offset with local frame added returns the length of the previous local frame and its preceeding frame")

            (let ((env (add-new-local-frame env '(t) '())))
              (assert-equal
               7
               (env-var-index-offset env)
               "add-new-local-temporaries-frame reserves index space for specified number of variables"))))))))
