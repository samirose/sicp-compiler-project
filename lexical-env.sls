#!r6rs
(library
 (lexical-env)

 (export make-empty-lexical-env
         global-lexical-env?
         add-new-top-level-frame
         add-new-lexical-frame
         add-new-local-frame
         add-new-local-temporaries-frame
         find-variable
         frame-index
         var-index
         additional-info
         global-address?
         set-as-current-binding
         env-get-current-binding
         env-get-additional-info
         env-var-index-offset)

 (import (rnrs base)
         (rnrs lists)
         (lists))

 (define (make-empty-lexical-env) '())

 (define (add-frame lexical-env frame)
   (cons frame lexical-env))

 (define (head-frame lexical-env)
   (car lexical-env))

 (define (rest-frames lexical-env)
   (cdr lexical-env))

 (define (global-lexical-env? lexical-env)
   (and (not (null? lexical-env))
        (null? (rest-frames lexical-env))))

 (define (make-frame frame-index-offset var-index-offset variables additional-info-map current-binding)
   (list
    current-binding
    (list frame-index-offset var-index-offset (length variables))
    (reverse variables)
    additional-info-map))

 (define (with-current-binding frame current-binding)
   (cons current-binding (cdr frame)))

 (define (make-top-level-frame var-index-offset variables additional-info-map)
   (make-frame 0 var-index-offset variables additional-info-map #f))

 (define (make-lexical-frame variables additional-info-map)
   (make-frame 1 0 variables additional-info-map #f))

 (define (make-local-frame lexical-env variables additional-info-map)
   (let ((vars-offset
          (if (global-lexical-env? lexical-env)
              0
              (let* ((curr-frame (head-frame lexical-env))
                     (curr-frame-length (var-count curr-frame))
                     (curr-var-index-offset (var-index-offset curr-frame)))
                (+ curr-var-index-offset curr-frame-length)))))
     (make-frame 0 vars-offset variables additional-info-map #f)))

 (define (frame-indices frame)
   (cadr frame))

 (define (frame-index-offset frame)
   (car (frame-indices frame)))

 (define (var-index-offset frame)
   (cadr (frame-indices frame)))

 (define (var-count frame)
   (caddr (frame-indices frame)))

 (define (last-var-index frame)
   (+ (var-count frame) -1 (var-index-offset frame)))

 (define (env-var-index-offset lexical-env)
   (if (null? lexical-env)
       0
       (var-index-offset (head-frame lexical-env))))

 (define (reversed-frame-variables frame)
   (caddr frame))

 (define (frame-additional-info-map frame)
   (cadddr frame))

 (define (frame-current-binding frame)
   (car frame))

 (define (frame-get-additional-info var frame)
   (map cadr
        (filter
         (lambda (entry) (eq? (car entry) var))
         (frame-additional-info-map frame))))

 (define (env-get-additional-info var lexical-env)
   (if (null? lexical-env)
       '()
       (frame-get-additional-info var (head-frame lexical-env))))

 (define (add-new-lexical-frame lexical-env variables additional-info-map)
   (add-frame lexical-env (make-lexical-frame variables additional-info-map)))

 (define (add-new-top-level-frame lexical-env var-index-offset variables additional-info-map)
   (add-frame lexical-env (make-top-level-frame var-index-offset variables additional-info-map)))

 (define (add-new-local-frame lexical-env variables additional-info-map)
   (if (null? lexical-env)
       (error "Internal compiler error: cannot add new local frame to an empty environment" variables)
       (add-frame lexical-env (make-local-frame lexical-env variables additional-info-map))))

 (define (add-new-local-temporaries-frame lexical-env n)
   (add-new-local-frame lexical-env (make-list '() n) '()))

 (define (update-head-frame map-frame lexical-env)
   (add-frame (rest-frames lexical-env) (map-frame (head-frame lexical-env))))

 (define (set-as-current-binding lexical-env var)
   (update-head-frame
    (lambda (head-frame)
      (with-current-binding head-frame (memq var (reversed-frame-variables head-frame))))
    lexical-env))

 (define (env-get-current-binding lexical-env)
   (cond ((null? lexical-env) #f)
         ((frame-current-binding (head-frame lexical-env)) => car)
         (else #f)))

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
                  (vars (reversed-frame-variables (head-frame lexical-env)))
                  (frame-index 0)
                  (var-index (last-var-index (head-frame lexical-env))))
         (cond ((null? vars)
                (let ((next-env (rest-frames env)))
                  (if (null? next-env)
                      #f
                      (let ((curr-frame (head-frame env))
                            (next-frame (head-frame next-env)))
                        (scan next-env
                              (reversed-frame-variables next-frame)
                              (+ frame-index (frame-index-offset curr-frame))
                              (last-var-index next-frame))))))
               ((eq? (car vars) var)
                (make-lexical-address
                 frame-index
                 var-index
                 env
                 (frame-get-additional-info var (head-frame env))))
               (else
                (scan env (cdr vars) frame-index (- var-index 1)))))))
 )
