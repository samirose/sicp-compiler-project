#!r6rs
(library
 (lists)
 (export partition-list index-of-equal first-duplicate make-list flatten-n
         make-counted-set counted-set-add counted-set-remove-all
         counted-set-count counted-set-unique-keys)
 (import (rnrs base)
         (rnrs lists))

 (define (partition-list p l)
   (let collect ((l l)
                 (lt '())
                 (lf '()))
     (cond ((null? l) (cons (reverse lt) (reverse lf)))
           ((p (car l)) (collect (cdr l) (cons (car l) lt) lf))
           (else (collect (cdr l) lt  (cons (car l) lf))))))

 (define (index-of-equal l e)
   (let search ((l l) (i 0))
     (cond ((null? l) #f)
           ((equal? (car l) e) i)
           (else (search (cdr l) (+ i 1))))))

 (define (first-duplicate l)
   (let search ((l l))
     (cond ((null? l) '())
           ((memq (car l) (cdr l)))
           (else (search (cdr l))))))

 (define (make-list e n)
   (if (< n 0)
       (error "Expected positive n -- make-list:" n)
       (let loop ((l '()) (n n))
         (if (= n 0)
             l
             (loop (cons e l) (- n 1))))))

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

 (define (counted-set-remove-all s key)
   (filter (lambda (entry) (not (eq? key (car entry)))) s))

 (define (counted-set-add s key)
   (let* ((existing (assq key s))
          (count (if existing
                     (+ (cdr existing) 1)
                     1)))
     (cons (cons key count)
           (counted-set-remove-all s key))))

 (define (counted-set-count s key)
   (let ((existing (assq key s)))
         (if existing (cdr existing) 0)))

 (define (counted-set-unique-keys s)
   (length s))
 )
