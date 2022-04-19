(define-library (lists)

 (export partition-list
         index-of-equal
         first-duplicate
         make-list
         flatten-n
         all?)

 (import (scheme  base))

 (begin
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

   (define (all? p? l)
     (cond ((null? l))
           ((p? (car l)) (all? p? (cdr l)))
           (else #f)))

   ))
