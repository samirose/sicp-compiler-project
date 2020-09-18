#!r6rs
(library
 (lexical-env)
 (export make-empty-lexical-env current-env
         add-new-lexical-frame find-variable frame-index var-index
         global-lexical-env? global-address?
         with-current-exported-binding current-exported-binding with-current-exported-binding-removed)
 (import (rnrs base))

 (define (make-lexical-env current-env current-exported-binding)
   (list current-env current-exported-binding))

 (define (make-empty-lexical-env)
   (make-lexical-env '() '()))

 (define (current-env lexical-env)
   (car lexical-env))

 (define (empty-lexical-env? lexical-env)
   (null? (current-env lexical-env)))

 (define (global-env? env)
   (and (not (null? env)) (null? (cdr env))))

 (define (global-lexical-env? lexical-env)
   (global-env? (current-env lexical-env)))

 (define (add-new-lexical-frame frame lexical-env)
   (make-lexical-env
    (cons frame (current-env lexical-env))
    (current-exported-binding lexical-env)))

 (define (make-lexical-address frame-index var-index lexical-env)
   (list frame-index var-index lexical-env))

 (define (frame-index lexical-address)
   (car lexical-address))

 (define (var-index lexical-address)
   (cadr lexical-address))

 (define (global-address? lexical-address)
   (global-env? (caddr lexical-address)))

 (define (find-variable var lexical-env)
   (define (scan env frame frame-index var-index)
     (if (null? frame)
         (if (null? (cdr env))
             'not-found
             (scan (cdr env) (cadr env) (+ frame-index 1) 0))
         (if (eq? (car frame) var)
             (make-lexical-address frame-index var-index env)
             (scan env (cdr frame) frame-index (+ var-index 1)))))
   (if (empty-lexical-env? lexical-env)
       'not-found
       (scan (current-env lexical-env)
             (car (current-env lexical-env))
             0 0)))

 (define (with-current-exported-binding lexical-env exported-binding)
   (make-lexical-env (current-env lexical-env) exported-binding))

 (define (with-current-exported-binding-removed lexical-env)
   (make-lexical-env (current-env lexical-env) '()))

 (define (current-exported-binding lexical-env)
   (cadr lexical-env))

 )