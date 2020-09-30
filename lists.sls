#!r6rs
(library
 (lists)
 (export reject index-of-equal first-duplicate make-list flatten-n
         make-counted-set counted-set-add counted-set-count counted-set-unique-keys)
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

 (define (first-duplicate l)
   (let search ((l l))
     (cond ((null? l) '())
           ((memq (car l) (cdr l)))
           (else (search (cdr l))))))

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

 (define (flatten-n n x)
   (cond ((null? x) '())
         ((= n 0) x)
         ((pair? x)
          (let ((head (car x)))
            (if (pair? head)
                (append
                 (flatten-n (- n 1) head)
                 (flatten-n n (cdr x)))
                (cons head (flatten-n n (cdr x))))))
         (else x)))

 (define (make-counted-set) '())

 (define (counted-set-add s key)
   (let* ((existing (assq key s))
          (count (if existing
                     (+ (cdr existing) 1)
                     1))
          (new-head (cons key count))
          (rest (reject (lambda (entry) (eq? key (car entry))) s)))
     (cons new-head rest)))

 (define (counted-set-count s key)
   (let ((existing (assq key s)))
         (if existing (cdr existing) 0)))

 (define (counted-set-unique-keys s)
   (length s))
 )
