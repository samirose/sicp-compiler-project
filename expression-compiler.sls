#!r6rs
(library
 (expression-compiler)

 (export compile
         compile-values
         compile-procedure-body
         compile-proc-to-func)

 (import (rnrs base)
         (rnrs lists)
         (lists)
         (scheme-syntax)
         (pattern-match)
         (lexical-env)
         (compiled-program)
         (compilation-error)
         (wasm-syntax)
         (wasm-module-definitions))

;;;; SCHEME to WAT (WebAssembly Text format) compiler written in R6RS
;;;; BASED ON COMPILER FROM SECTION 5.5 OF
;;;; STRUCTURE AND INTERPRETATION OF COMPUTER PROGRAMS

(define (compile exp program lexical-env)
  (cond ((number? exp)
         (compile-number exp program))
        ((boolean? exp)
         (compile-boolean exp program))
        ((string? exp)
         (compile-string exp program))
        ((pattern-match? `(quote ,??) exp)
         (compile-quoted exp (cadr exp) program))
        ((variable? exp)
         (compile-variable exp program lexical-env))
        ((pattern-match? `(set! ,variable? ,??) exp)
         (compile-assignment exp (cadr exp) (caddr exp) program lexical-env compile))
        ((pattern-match? `(define ,variable? ,??) exp)
         (compile-variable-definition exp (cadr exp) (caddr exp) program lexical-env compile))
        ((pattern-match? `(define (,variable? ,??*) ,?? ,??*) exp)
         (compile-procedure-definition
          exp (caadr exp) (cdadr exp) (cddr exp) program lexical-env compile))
        ((pattern-match? `(if ,?? ,??, ??) exp)
         (compile-if exp (cadr exp) (caddr exp) (cadddr exp) program lexical-env compile))
        ((pattern-match? `(if ,?? ,??) exp)
         (compile-if exp (cadr exp) (caddr exp) #f program lexical-env compile))
        ((pattern-match? `(not ,??) exp)
         (compile-not exp (cadr exp) program lexical-env compile))
        ((pattern-match? `(and ,??*) exp)
         (compile-and exp (cdr exp) program lexical-env compile))
        ((pattern-match? `(or ,??*) exp)
         (compile-or exp (cdr exp) program lexical-env compile))
        ((pattern-match? `(lambda (,??*) ,?? ,??*) exp)
         (compile-lambda exp (cadr exp) (cddr exp) program lexical-env '() compile))
        ((pattern-match? `(let (,?? ,??*) ,?? ,??*) exp)
         (for-all check-binding (cadr exp))
         (compile-let exp (cadr exp) (cddr exp) program lexical-env compile))
        ((pattern-match? `(let* (,?? ,??*) ,?? ,??*) exp)
         (for-all check-binding (cadr exp))
         (compile-let* exp (cadr exp) (cddr exp) program lexical-env compile))
        ((pattern-match? `(begin ,?? ,??*) exp)
         (compile-sequence (cdr exp) program lexical-env compile))
        ((pattern-match? `(,arithmetic-operator?) exp)
         (compile-open-coded-arithmetic-identity exp (car exp) program lexical-env compile))
        ((pattern-match? `(,arithmetic-operator? ,??) exp)
         (compile-open-coded-arithmetic-single-operand exp (car exp) (cadr exp) program lexical-env compile))
        ((pattern-match? `(,arithmetic-operator? ,?? ,?? ,??*) exp)
         (compile-open-coded-arithmetic-exp exp (car exp) (cdr exp) program lexical-env compile))
        ((pattern-match? `(,comparison-operator? ,?? ,??*) exp)
         (compile-open-coded-comparison-exp exp (car exp) (cdr exp) program lexical-env compile))
        ((pattern-match? `(,comparison-operator?) exp)
         (raise-compilation-error "Expected at least one argument" exp))
        ((check-syntax-errors exp))
        ((pattern-match? `(,?? ,??*) exp)
         (compile-application exp (car exp) (cdr exp) program lexical-env compile))
        (else
         (raise-compilation-error "Unknown expression type" exp))))

;;;special values

; Uninitialized value should be distinguishable from valid values.
; Use zero for now until typing of primitive values is implemented.
(define uninitialized-value '(i32.const 0))

; Result of expressions for which Scheme defines an unspecified result
(define unspecified-value '(i32.const 0))

;;;simple expressions

(define (compile-number exp program)
  (compiled-program-with-value-code
   program
   (cond ((integer? exp)
          `(i32.const ,exp))
         (else
          (raise-compilation-error "Unsupported number" exp)))))

(define (compile-boolean exp program)
  (compiled-program-with-value-code
   program
   `(i32.const ,(if exp 1 0))))

(define (compile-string exp program)
  (raise-compilation-error "Strings not supported yet" exp))

(define (compile-quoted exp value program)
  (raise-compilation-error "Quote not supported yet" exp))

(define (compile-variable exp program lexical-env)
  (let* ((lexical-address
          (find-variable exp lexical-env))
         (get-instr
          (cond ((not lexical-address)
                 (raise-compilation-error "Lexically unbound variable" exp))
                ((global-address? lexical-address) 'global.get)
                ((= (frame-index lexical-address) 0) 'local.get)
                (else
                 (raise-compilation-error "Variables in immediate enclosing scope or top-level only supported" exp)))))
    (compiled-program-with-value-code
     program
     `(,get-instr ,(var-index lexical-address)))))

(define (compile-assignment exp variable value program lexical-env compile)
  (let* ((lexical-address
          (find-variable variable lexical-env))
         (program-with-value-computing-code
          (compile value program lexical-env))
         (set-instr
          (cond
            ((not lexical-address)
             (raise-compilation-error "Lexically unbound variable" exp))
            ((global-address? lexical-address) 'global.set)
            ((= (frame-index lexical-address) 0) 'local.set)
            (else
             (raise-compilation-error "Variables in immediate enclosing scope or top-level only supported" exp)))))
    (compiled-program-append-value-code
     program-with-value-computing-code
     `(,set-instr ,(var-index lexical-address) ,@unspecified-value))))

(define (add-global-definition exp variable value-program lexical-env)
  (let*
      ((global-index
        (cond ((not (global-lexical-env? lexical-env))
               (raise-compilation-error "Only top-level define is supported" exp))
              ((find-variable variable lexical-env) => var-index)
              (else
               (raise-compilation-error
                "Internal compiler error: global binding missing from global lexical env"
                (list variable lexical-env)))))
       (value-code
        (compiled-program-value-code value-program))
       (init-instr
        (if (wasm-const-value? value-code)
            value-code
            uninitialized-value))
       (global-definition
        `(global (mut i32) ,init-instr))
       (init-code
        (if (wasm-const-value? value-code)
            '()
            `(,@value-code global.set ,global-index))))
    (compiled-program-with-definition-and-value-code
     value-program
     global-definition
     init-code)))

(define (compile-variable-definition exp variable value program lexical-env compile)
  (add-global-definition
   exp variable
   (compile value program lexical-env)
   lexical-env))

(define (compile-procedure-definition exp variable formals body program lexical-env compile)
  (check-all-identifiers formals)
  (add-global-definition
   exp variable
   (compile-lambda exp formals body program lexical-env variable compile)
   lexical-env))

;;;open-coded primitives

(define arithmetic-operator-map
  `((+ (i32.add) 0 ,(lambda (x) x))
    (- (i32.sub) #f
       ,(lambda (x) (- 0 x))) ; Do not use (- x) to avoid circular definition
    (* (i32.mul) 1 ,(lambda (x) x))
    (/ (i32.div_s) #f ,(lambda (x) (raise-compilation-error "No rational number support" `(/ ,x))))))

(define arithmetic-operators
  (map car arithmetic-operator-map))

(define (arithmetic-operator? sym)
  (memq sym arithmetic-operators))

(define (compile-open-coded-arithmetic-identity exp operator program lexical-env compile)
  (let ((identity-value (caddr (assq operator arithmetic-operator-map))))
    (if identity-value
        (compile identity-value program lexical-env)
        (raise-compilation-error "Expected at least one operand" exp))))

(define (compile-open-coded-arithmetic-single-operand exp operator operand program lexical-env compile)
  (let ((value-converter (cadddr (assq operator arithmetic-operator-map))))
    (compile (value-converter operand) program lexical-env)))

(define (compile-open-coded-arithmetic-exp exp operator operands program lexical-env compile)
  (let* ((instr (cadr (assq operator arithmetic-operator-map)))
         (program-with-first-value-computing-code
          (compile (car operands) program lexical-env)))
    (compiled-program-append-value-codes
     program-with-first-value-computing-code
     (let compile-rest-arguments
       ((program program-with-first-value-computing-code)
        (operands (cdr operands)))
       (let ((program-with-next-value-computing-code
              (compiled-program-append-value-code
               (compile (car operands) program lexical-env)
               instr)))
         (if (null? (cdr operands))
             program-with-next-value-computing-code
             (compiled-program-append-value-codes
              program-with-next-value-computing-code
              (compile-rest-arguments program-with-next-value-computing-code (cdr operands)))))))))

(define comparison-operator-to-wasm-instr
  '((= (i32.eq))
    (< (i32.lt_s))
    (> (i32.gt_s))
    (<= (i32.le_s))
    (>= (i32.ge_s))))

(define comparison-operators
  (map car comparison-operator-to-wasm-instr))

(define (comparison-operator? sym)
  (memq sym comparison-operators))

(define (compile-binary-operator instr operand1 operand2 program lexical-env compile)
  (let* ((operand1-program
          (compile operand1 program lexical-env))
         (operands-program
          (compiled-program-append-value-codes
           operand1-program
           (compile operand2 operand1-program lexical-env))))
    (compiled-program-append-value-code
     operands-program
     instr)))

(define (compile-open-coded-comparison-exp exp operator operands program lexical-env compile)
  (cond ((null? operands)
         (raise-compilation-error "Comparison operator needs at least one argument" exp))
        ((null? (cdr operands))
         (compile #t program lexical-env))
        ((null? (cddr operands))
         (compile-binary-operator
          (cadr (assq operator comparison-operator-to-wasm-instr))
          (car operands) (cadr operands)
          program lexical-env compile))
        (else
         (compile
          `(and
            ,@(let generate ((operands operands))
                (if (null? (cdr operands))
                    '()
                    `((,operator ,(car operands) ,(cadr operands))
                      ,@(generate (cdr operands))))))
          program lexical-env))))

;;;conditional expressions

(define (compile-if exp test consequent alternate program lexical-env compile)
  (let* ((t-prog (compile test program lexical-env))
         (c-prog (compile consequent t-prog lexical-env))
         (a-prog
          (if alternate
              (compile alternate c-prog lexical-env)
              (compiled-program-with-value-code c-prog unspecified-value))))
    (compiled-program-with-value-code
     a-prog
     `(,@(compiled-program-value-code t-prog)
       if (result i32)
         ,@(compiled-program-value-code c-prog)
       else
         ,@(compiled-program-value-code a-prog)
       end))))

(define (compile-not exp test program lexical-env compile)
  (let ((test-prog (compile test program lexical-env)))
    (compiled-program-with-value-code
     test-prog
     `(,@(compiled-program-value-code test-prog)
       if (result i32)
         ,@(compiled-program-value-code (compile #f test-prog lexical-env))
       else
         ,@(compiled-program-value-code (compile #t test-prog lexical-env))
       end))))

(define (compile-and exp tests program lexical-env compile)
  (cond
    ((null? tests)
     (compile #t program lexical-env))
    ((null? (cdr tests))
     (compile (car tests) program lexical-env))
    (else
     (let
         ((tests-prog
           (let generate ((tests tests)
                          (prog program))
             (cond
               ((null? (cdr tests))
                (let*
                    ((env (add-new-local-temporaries-frame lexical-env 1))
                     (temp-var-index (env-var-index-offset env))
                     (test-prog (compile (car tests) prog env))
                     (test-code (compiled-program-value-code test-prog)))
                  (compiled-program-with-value-code
                   test-prog
                   `(block
                       ,@test-code
                       (local i32)
                       local.tee ,temp-var-index
                       br_if 0
                       br 1
                     end
                     local.get ,temp-var-index
                     br 1))))
               (else
                (let*
                    ((test-prog (compile (car tests) prog lexical-env))
                     (test-code (compiled-program-value-code test-prog))
                     (block-prog
                      (compiled-program-with-value-code
                       test-prog
                       `(block
                           ,@test-code
                           br_if 0
                           br 1
                         end))))
                  (compiled-program-append-value-codes
                   block-prog
                   (generate (cdr tests) block-prog))))))))
       (compiled-program-with-value-code
        tests-prog
        `(block (result i32)
            block
              ,@(compiled-program-value-code tests-prog)
            end
            ,@(compiled-program-value-code (compile #f tests-prog lexical-env))
          end))))))

(define (compile-or exp tests program lexical-env compile)
  (cond
    ((null? tests)
     (compile #f program lexical-env))
    ((null? (cdr tests))
     (compile (car tests) program lexical-env))
    (else
     (let*
         ((env (add-new-local-temporaries-frame lexical-env 1))
          (temp-var-index (env-var-index-offset env))
          (tests-prog
           (let generate ((tests tests)
                          (prog program))
             (let*
                 ((test-prog (compile (car tests) prog env))
                  (test-code (compiled-program-value-code test-prog)))
               (cond
                 ((null? (cdr tests))
                  (compiled-program-with-value-code
                   test-prog
                   `(,@test-code
                     local.set ,temp-var-index)))
                 (else
                  (let
                      ((block-prog
                        (compiled-program-with-value-code
                         test-prog
                         `(block
                             ,@test-code
                             local.tee ,temp-var-index
                             br_if 1
                           end))))
                    (compiled-program-append-value-codes
                     block-prog
                     (generate (cdr tests) block-prog)))))))))
       (compiled-program-with-value-code
        tests-prog
        `((local i32)
          block
            ,@(compiled-program-value-code tests-prog)
          end
          local.get ,temp-var-index))))))

;;; sequences

(define (compile-sequence seq program lexical-env compile)
  (let ((program-with-next-exp
         (compile (car seq) program lexical-env)))
    (if (null? (cdr seq))
        program-with-next-exp
        (let ((program-with-next-exp-result-discarded
               (compiled-program-append-value-code
                program-with-next-exp
                '(drop))))
          (compiled-program-append-value-codes
           program-with-next-exp-result-discarded
           (compile-sequence
            (cdr seq)
            program-with-next-exp-result-discarded
            lexical-env
            compile))))))

;;;lambda expressions

(define scheme-procedure-param-type 'i32)

(define (scheme-procedure-type-definition arity)
  (let ((param-types
         (if (= 0 arity)
             '()
             (list
              (cons 'param
                    (make-list scheme-procedure-param-type arity))))))
    `(type (func ,@param-types (result i32)))))

(define (compile-procedure-body seq program lexical-env compile)
  (let*
      ((body-program
        (compile-sequence seq program lexical-env compile))
       (body-code
        (wasm-local-definitions-to-top
         (compiled-program-value-code body-program))))
    (compiled-program-with-value-code body-program body-code)))

(define (compile-proc-to-func context-exp formals body program lexical-env exported-name compile)
   (let*
       ; Compile the procedure body
       ((body-env
         (if (null? (first-duplicate formals))
             (add-new-lexical-frame lexical-env formals '())
             (raise-compilation-error "Duplicate parameter in" context-exp)))
        (body-program
         (compile-procedure-body body program body-env compile))
        ; Add function type, if needed, and look up its index
        (func-type (scheme-procedure-type-definition (length formals)))
        (type-program
         (if (compiled-program-contains-definition body-program func-type)
             body-program
             (compiled-program-add-definition body-program func-type)))
        (type-index
         (compiled-program-definition-index type-program func-type))
        ; Add function definition and look up its index
        (func-definition
         `(func (type ,type-index)
                ,@(compiled-program-value-code body-program)))
        (func-index
         (compiled-program-definitions-count type-program 'func))
        (func-program
         (compiled-program-with-definition-and-value-code
          type-program
          func-definition
          '())))
     ; Add export definition for the function if exported name is defined
     (if exported-name
         (compiled-program-add-definition
          func-program
          `(export ,exported-name (func ,func-index)))
         func-program)))

(define (compile-lambda exp formals body program lexical-env current-binding compile)
  (check-all-identifiers formals)
  (let*
      ((exported-name
        (cond ((assq 'export (env-get-additional-info current-binding lexical-env)) => cadr)
              (else #f)))
       (func-program
        (compile-proc-to-func
         exp
         formals
         body
         program
         lexical-env
         exported-name
         compile))
       ; Add table element for the function for indirect calling
       (func-index
        (- (compiled-program-definitions-count func-program 'func) 1))
       (elem-definition
        `(elem ,func-index))
       (elem-index
        (compiled-program-definitions-count func-program 'elem))
       (elem-program
        (compiled-program-add-definition func-program elem-definition)))
       ; Lambda expression's value is the function's index in the table
    (compiled-program-with-value-code
     elem-program
     `(i32.const ,elem-index))))

;;;let expression
(define (compile-compute-and-assign exps program lexical-env compile assign-code)
  (let loop ((es exps)
             (n 0)
             (p program))
    (if (null? es)
        p
        (loop (cdr es)
              (+ n 1)
              (compiled-program-append-value-codes
               p
               (compiled-program-append-value-code
                (compile (car es) p lexical-env)
                (assign-code n)))))))

(define (compile-let exp bindings body program lexical-env compile)
  (let*
      ((variables
        (let* ((vars (map car bindings))
               (duplicate-var (first-duplicate vars)))
          (if (null? duplicate-var)
              vars
              (raise-compilation-error "Duplicate variable in let expression" exp))))
       (values (map cadr bindings))
       (local-defs-program
        (compiled-program-with-value-code
         program
         (list (wasm-define-locals 'i32 (length variables)))))
        (body-env
         (add-new-local-frame lexical-env variables '()))
       (var-index-offset (env-var-index-offset body-env))
       (compute-and-assign-values-program
        (compile-compute-and-assign
         values
         local-defs-program
         lexical-env
         compile
         (lambda (n)
           `(local.set ,(+ var-index-offset n)))))
        (body-program
         (compile-sequence body compute-and-assign-values-program body-env compile)))
    (compiled-program-append-value-codes
     compute-and-assign-values-program
     body-program)))

(define (compile-let* exp bindings body program lexical-env compile)
  (let*
      ((variables (map car bindings))
       (values (map cadr bindings))
       (local-defs-program
        (compiled-program-with-value-code
         program
         (list (wasm-define-locals 'i32 (length variables))))))
    (let collect
      ((vars variables)
       (vals values)
       (program local-defs-program)
       (env lexical-env))
      (if (null? vars)
          (compiled-program-append-value-codes
           program
           (compile-sequence body program env compile))
          (let*
              ((value-prog
                (compiled-program-append-value-codes
                 program
                 (compile (car vals) program env)))
               (var (car vars))
               (env-with-var
                (add-new-local-frame env (list var) '()))
               (local-index
                (var-index (find-variable var env-with-var))))
            (collect
             (cdr vars)
             (cdr vals)
             (compiled-program-append-value-code value-prog `(local.set ,local-index))
             env-with-var))))))

;;;combinations

(define (compile-values exps program lexical-env compile)
  (if (null? exps)
      (compiled-program-with-value-code program '())
      (let ((first-operand-program
             (compile (car exps) program lexical-env)))
        (fold-left
         (lambda (program exp)
           (compiled-program-append-value-codes
            program
            (compile exp program lexical-env)))
         first-operand-program
         (cdr exps)))))

(define (compile-application exp operator operands program lexical-env compile)
  (let*
      ((func-type (scheme-procedure-type-definition (length operands)))
       (type-program
        (if (compiled-program-contains-definition program func-type)
            program
            (compiled-program-add-definition program func-type)))
       (type-index
        (compiled-program-definition-index type-program func-type))
       (operands-program
        (compile-values operands type-program lexical-env compile))
       (operands-and-operator-program
        (compiled-program-append-value-codes
         operands-program
         (compile operator operands-program lexical-env))))
    (compiled-program-append-value-code
     operands-and-operator-program
     `(call_indirect (type ,type-index)))))
)
