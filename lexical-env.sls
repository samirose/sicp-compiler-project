#!r6rs
(library
 (lexical-env)
 (export make-empty-lexical-env global-lexical-env?
         make-lexical-frame add-new-lexical-frame
         find-variable frame-index var-index additional-info global-address?
         env-get-additional-info)
 (import (rnrs base)
         (rnrs lists))

 (define (make-empty-lexical-env) '())

 (define (global-lexical-env? lexical-env)
   (and (not (null? lexical-env))
        (null? (cdr lexical-env))))

 (define (make-lexical-frame variables additional-info-map)
   (list variables additional-info-map))

 (define (frame-variables frame)
   (car frame))

 (define (frame-additional-info-map frame)
   (cadr frame))

 (define (frame-get-additional-info var frame)
   (cond ((assq var (frame-additional-info-map frame)) => cdr)
         (else '())))

 (define (env-get-additional-info var lexical-env)
   (if (null? lexical-env)
       '()
       (frame-get-additional-info var (car lexical-env))))

 (define (add-new-lexical-frame lexical-env frame)
   (cons frame lexical-env))

 (define (make-lexical-address frame-index var-index lexical-env additional-info)
   (list frame-index var-index lexical-env additional-info))

 (define (frame-index lexical-address)
   (car lexical-address))

 (define (var-index lexical-address)
   (cadr lexical-address))

 (define (global-address? lexical-address)
   (global-lexical-env? (caddr lexical-address)))

 (define (additional-info lexical-address)
   (cadddr lexical-address))

 (define (find-variable var lexical-env)
   (if (null? lexical-env)
       'not-found
       (let scan ((env lexical-env)
                  (vars (frame-variables (car lexical-env)))
                  (frame-index 0)
                  (var-index 0))
         (if (null? vars)
             (if (null? (cdr env))
                 'not-found
                 (scan (cdr env) (frame-variables (cadr env)) (+ frame-index 1) 0))
             (if (eq? (car vars) var)
                 (make-lexical-address
                  frame-index
                  var-index
                  env
                  (frame-get-additional-info var (car env)))
                 (scan env (cdr vars) frame-index (+ var-index 1)))))))

 )
