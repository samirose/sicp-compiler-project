#lang sicp

(#%provide (all-defined))

(define (filter predicate sequence)
  (cond ((null? sequence) nil)
        ((predicate (car sequence))
         (cons (car sequence)
               (filter predicate (cdr sequence))))
        (else (filter predicate (cdr sequence)))))

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
