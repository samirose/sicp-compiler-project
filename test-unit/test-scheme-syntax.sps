#!r6rs
(import
 (rnrs base)
 (rnrs lists)
 (scheme-syntax)
 (assert))

(install-test-compilation-error-handler!)

;; definition
(let ((exp '(define x 42)))
  (assert-equal
   #t
   (definition? exp)
   "Variable definition with variable and simple value is valid")

  (assert-equal
   'x
   (definition-variable exp)
   "definition-variable returns the variable of variable definition")

  (assert-equal
   42
   (definition-value exp)
   "definition-value returns the value of variable definition"))

(let ((exp '(define x (+ 1 2))))
  (assert-equal
   #t
   (definition? exp)
   "Variable definition with variable and combination value is valid")

  (assert-equal
   'x
   (definition-variable exp)
   "definition-variable returns the variable of variable definition")

  (assert-equal
   '(+ 1 2)
   (definition-value exp)
   "definition-value returns the value of variable definition"))

(let ((exp '(define (zero) 0)))
  (assert-equal
   #t
   (definition? exp)
   "Procedure definition with zero parameters and simple body is valid")

  (assert-equal
   'zero
   (definition-variable exp)
   "definition-variable returns the variable for procedure definition")

  (assert-equal
   '(lambda () 0)
   (definition-value exp)
   "definition-value returns a lambda of procedure definition body"))

(let ((exp '(define (one) (+ 0 1))))
  (assert-equal
   #t
   (definition? exp)
   "Procedure definition with zero parameters and combination body is valid")

  (assert-equal
   'one
   (definition-variable exp)
   "definition-variable returns the variable for procedure definition")

  (assert-equal
   '(lambda () (+ 0 1))
   (definition-value exp)
   "definition-value returns a lambda of procedure definition body"))

(let ((exp '(define (one) (display "one:") (+ 0 1))))
  (assert-equal
   #t
   (definition? exp)
   "Procedure definition with multi-expression body is valid")

  (assert-equal
   'one
   (definition-variable exp)
   "definition-variable returns the variable for procedure definition")

  (assert-equal
   '(lambda () (display "one:") (+ 0 1))
   (definition-value exp)
   "definition-value returns a lambda of procedure definition body"))

(let ((exp '(define (square x) (* x x))))
  (assert-equal
   #t
   (definition? exp)
   "Procedure definition with single parameter and body is valid")

  (assert-equal
   'square
   (definition-variable exp)
   "definition-variable returns the variable for procedure definition")

  (assert-equal
   '(lambda (x) (* x x))
   (definition-value exp)
   "definition-value returns a lambda of procedure definition body"))

(let ((exp '(define (sum-of-squares x y) (+ (* x x) (* y y)))))
  (assert-equal
   #t
   (definition? exp)
   "Procedure definition with multiple parameters and body is valid")

  (assert-equal
   'sum-of-squares
   (definition-variable exp)
   "definition-variable returns the variable for procedure definition")

  (assert-equal
   '(lambda (x y) (+ (* x x) (* y y)))
   (definition-value exp)
   "definition-value returns a lambda of procedure definition body"))

(assert-raises-compilation-error
 (lambda () (definition? '(define)))
 "Variable and value missing from definition" '(define)
 "Definition without variable and value raises an error")

(assert-raises-compilation-error
 (lambda () (definition? '(define x)))
 "Variable or value missing from definition" '(define x)
 "Definition only one operand raises an error")

(assert-raises-compilation-error
 (lambda () (definition? '(define 1 42)))
 "Not an identifier" 1
 "Variable definition's first operand must be an identifier")

(assert-raises-compilation-error
 (lambda () (definition? '(define x 1 2)))
 "Too many operands to variable definition" '(define x 1 2)
 "Variable definition should have only variable and value operands")

(assert-raises-compilation-error
 (lambda () (definition? '(define x '(a b) 1)))
 "Too many operands to variable definition" '(define x '(a b) 1)
 "Variable definition should have only variable and value operands")

(assert-raises-compilation-error
 (lambda () (definition? '(define () 42)))
 "Variable missing from procedure definition" '(define () 42)
 "Procedure definition should specify variable for the procedure")

(assert-raises-compilation-error
 (lambda () (definition? '(define () 42)))
 "Variable missing from procedure definition" '(define () 42)
 "Procedure definition should specify variable for the procedure")

(assert-raises-compilation-error
 (lambda () (definition? '(define (x))))
 "Empty body in procedure definition" '(define (x))
 "Procedure definition should specify a body for the procedure")

(assert-raises-compilation-error
 (lambda () (definition? '(define (1) 42)))
 "Not an identifier" 1
 "Procedure variable should be an identifier")

(assert-raises-compilation-error
 (lambda () (definition? '(define (x y 2) (+ x y 2))))
 "Not an identifier" 2
 "Procedure formal parameters should be identifiers")

(assert-raises-compilation-error
 (lambda () (definition? '(define 1 2 3)))
 "Not a variable or procedure definition" '(define 1 2 3)
 "Definition's first operand should be an identifier or an identifier list")

;; let expression
(define (test-let keyword predicate)
  (let ((exp `(,keyword ((a 1)) a)))
    (assert-equal
     #t
     (predicate exp)
     "Let expression with one binding and simple body is valid")

    (let ((bindings (let-bindings exp)))
      (assert-equal
       '((a 1))
       bindings
       "let-bindings returns let expression's binding list")

      (assert-equal
       'a
       (binding-variable (car bindings))
       "binding-variable returns binding's variable")

      (assert-equal
       1
       (binding-value (car bindings))
       "binding-value returns binding's value expression"))

    (assert-equal
     '(a)
     (let-body exp)
     "let-body returns let expression's body"))

  (let ((exp `(,keyword ((a 1) (b 2)) b)))
    (assert-equal
     #t
     (predicate exp)
     "Let expression with two bindings and simple body is valid")

    (assert-equal
     '((a 1) (b 2))
     (let-bindings exp)
     "let-bindings returns let expression's binding list")

    (assert-equal
     '(b)
     (let-body exp)
     "let-body returns let expression's body"))

  (let ((exp `(,keyword ((a 1) (b 2)) (+ a b))))
    (assert-equal
     #t
     (predicate exp)
     "Let expression with two bindings and combination body is valid")

    (assert-equal
     '((a 1) (b 2))
     (let-bindings exp)
     "let-bindings returns let expression's binding list")

    (assert-equal
     '((+ a b))
     (let-body exp)
     "let-body returns let expression's body"))

  (let ((exp `(,keyword ((a 1) (b 2)) (set! a 3) (+ a b))))
    (assert-equal
     #t
     (predicate exp)
     "Let expression with two bindings and multi-expression body is valid")

    (assert-equal
     '((a 1) (b 2))
     (let-bindings exp)
     "let-bindings returns let expression's binding list")

    (assert-equal
     '((set! a 3) (+ a b))
     (let-body exp)
     "let-body returns let expression's body"))

  (let ((exp `(,keyword ((a (+ 1 2)) (b (+ 2 3))) (set! a 3) (+ a b))))
    (assert-equal
     #t
     (predicate exp)
     "Let expression with combination values and multi-expression body is valid")

    (let ((bindings (let-bindings exp)))
      (assert-equal
       '((a (+ 1 2)) (b (+ 2 3)))
       bindings
       "let-bindings returns let expression's binding list")

      (assert-equal
       'b
       (binding-variable (cadr bindings))
       "binding-variable returns binding's variable")

      (assert-equal
       '(+ 2 3)
       (binding-value (cadr bindings))
       "binding-value returns binding's value expression"))

    (assert-equal
     '((set! a 3) (+ a b))
     (let-body exp)
     "let-body returns let expression's body"))

  (assert-raises-compilation-error
   (lambda () (predicate `(,keyword () 42)))
   "Empty bindings in let expression" `(,keyword () 42)
   "Let expression must define bindings")

  (assert-raises-compilation-error
   (lambda () (predicate `(,keyword ((a 1)))))
   "Bindings or body missing from let expression" `(,keyword ((a 1)))
   "Let expression must have a body")

  (assert-raises-compilation-error
   (lambda () (predicate `(,keyword)))
   "Bindings and body missing from let expression" `(,keyword)
   "Let expression must have bindings and body")

  (assert-raises-compilation-error
   (lambda () (predicate `(,keyword a 42)))
   "Bindings missing from let expression" `(,keyword a 42)
   "Bindings should be a list")

  (assert-raises-compilation-error
   (lambda () (predicate `(,keyword (a) a)))
   "Not a binding" 'a
   "Bindings must define a variable and value")

  (assert-raises-compilation-error
   (lambda () (predicate `(,keyword (1) 42)))
   "Not a binding" 1
   "Bindings must define a variable and value")

  (assert-raises-compilation-error
   (lambda () (predicate `(,keyword (b 1) b)))
   "Not a binding" 'b
   "Bindings is a list of variable-value pairs")

  (assert-raises-compilation-error
   (lambda () (predicate `(,keyword ((a)) a)))
   "Value missing from binding" '(a)
   "Bindings must define a variable and value")

  (assert-raises-compilation-error
   (lambda () (predicate `(,keyword ((1 2)) 42)))
   "Not an identifier" 1
   "Bindings must define a variable and value")

  (assert-raises-compilation-error
   (lambda () (predicate `(,keyword ((a 1 2)) a)))
   "Too many operands in binding" '(a 1 2)
   "Bindings must define a variable and single value"))

(test-let 'let let?)
(test-let 'let* let*?)

;; if expression
(let ((exp '(if 1 #t)))
  (assert-equal
   #t
   (if? exp)
   "If with simple test and consequent is valid")

  (assert-equal
   1
   (if-test exp)
   "if-test returns if expression's test expression")

  (assert-equal
   #t
   (if-consequent exp)
   "if-consequent returns if expression's consequent expression")

  (assert-equal
   #f
   (if-alternate exp)
   "if-alternate returns if expression's alternate expression or false"))

(let ((exp '(if 1 #t #f)))
  (assert-equal
   #t
   (if? exp)
   "If with simple test, consequent and alternate is valid")

  (assert-equal
   1
   (if-test exp)
   "if-test returns if expression's test expression")

  (assert-equal
   #t
   (if-consequent exp)
   "if-consequent returns if expression's consequent expression")

  (assert-equal
   #f
   (if-alternate exp)
   "if-alternate returns if expression's alternate expression or false"))

(let ((exp '(if (< x 0) (set! x (+ x 1)))))
  (assert-equal
   #t
   (if? exp)
   "If with composite test and consequent is valid")

  (assert-equal
   '(< x 0)
   (if-test exp)
   "if-test returns if expression's test expression")

  (assert-equal
   '(set! x (+ x 1))
   (if-consequent exp)
   "if-consequent returns if expression's consequent expression")

  (assert-equal
   #f
   (if-alternate exp)
   "if-alternate returns if expression's alternate expression or false"))

(let ((exp '(if (< x 0) (begin (set! y x) (+ x 1)) (- x 1))))
  (assert-equal
   #t
   (if? exp)
   "If with composite test, consequent and alternative is valid")

  (assert-equal
   '(< x 0)
   (if-test exp)
   "if-test returns if expression's test expression")

  (assert-equal
   '(begin (set! y x) (+ x 1))
   (if-consequent exp)
   "if-consequent returns if expression's consequent expression")

  (assert-equal
   '(- x 1)
   (if-alternate exp)
   "if-alternate returns if expression's alternate expression or false"))

(assert-raises-compilation-error
 (lambda () (if? '(if)))
 "Test and consequent missing from if expression" '(if)
 "If expression must contain at least test and consequent subexpressions")

(assert-raises-compilation-error
 (lambda () (if? '(if (= x 0))))
 "Consequent missing from if expression" '(if (= x 0))
 "If expression must contain at least test and consequent subexpressions")

(assert-raises-compilation-error
 (lambda () (if? '(if (= x 0) 1 2 3)))
 "Too many subexpressions in if expression" '(if (= x 0) 1 2 3)
 "If expression must not contain more subexpressions than test, consequent and alternative")

(assert-raises-compilation-error
 (lambda () (if? '(if (= x 0) 1 2 3 4)))
 "Too many subexpressions in if expression" '(if (= x 0) 1 2 3 4)
 "If expression must not contain more subexpressions than test, consequent and alternative")

;; not expression
(assert-equal
 (not? '(not x))
 #t
 "Not with single simple expression is valid")

(assert-equal
 (not? '(not (and x y)))
 #t
 "Not with single composite expression is valid")

(assert-raises-compilation-error
 (lambda () (not? '(not x y)))
 "Too many arguments in not expression" '(not x y)
 "Not expression must have single argument")

;; sequence
(let ((exp '(begin 42)))
  (assert-equal
   #t
   (begin? exp)
   "Sequence with one simple expression is valid")

  (let ((seq (begin-actions exp)))
    (assert-equal
     '(42)
     seq
     "begin-actions returns begin form's expression sequence")

    (assert-equal
     42
     (first-exp seq)
     "first-exp returns begin form sequence's first expression")

    (assert-equal
     '()
     (rest-exps seq)
     "rest-exps returns begin form sequence's expressions after the first")

    (assert-equal
     #t
     (last-exp? seq)
     "last-exp? returns true for begin form sequence's last expression")))

(let ((exp '(begin (+ 1 2) 4 5)))
  (assert-equal
   #t
   (begin? exp)
   "Sequence with multiple expressions is valid")

  (let ((seq (begin-actions exp)))
    (assert-equal
     '(+ 1 2)
     (first-exp seq)
     "first-exp returns begin form sequence's first expression")

    (assert-equal
     '(4 5)
     (rest-exps seq)
     "rest-exps returns begin form sequence's expressions after the first")

    (assert-equal
     #f
     (last-exp? seq)
     "last-exp? returns true for begin form sequence's last expression")

    (let ((seq (rest-exps seq)))
      (assert-equal
       4
       (first-exp seq)
       "first-exp returns begin form sequence's first expression")

      (assert-equal
       '(5)
       (rest-exps seq)
       "rest-exps returns begin form sequence's expressions after the first")

      (assert-equal
       #f
       (last-exp? seq)
       "last-exp? returns true for begin form sequence's last expression")

      (let ((seq (rest-exps seq)))
        (assert-equal
         5
         (first-exp seq)
         "first-exp returns begin form sequence's first expression")

        (assert-equal
         '()
         (rest-exps seq)
         "rest-exps returns begin form sequence's expressions after the first")

        (assert-equal
         #t
         (last-exp? seq)
         "last-exp? returns true for begin form sequence's last expression")))))

(assert-raises-compilation-error
 (lambda () (begin? '(begin)))
 "Empty sequence" '(begin)
 "Sequence without expressions is invalid")

;; application
(let ((exp '(proc)))
  (assert-equal
   #t
   (application? exp)
   "Procedure application without parameters is valid")

  (assert-equal
   'proc
   (operator exp)
   "operator returns procedure application's operator")

  (assert-equal
   '()
   (operands exp)
   "operands returns procedure application's operands"))

(let ((exp '(proc 1)))
  (assert-equal
   #t
   (application? exp)
   "Procedure application with one simple parameter is valid")

  (assert-equal
   'proc
   (operator exp)
   "operator returns procedure application's operator")

  (assert-equal
   '(1)
   (operands exp)
   "operands returns procedure application's operands"))

(let ((exp '(proc (+ x 1))))
  (assert-equal
   #t
   (application? exp)
   "Procedure application with one combination parameter is valid")

  (assert-equal
   'proc
   (operator exp)
   "operator returns procedure application's operator")

  (assert-equal
   '((+ x 1))
   (operands exp)
   "operands returns procedure application's operands"))

(let ((exp '(m-proc 1 (+ x 1) 3)))
  (assert-equal
   #t
   (application? exp)
   "Procedure application with multiple parameters is valid")

  (assert-equal
   'm-proc
   (operator exp)
   "operator returns procedure application's operator")

  (assert-equal
   '(1 (+ x 1) 3)
   (operands exp)
   "operands returns procedure application's operands"))

(assert-raises-compilation-error
 (lambda () (application? '()))
 "No operator in application" '()
 "Application must contain at least an operator")
