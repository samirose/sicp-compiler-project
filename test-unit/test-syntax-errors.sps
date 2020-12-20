#!r6rs
(import
 (rnrs base)
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
 '(quote)
 "Too few operands" '(quote)
 "Quote without values raises an error")

(assert-expression-raises-compilation-error
 '(quote x y)
 "Too many operands" '(quote x y)
 "Quote with multiple values raises an error")
