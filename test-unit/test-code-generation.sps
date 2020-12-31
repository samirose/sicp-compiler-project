#!r6rs
(import
 (rnrs base)
 (lexical-env)
 (compiled-program)
 (expression-compiler)
 (assert))

(let*
    ((env (add-new-lexical-frame (make-empty-lexical-env) '(x) '()))
     (prog (compile '(define x 42) (make-empty-compiled-program) env)))
  (assert-equal
   '((global (mut i32) (i32.const 42)))
   (compiled-program-get-definitions prog 'global)
   "Top-level define with a value should be initialised directly")
  (assert-equal
   '()
   (compiled-program-get-definitions prog 'start)
   "Top-level define with a value should not generate a globals initialisation function"))
