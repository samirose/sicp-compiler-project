#!r6rs
(library
 (lexical-env)
 (export make-empty-lexical-env global-lexical-env? add-new-lexical-frame
         find-variable frame-index var-index global-address?)
 (import (rnrs base))

 (define (make-empty-lexical-env) '())

 (define (global-lexical-env? lexical-env)
   (null? (cdr lexical-env)))

 (define (add-new-lexical-frame frame lexical-env)
   (cons frame lexical-env))

 (define (make-lexical-address frame-index var-index lexical-env)
   (list frame-index var-index lexical-env))

 (define (frame-index lexical-address)
   (car lexical-address))

 (define (var-index lexical-address)
   (cadr lexical-address))

 (define (global-address? lexical-address)
   (global-lexical-env? (caddr lexical-address)))

 (define (find-variable var lexical-env)
   (define (scan env frame frame-index var-index)
     (if (null? frame)
         (if (null? (cdr env))
             'not-found
             (scan (cdr env) (cadr env) (+ frame-index 1) 0))
         (if (eq? (car frame) var)
             (make-lexical-address frame-index var-index env)
             (scan env (cdr frame) frame-index (+ var-index 1)))))
   (if (null? lexical-env)
       'not-found
       (scan lexical-env (car lexical-env) 0 0)))

 )