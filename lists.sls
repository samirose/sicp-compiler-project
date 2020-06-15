#!r6rs
(library
 (lists)
 (export reject index-of-equal make-list flatten-n)
 (import (rnrs base)
         (rnrs lists))

 (define (reject predicate sequence)
   (filter (lambda (elem) (not (predicate elem))) sequence))

 (define (index-of-equal l e)
   (letrec
       ((search
         (lambda (l i)
           (cond ((null? l) #f)
                 ((equal? (car l) e) i)
                 (else (search (cdr l) (+ i 1)))))))
     (search l 0)))

 (define (make-list e n)
   (letrec
       ((loop
         (lambda (l e n)
           (if (= n 0)
               l
               (loop (cons e l) e (- n 1))))))
     (if (< n 0)
         (error "Expected positive n -- make-list:" n)
         (loop '() e n))))

 (define (tolist x)
   (if (pair? x) x (list x)))

 (define (flatten-n n x)
   (cond ((null? x) '())
         ((= n 0) x)
         ((pair? x)
          (append
           (flatten-n (- n 1) (tolist (car x)))
           (flatten-n n (cdr x))))
         (else x)))
 )
