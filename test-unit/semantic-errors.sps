#!r6rs
(import
 (rnrs base)
 (rnrs exceptions)
 (lists)
 (assert)
 (lexical-env)
 (scheme-libraries)
 (compiled-program)
 (expression-compiler))

(install-test-compilation-error-handler!)

(define empty-global-env
  (add-new-lexical-frame (make-empty-lexical-env) '() '()))

(define base-program
  (add-import-definitions
   '((scheme base))
   (make-empty-compiled-program)))

(define (assert-expression-raises-compilation-error exp expected-message expected-object description)
  (assert-raises-compilation-error
   (lambda () (compile exp base-program empty-global-env))
   expected-message expected-object description))

;; self-evaluating expressions
(assert-expression-raises-compilation-error
 "a string"
 "Strings not supported yet" "a string"
 "String values are not yet supported")

(assert-expression-raises-compilation-error
 3.14
 "Unsupported number" 3.14
 "Floating-point values are not yet supported")

;; quote
(assert-expression-raises-compilation-error
 '(quote x)
 "Quote not supported yet" '(quote x)
 "Quoted values are not yet supported")

;; arithmetic expressions
(assert-expression-raises-compilation-error
 '(-)
 "Expected at least one operand" '(-)
 "Substraction does not have an identity value")

(assert-expression-raises-compilation-error
 '(/)
 "Expected at least one operand" '(/)
 "Division does not have an identity value")

(assert-expression-raises-compilation-error
 '(/ 5)
 "No rational number support" '(/ 5)
 "Cannot represent 1/5 with integers only")

;; lambda expression
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
 '(lambda (x x) (+ x x))
 "Duplicate parameter in" '(lambda (x x) (+ x x))
 "Lambda parameters should not be duplicated")

;; let expression
(assert-expression-raises-compilation-error
 '(let ((a 1) (b 2) (a 3) (c 4)) (+ a b c))
 "Duplicate variable in let expression" '(let ((a 1) (b 2) (a 3) (c 4)) (+ a b c))
 "Let bindings should not define the same variable multiple times")
