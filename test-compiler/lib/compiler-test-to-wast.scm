(import (scheme base)
        (scheme read)
	(scheme write)
	(only (srfi srfi-1) fold for-each)
	(pattern-match)
        (values))

(define (compile-value exp)
  (cond ((boolean? exp)
	 `(i32.const ,(boolean->boolean-value exp)))
	((number? exp)
	 `(i32.const ,(number->fixnum-value exp)))
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

(define (compile-test-unspecified exp)
  (let ((name (cadr exp))
	(test-exp (compile-test-exp (caddr exp))))
    `(,(string-append ";; " name)
      (assert_return ,test-exp (i32.const ,unspecified-value)))))

(define (compile-test-error exp)
  (let* ((name (cadr exp))
	 (test-exp (compile-test-exp (caddr exp)))
         (expected-error (cadddr exp))
         (expected-error-code-entry (assq expected-error symbol->error))
         (expected-error-code
          (if expected-error-code-entry
              (cdr expected-error-code-entry)
              (error "Unknown runtime error type" expected-error))))
    `(,(string-append ";; " name)
      (assert_trap ,test-exp "unreachable")
      (assert_return (invoke "get-error-code") (i32.const ,expected-error-code)))))

(define (compiler-test-expect-fail-host specifier)
  '())

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
	((pattern-match? `(compiler-test-unspecified ,?? ,??*) exp)
	 (compile-test-unspecified exp))
        ((pattern-match? `(compiler-test-error ,?? ,?? ,??) exp)
         (compile-test-error exp))
	(else 'UNKNOWN)))

(define (is-wast-ast? ast)
  (pair? ast))

(define (emit-wast wast-ast)
  (write-string (car wast-ast))
  (newline)
  (for-each
   (lambda (wast-ast)
     (write wast-ast)
     (newline))
   (cdr wast-ast)))

(let compile-next ((exp (read)))
  (cond ((eof-object? exp) (newline))
	(else
	 (let ((ast (compile-exp exp)))
	   (if (is-wast-ast? ast)
	       (emit-wast ast)))
	 (compile-next (read)))))
