#!r6rs
(library
 (compilation-error)
 (export make-compilation-error compilation-error?
         compilation-error-message compilation-error-object
         raise-as-error raise-if-error)
 (import (rnrs base))

 (define (make-compilation-error message object)
   (list make-compilation-error message object))

 (define (compilation-error? x)
   (and (list? x) (eq? (car x) make-compilation-error)))

 (define (compilation-error-message e) (cadr e))
 (define (compilation-error-object e) (caddr e))

 (define (raise-as-error e)
   (error (compilation-error-message e) (compilation-error-object e)))

 (define (raise-if-error x)
   (if (compilation-error? x)
       (raise-as-error x)))
)
