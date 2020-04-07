#lang sicp
(#%require "scheme-syntax.scm")
(#%provide compile)

;;;; SCHEME to WAT (WebAssembly Text format) compiler written in Racket

;; Currently supports compilation of:
;; * 32-bit integer values
;; * Open-coded compilation of application of + - * / = operators

;;;; BASED ON COMPILER FROM SECTION 5.5 OF
;;;; STRUCTURE AND INTERPRETATION OF COMPUTER PROGRAMS


(define (compile exp lexical-env)
  (cond ((self-evaluating? exp)
         (compile-self-evaluating exp))
        ((quoted? exp) (compile-quoted exp))
        ((variable? exp)
         (compile-variable exp lexical-env))
        ((assignment? exp)
         (compile-assignment exp lexical-env compile))
        ((definition? exp)
         (compile-definition exp lexical-env compile))
        ((if? exp) (compile-if exp lexical-env compile))
        ((lambda? exp) (compile-lambda exp lexical-env compile))
        ((begin? exp)
         (compile-sequence (begin-actions exp) lexical-env compile))
        ((cond? exp) (compile (cond->if exp) lexical-env))
        ((open-coded-primitive-application? exp)
         (compile-open-coded-primitive exp lexical-env compile))
        ((application? exp)
         (compile-application exp lexical-env compile))
        (else
         (error "Unknown expression type -- COMPILE" exp))))

(define (make-instruction-sequence module-level statements)
  (list module-level statements))

(define (module-level s) (car s))
(define (statements s) (cadr s))

(define (empty-instruction-sequence)
  (make-instruction-sequence '() '()))

;;;simple expressions

(define (compile-self-evaluating exp)
  (cond ((integer? exp)
         (make-instruction-sequence
          '() `(i32.const ,exp)))
        (else
         (error "Unsupported value" exp))))

(define (compile-quoted exp)
  (error "Quote not supported yet" exp))

; From solution exercise 5.39
(define (make-lexical-address frame-index var-index)
  (cons frame-index var-index))

(define (frame-index lexical-address)
  (car lexical-address))

(define (var-index lexical-address)
  (cdr lexical-address))

; From solution to exercise 5.41
(define (find-variable var lexical-env)
  (define (scan env frame frame-index var-index)
    (if (null? frame)
        (if (null? (cdr env))
            'not-found
            (scan (cdr env) (cadr env) (+ frame-index 1) 0))
        (if (eq? (car frame) var)
            (make-lexical-address frame-index var-index)
            (scan env (cdr frame) frame-index (+ var-index 1)))))
  (if (null? lexical-env)
      'not-found
      (scan lexical-env (car lexical-env) 0 0)))

(define (compile-variable exp lexical-env)
  (let ((lexical-address (find-variable exp lexical-env)))
    (if (eq? lexical-address 'not-found)
        (error "Lexically unbound variable" exp)
        (if (> (frame-index lexical-address) 0)
            (error "Variables in immediate enclosing frame only supported" exp)
            (make-instruction-sequence
             '()
             `(get_local ,(var-index lexical-address)))))))

(define (compile-assignment exp lexical-env compile)
  (let ((lexical-address (find-variable (assignment-variable exp))))
    (if (eq? lexical-address 'not-found)
        (error "Lexically unbound variable" exp)
        (if (> (frame-index lexical-address) 0)
            (error "Variables in immediate enclosing frame only supported" exp)
            (append-instruction-sequences
             (compile (assignment-value exp) lexical-env)
             (make-instruction-sequence
              '()
              `(set_local ,(var-index lexical-address))))))))

(define (compile-definition exp lexical-env compile)
  (error "Definitions not supported yet" exp))

;;;open-coded primitives

(define open-coded-primitives-to-machine-ops
  '((+ (i32.add))
    (- (i32.sub))
    (* (i32.mul))
    (/ (i32.div))
    (= (i32.eq))))

(define (open-coded-primitive-application? exp)
  (and (application? exp)
       (assoc (operator exp) open-coded-primitives-to-machine-ops)))

(define (compile-open-coded-primitive exp lexical-env compile)
  (let ((op (cadr (assoc (operator exp) open-coded-primitives-to-machine-ops))))
    (define (compile-rest-arguments operands)
      (let ((code-to-compute-next-operand-to-stack
             (compile (car operands) lexical-env)))
        (append-instruction-sequences
         code-to-compute-next-operand-to-stack
         (if (null? (cdr operands))
             (make-instruction-sequence '() op)
             (append-instruction-sequences
              (make-instruction-sequence '() op)
              (compile-rest-arguments (cdr operands)))))))
    (let ((operands (operands exp)))
      (append-instruction-sequences
       (compile (car operands) lexical-env)
       (compile-rest-arguments (cdr operands))))))

;;;ids

(define id-counter 0)

(define (new-id-number)
  (set! id-counter (+ 1 id-counter))
  id-counter)

(define (make-id name)
  (string->symbol
    (string-append "$" (symbol->string name)
                   (number->string (new-id-number)))))

;;;conditional expressions

(define (compile-if exp lexical-env compile)
  (let ((p-code (compile (if-predicate exp) lexical-env))
        (c-code (compile (if-consequent exp) lexical-env))
        (a-code (compile (if-alternative exp) lexical-env)))
    (append-instruction-sequences
     p-code
     (append-instruction-sequences
      (make-instruction-sequence '() '(if (result i32)))
      (append-instruction-sequences
       c-code
       (make-instruction-sequence '() '(else))
       a-code
       (make-instruction-sequence '() '(end)))))))

;;; sequences

(define (compile-sequence seq lexical-env compile)
  (if (last-exp? seq)
      (compile (first-exp seq) lexical-env)
      (append-instruction-sequences
       (compile (first-exp seq) lexical-env)
       (compile-sequence (rest-exps seq) lexical-env compile))))

;;;lambda expressions

(define (compile-lambda exp lexical-env compile)
  (let ((lambda-func-id (make-id 'lambda))
        (formals (lambda-parameters exp)))
    (let ((params (map (lambda (arg) '(param i32)) formals))
          (body-code (let ((extended-env (cons formals lexical-env)))
                       (compile-sequence (lambda-body exp) extended-env compile))))
       ; Add function definition to module level
      (make-instruction-sequence
       (append
        `(func ,lambda-func-id ,@params (result i32)
               ,@(statements body-code))
        (module-level body-code))
       ; Function value is its index
       `(i32.const ,lambda-func-id)))))

;;;combinations

(define (compile-application exp lexical-env compile)
  (let ((proc-code (compile (operator exp) lexical-env))
        (operand-codes
         (map (lambda (operand) (compile operand lexical-env))
              (operands exp))))
    (append-instruction-sequences
     (construct-arglist operand-codes)
     proc-code
     (make-instruction-sequence '() `(call)))))

(define (construct-arglist operand-codes)
  (if (null? operand-codes)
      (empty-instruction-sequence)
      (append-instruction-sequences
       (car operand-codes)
       (construct-arglist (cdr operand-codes)))))

;;;combining instruction sequences

(define (append-instruction-sequences . seqs)
  (define (append-2-sequences seq1 seq2)
    (make-instruction-sequence
     (append (module-level seq1) (module-level seq2))
     (append (statements seq1) (statements seq2))))
  (define (append-seq-list seqs)
    (if (null? seqs)
        (empty-instruction-sequence)
        (append-2-sequences (car seqs)
                            (append-seq-list (cdr seqs)))))
  (append-seq-list seqs))

'(COMPILER LOADED)
