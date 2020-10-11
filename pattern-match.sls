#!r6rs

(library
 (pattern-match)
 (export pattern-match ?? ??*)
 (import (rnrs base))

 (define (pattern-match pat exp)
   (let match ((pat pat) (exp exp))
     (cond ((eq? pat ??*) #f)
           ((procedure? pat) (pat exp))
           ((null? exp)
            (or (null? pat) (equal? pat (list ??*))))
           ((pair? exp)
            (and (pair? pat)
                 (if (eq? (car pat) ??*)
                     (scan-match (cdr pat) exp)
                     (and (match (car pat) (car exp))
                          (match (cdr pat) (cdr exp))))))
           ((boolean? exp) (eq? pat exp))
           ((symbol? exp) (eq? pat exp))
           ((number? exp) (and (number? pat) (= pat exp)))
           ((string? exp) (and (string? pat) (eqv? pat exp)))
           (else (error "Pattern matching not supported for" exp)))))

 (define (?? exp) #t)

 (define (scan-match pat exp)
   (cond ((null? exp) (null? pat))
         ((pattern-match pat exp) #t)
         (else (scan-match pat (cdr exp)))))

 (define (??* pat exp)
   (and (pair? pat)
        (pair? exp)
        (scan-match (cdr pat) exp)))

 )
