#!r6rs
(library
 (lexical-env)

 (export make-empty-lexical-env
         global-lexical-env?
         add-new-lexical-frame
         add-new-local-frame
         add-new-local-temporaries-frame
         find-variable
         frame-index
         var-index
         additional-info
         global-address?
         env-add-additional-info
         env-get-additional-info
         env-var-index-offset)

 (import (rnrs base)
         (rnrs lists)
         (lists))

 (define (make-empty-lexical-env) '())

 (define (global-lexical-env? lexical-env)
   (and (not (null? lexical-env))
        (null? (cdr lexical-env))))

 (define (make-frame frame-index-offset var-index-offset variables additional-info-map)
   (list (cons frame-index-offset var-index-offset) variables additional-info-map))

 (define (make-lexical-frame variables additional-info-map)
   (make-frame 1 0 variables additional-info-map))

 (define (make-local-frame lexical-env variables additional-info-map)
   (let ((vars-offset
          (if (global-lexical-env? lexical-env)
              0
              (let* ((curr-frame (car lexical-env))
                     (curr-frame-length (length (frame-variables curr-frame)))
                     (curr-var-index-offset (var-index-offset curr-frame)))
                (+ curr-var-index-offset curr-frame-length)))))
     (make-frame 0 vars-offset variables additional-info-map)))

 (define (frame-index-offset frame)
   (caar frame))

 (define (var-index-offset frame)
   (cdar frame))

 (define (env-var-index-offset lexical-env)
   (if (null? lexical-env)
       0
       (var-index-offset (car lexical-env))))

 (define (frame-variables frame)
   (cadr frame))

 (define (frame-additional-info-map frame)
   (caddr frame))

 (define (frame-get-additional-info var frame)
   (map cadr
        (filter
         (lambda (entry) (eq? (car entry) var))
         (frame-additional-info-map frame))))

 (define (env-get-additional-info var lexical-env)
   (if (null? lexical-env)
       '()
       (frame-get-additional-info var (car lexical-env))))

 (define (add-new-lexical-frame lexical-env variables additional-info-map)
   (cons (make-lexical-frame variables additional-info-map)
         lexical-env))

 (define (add-new-local-frame lexical-env variables additional-info-map)
   (if (null? lexical-env)
       (error "Internal compiler error: cannot add new local frame to an empty environment" variables)
       (cons (make-local-frame lexical-env variables additional-info-map)
             lexical-env)))

 (define (add-new-local-temporaries-frame lexical-env n)
   (add-new-local-frame lexical-env (make-list '() n) '()))

 (define (update-head-frame map-frame lexical-env)
   (cons (map-frame (car lexical-env)) (cdr lexical-env)))

 (define (add-additional-info var additional-info additional-info-map)
   (cons (list var additional-info) additional-info-map))

 (define (env-add-additional-info lexical-env var additional-info)
   (update-head-frame
    (lambda (head-frame)
      (make-frame
       (frame-index-offset head-frame)
       (var-index-offset head-frame)
       (frame-variables head-frame)
       (add-additional-info var additional-info (frame-additional-info-map head-frame))))
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
                      (let ((curr-frame (car env))
                            (next-frame (car next-env)))
                        (scan next-env
                              (frame-variables next-frame)
                              (+ frame-index (frame-index-offset curr-frame))
                              (var-index-offset next-frame))))))
               ((eq? (car vars) var)
                (make-lexical-address
                 frame-index
                 var-index
                 env
                 (frame-get-additional-info var (car env))))
               (else
                (scan env (cdr vars) frame-index (+ var-index 1)))))))
 )
