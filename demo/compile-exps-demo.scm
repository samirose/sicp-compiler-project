(define-library (compile-exps-demo)

  (export compile-exp
	  demo1 demo2 demo3 demo4)

  (import (scheme base)
	  (expression-compiler)
	  (compiled-program)
	  (lexical-env))

  (begin
    (define (compile-exp exp)
      (let ((env (add-new-top-level-frame
		  (make-empty-lexical-env)
		  0 '() '())))
	(compile exp (make-empty-compiled-program) env)))

    (define (demo1)
      (compile-exp '(+ 1 2)))

    (define (demo2)
      (compile-exp '(if (> 1 2) (+ 1 2) 42)))

    (define (demo3)
      (compile-exp '(lambda (x) x)))

    (define (demo4)
      (compile-exp '((lambda (x) (* x x)) 2)))

    ))
