(import (scheme base)
        (scheme read)
	(scheme write)
	(only (srfi srfi-1) fold)
	(pattern-match))

(define (compile-value exp)
  (cond ((boolean? exp)
	 `(i32.const ,(if exp 1 0)))
	((number? exp)
	 `(i32.const ,exp))
	(else (error "Unsupported value" exp))))

(define (compile-test-exp exp)
  (let ((proc-name (symbol->string (car exp)))
	(args (cdr exp)))
    `(invoke ,proc-name ,@(map compile-value args))))

(define (compile-test-eq exp)
  (let ((name (cadr exp))
	(test-exp (compile-test-exp (cadddr exp)))
	(expected-value (compile-value (caddr exp))))
    `(,(string-append ";; " name)
      (assert_return ,test-exp ,expected-value))))

(define (value->string exp)
  (cond ((boolean? exp)
	 (if exp "#t" "#f"))
	((number? exp)
	 (number->string exp 10))
	(else (error "Unsupported value" exp))))

(define (invocation-expr->string exp)
  (let ((proc (car exp))
	(args (cdr exp)))
  (apply string-append
	 `("("
	   ,(symbol->string proc)
	   ,@(reverse
	      (fold (lambda (v l)
		      (cons (value->string v)
			    (cons " " l)))
		    '()
		    args))
	   ")"))))

(define (compile-test-invoke exp)
  `(,(string-append ";; " (invocation-expr->string (cdr exp)))
    ,(compile-test-exp (cdr exp))))

(define (compile-exp exp)
  (cond ((pattern-match? `(compiler-test-eq ,?? ,?? ,??) exp)
	 (compile-test-eq exp))
	((pattern-match? `(compiler-test-invoke ,?? ,??*) exp)
	 (compile-test-invoke exp))
	(else 'UNKNOWN)))

(define (is-wast-ast? ast)
  (pair? ast))

(define (emit-wast wast-ast)
  (write-string (car wast-ast))
  (newline)
  (write (cadr wast-ast))
  (newline))

(let compile-next ((exp (read)))
  (cond ((eof-object? exp) (newline))
	(else
	 (let ((ast (compile-exp exp)))
	   (if (is-wast-ast? ast)
	       (emit-wast ast)))
	 (compile-next (read)))))
