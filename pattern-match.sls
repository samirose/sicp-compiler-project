#!r6rs

(library
 (pattern-match)
 (export pattern-match ??)
 (import (rnrs base))

 (define (pattern-match pat exp)
   (let match ((pat pat) (exp exp))
     (cond ((eq? ?? pat) #t)
           ((null? exp) (null? pat))
           ((pair? exp)
            (and (pair? pat)
                 (match (car pat) (car exp))
                 (match (cdr pat) (cdr exp))))
           ((procedure? pat) (pat exp))
           ((boolean? exp) (eq? pat exp))
           ((symbol? exp) (eq? pat exp))
           ((number? exp) (and (number? pat) (= pat exp)))
           ((string? exp) (and (string? pat) (eqv? pat exp)))
           (else (error "Pattern matching not supported for" exp)))))

 (define ?? (list 'match-anything))

 )
