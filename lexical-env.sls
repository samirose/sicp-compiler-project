#!r6rs
(library
 (lexical-env)
 (export make-empty-lexical-env global-lexical-env?
         add-new-lexical-frame add-new-local-frame
         find-variable frame-index var-index additional-info global-address?
         env-get-additional-info env-var-index-offset)
 (import (rnrs base)
         (rnrs lists))

 (define (make-empty-lexical-env) '())

 (define (global-lexical-env? lexical-env)
   (and (not (null? lexical-env))
        (null? (cdr lexical-env))))

 (define (make-lexical-frame variables additional-info-map)
   (list make-lexical-frame variables additional-info-map))

 (define (make-local-frame lexical-env variables additional-info-map)
   (let ((index-offset
          (if (null? lexical-env)
              0
              (let* ((curr-frame (car lexical-env))
                     (curr-frame-length (length (frame-variables curr-frame)))
                     (curr-frame-index-offset (frame-index-offset curr-frame)))
                (+ curr-frame-index-offset curr-frame-length)))))
     (list index-offset variables additional-info-map)))

 (define (lexical-frame? frame)
   (eq? (car frame) make-lexical-frame))

 (define (local-frame-index-offset frame)
   (car frame))

 (define (frame-index-offset frame)
   (if (lexical-frame? frame)
       0
       (local-frame-index-offset frame)))

 (define (env-var-index-offset lexical-env)
   (if (null? lexical-env)
       0
       (frame-index-offset (car lexical-env))))

 (define (frame-variables frame)
   (cadr frame))

 (define (frame-additional-info-map frame)
   (caddr frame))

 (define (frame-get-additional-info var frame)
   (cond ((assq var (frame-additional-info-map frame)) => cdr)
         (else '())))

 (define (env-get-additional-info var lexical-env)
   (if (null? lexical-env)
       '()
       (frame-get-additional-info var (car lexical-env))))

 (define (add-new-lexical-frame lexical-env variables additional-info-map)
   (cons (make-lexical-frame variables additional-info-map)
         lexical-env))

 (define (add-new-local-frame lexical-env variables additional-info-map)
   (cons (make-local-frame lexical-env variables additional-info-map)
         lexical-env))

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
       #f
       (let scan ((env lexical-env)
                  (vars (frame-variables (car lexical-env)))
                  (frame-index 0)
                  (var-index (env-var-index-offset lexical-env)))
         (cond ((null? vars)
                (let ((next-env (cdr env)))
                  (if (null? next-env)
                      #f
                      (let* ((curr-frame (car env))
                             (next-frame (car next-env))
                             (frame-index-incr (if (lexical-frame? curr-frame) 1 0)))
                        (scan next-env
                              (frame-variables next-frame)
                              (+ frame-index frame-index-incr)
                              (frame-index-offset next-frame))))))
               ((eq? (car vars) var)
                (make-lexical-address
                 frame-index
                 var-index
                 env
                 (frame-get-additional-info var (car env))))
               (else
                (scan env (cdr vars) frame-index (+ var-index 1)))))))
 )
