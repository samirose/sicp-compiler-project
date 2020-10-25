#!r6rs
(import
 (rnrs base)
 (rnrs exceptions)
 (lists)
 (assert)
 (lexical-env)
 (compiled-program)
 (expression-compiler))

(install-test-compilation-error-handler!)

(define empty-global-env
  (add-new-lexical-frame (make-empty-lexical-env) '() '()))

(define (assert-expression-raises-compilation-error exp expected-message expected-object description)
  (assert-raises-compilation-error
   (lambda () (compile exp (make-empty-compiled-program) empty-global-env))
   expected-message expected-object description))

(assert-expression-raises-compilation-error
 "a string"
 "Unsupported value" "a string"
 "String values are not yet supported")

(assert-expression-raises-compilation-error
 3.14
 "Unsupported value" 3.14
 "Floating-point values are not yet supported")

(assert-expression-raises-compilation-error
 '(quote x)
 "Quote not supported yet" '(quote x)
 "Quoted values are not yet supported")

(assert-expression-raises-compilation-error
 '(lambda (x) (+ y x))
 "Lexically unbound variable" 'y
 "Referenced variables must be found in lexical scope")

(assert-expression-raises-compilation-error
 '(lambda (x) (lambda (y) (+ x y)))
 "Variables in immediate enclosing scope or top-level only supported" 'x
 "Referencing variables out of current lexical or global scope is not yet supported")

(assert-expression-raises-compilation-error
 '(lambda (x) (lambda () (set! x 1) x))
 "Variables in immediate enclosing scope or top-level only supported" '(set! x 1)
 "Assigning to variables out of current lexical or global scope is not yet supported")

(assert-expression-raises-compilation-error
 '(lambda (x) (set! y x))
 "Lexically unbound variable" '(set! y x)
 "Assignment 's variable must be found in lexical scope")

(assert-expression-raises-compilation-error
 '(lambda (x) (define y (+ x 1)) y)
 "Only top-level define is supported" '(define y (+ x 1))
 "Assigning to variables out of current lexical or global scope is not yet supported")

(assert-expression-raises-compilation-error
 '(define x 42)
 "Internal compiler error: global binding missing from global lexical env"
 (list 'x empty-global-env)
 "Module compilation stage should set up bindings in global lexical environment")

(assert-expression-raises-compilation-error
 '(lambda (x x) (+ x x))
 "Duplicate parameter in lambda" '(lambda (x x) (+ x x))
 "Lambda parameters should not be duplicated")
