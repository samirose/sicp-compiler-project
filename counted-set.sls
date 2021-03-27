#!r6rs
(library
 (counted-set)

 (export make-counted-set counted-set-add counted-set-count counted-set-unique-keys)

 (import (rnrs base)
         (rnrs lists))

 (define (make-counted-set) '())

 (define (counted-set-add s key amount)
   (let* ((existing (assq key s))
          (count (if existing
                     (+ (cdr existing) amount)
                     amount))
          (new-head (cons key count))
          (rest (filter (lambda (entry) (not (eq? key (car entry)))) s)))
     (cons new-head rest)))

 (define (counted-set-count s key)
   (let ((existing (assq key s)))
     (if existing (cdr existing) 0)))

 (define (counted-set-unique-keys s)
   (length s))
 )
