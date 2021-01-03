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

;; quotation
(assert-expression-raises-compilation-error
 '(quote)
 "Too few operands" '(quote)
 "Quote without values raises an error")

(assert-expression-raises-compilation-error
 '(quote x y)
 "Too many operands" '(quote x y)
 "Quote with multiple values raises an error")

;; assignment
(assert-expression-raises-compilation-error
 '(set!)
 "Variable and value missing from assignment" '(set!)
 "Assignment without value raises an error")

(assert-expression-raises-compilation-error
 '(set! x)
 "Variable or value missing from assignment" '(set! x)
 "Assignment without value raises an error")

(assert-expression-raises-compilation-error
 '(set! 1 2)
 "Invalid variable in assignment" '(set! 1 2)
 "Assignment's second operand must be an identifier")

(assert-expression-raises-compilation-error
 '(set! x 1 2)
 "Too many operands to assignment" '(set! x 1 2)
 "Assignment with too many operands raises an error")

;; lambda expression
(assert-expression-raises-compilation-error
 '(lambda ())
 "Body missing from lambda expression" '(lambda ())
 "Lambda expression must define a body")

(assert-expression-raises-compilation-error
 '(lambda (x))
 "Body missing from lambda expression" '(lambda (x))
 "Lambda expression must define a body")

(assert-expression-raises-compilation-error
 '(lambda x)
 "Body missing from lambda expression" '(lambda x)
 "Lambda expression must define a body")

(assert-expression-raises-compilation-error
 '(lambda a a)
 "Arguments list missing from lambda expression" '(lambda a a)
 "Lambda expressions must define an argument list (list argument forms are not yet supported)")

(assert-expression-raises-compilation-error
 '(lambda (x 1) (+ x 1))
 "Not an identifier" 1
 "Lambda arguments must be identifiers")

;; definition
(assert-expression-raises-compilation-error
 '(define)
 "Variable and value missing from definition" '(define)
 "Definition without variable and value raises an error")

(assert-expression-raises-compilation-error
 '(define x)
 "Variable or value missing from definition" '(define x)
 "Definition only one operand raises an error")

(assert-expression-raises-compilation-error
 '(define 1 42)
 "Not an identifier in variable position" '(define 1 42)
 "Variable definition's first operand must be an identifier")

(assert-expression-raises-compilation-error
 '(define x 1 2)
 "Too many operands to variable definition" '(define x 1 2)
 "Variable definition should have only variable and value operands")

(assert-expression-raises-compilation-error
 '(define x '(a b) 1)
 "Too many operands to variable definition" '(define x '(a b) 1)
 "Variable definition should have only variable and value operands")

(assert-expression-raises-compilation-error
 '(define () 42)
 "Variable missing from procedure definition" '(define () 42)
 "Procedure definition should specify variable for the procedure")

(assert-expression-raises-compilation-error
 '(define () 42)
 "Variable missing from procedure definition" '(define () 42)
 "Procedure definition should specify variable for the procedure")

(assert-expression-raises-compilation-error
 '(define (x))
 "Empty body in procedure definition" '(define (x))
 "Procedure definition should specify a body for the procedure")

(assert-expression-raises-compilation-error
 '(define (1) 42)
 "Not an identifier in variable position" '(define (1) 42)
 "Procedure variable should be an identifier")

(assert-expression-raises-compilation-error
 '(define (x y 2) (+ x y 2))
 "Not an identifier" 2
 "Procedure formal parameters should be identifiers")

(assert-expression-raises-compilation-error
 '(define 1 2 3)
 "Not a variable or procedure definition" '(define 1 2 3)
 "Definition's first operand should be an identifier or an identifier list")

;; if expression
(assert-expression-raises-compilation-error
 '(if)
 "Test and consequent missing from if expression" '(if)
 "If expression must contain at least test and consequent subexpressions")

(assert-expression-raises-compilation-error
 '(if (= x 0))
 "Consequent missing from if expression" '(if (= x 0))
 "If expression must contain at least test and consequent subexpressions")

(assert-expression-raises-compilation-error
 '(if (= x 0) 1 2 3)
 "Too many subexpressions in if expression" '(if (= x 0) 1 2 3)
 "If expression must not contain more subexpressions than test, consequent and alternative")

(assert-expression-raises-compilation-error
 '(if (= x 0) 1 2 3 4)
 "Too many subexpressions in if expression" '(if (= x 0) 1 2 3 4)
 "If expression must not contain more subexpressions than test, consequent and alternative")

;; not expression
(assert-expression-raises-compilation-error
 '(not)
 "Argument missing from not expression" '(not)
 "Not expression must have single argument")

(assert-expression-raises-compilation-error
 '(not x y)
 "Too many arguments in not expression" '(not x y)
 "Not expression must have single argument")

;; let expressions
(assert-expression-raises-compilation-error
 '(let () 42)
 "Empty bindings in let expression" '(let () 42)
 "let expression must define bindings")

(assert-expression-raises-compilation-error
 '(let* () 42)
 "Empty bindings in let* expression" '(let* () 42)
 "let* expression must define bindings")

(assert-expression-raises-compilation-error
 '(let ((a 1)))
 "Bindings or body missing from let expression" '(let ((a 1)))
 "let expression must have a body")

(assert-expression-raises-compilation-error
 '(let* ((a 1)))
 "Bindings or body missing from let* expression" '(let* ((a 1)))
 "let* expression must have a body")

(assert-expression-raises-compilation-error
 '(let)
 "Bindings and body missing from let expression" '(let)
 "let expression must have bindings and body")

(assert-expression-raises-compilation-error
 '(let*)
 "Bindings and body missing from let* expression" '(let*)
 "let* expression must have bindings and body")

(assert-expression-raises-compilation-error
 '(let a 42)
 "Bindings missing from let expression" '(let a 42)
 "Bindings should be a list")

(assert-expression-raises-compilation-error
 '(let* a 42)
 "Bindings missing from let* expression" '(let* a 42)
 "Bindings should be a list")

(define (test-let-bindings keyword)
  (assert-expression-raises-compilation-error
   `(,keyword (a) a)
   "Not a binding" 'a
   "Bindings must define a variable and value")

  (assert-expression-raises-compilation-error
   `(,keyword (1) 42)
   "Not a binding" 1
   "Bindings must define a variable and value")

  (assert-expression-raises-compilation-error
   `(,keyword (b 1) b)
   "Not a binding" 'b
   "Bindings is a list of variable-value pairs")

  (assert-expression-raises-compilation-error
   `(,keyword ((a)) a)
   "Value missing from binding" '(a)
   "Bindings must define a variable and value")

  (assert-expression-raises-compilation-error
   `(,keyword ((1 2)) 42)
   "Not an identifier" 1
   "Bindings must define a variable and value")

  (assert-expression-raises-compilation-error
   `(,keyword ((a 1 2)) a)
   "Too many operands in binding" '(a 1 2)
   "Bindings must define a variable and single value"))

(test-let-bindings 'let)
(test-let-bindings 'let*)

;; sequence
(assert-expression-raises-compilation-error
 '(begin)
 "Empty sequence" '(begin)
 "Sequence without expressions is invalid")

;; comparison operators
(for-each
 (lambda (operator)
   (assert-expression-raises-compilation-error
    `(,operator)
    "Expected at least one argument" `(,operator)
    "Comparison operators require at least one argument"))
 '(= < > <= >=))
