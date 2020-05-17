#!r6rs
(library
 (lexical-env)
 (export make-lexical-address frame-index var-index find-variable)
 (import (rnrs base))

 ; From solution to SICP exercise 5.39
 (define (make-lexical-address frame-index var-index)
   (cons frame-index var-index))

 (define (frame-index lexical-address)
   (car lexical-address))

 (define (var-index lexical-address)
   (cdr lexical-address))

 ; From solution to SICP exercise 5.41
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

 )