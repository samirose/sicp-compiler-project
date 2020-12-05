#!r6rs

(library
 (pattern-match)

 (export pattern-match? ?? ??*)

 (import (rnrs base)
         (rnrs lists))

 (define (pattern-match? pat exp)
   (cond
     ((null? pat) (null? exp))
     ((pair? pat)
      (let ((pat-head (car pat)))
        (cond
          ((memq pat-head list-matchers)
           (and (or (pair? exp) (null? exp))
                (pat-head (cdr pat) exp)))
          ((pair? exp)
           (and (pattern-match? (car pat) (car exp))
                (pattern-match? (cdr pat) (cdr exp))))
          (else #f))))
     ((memq pat list-matchers) #f)
     ((procedure? pat) (pat exp))
     ((boolean? pat) (eq? pat exp))
     ((symbol? pat) (eq? pat exp))
     ((number? pat) (and (number? exp) (= pat exp)))
     ((string? pat) (and (string? exp) (eqv? pat exp)))
     (else (error "Pattern matching not supported for" exp))))

 (define (?? exp) #t)

 (define (scan-match pat exp)
   (cond ((null? exp) (null? pat))
         ((pattern-match? pat exp) #t)
         (else (scan-match pat (cdr exp)))))

 (define ??* scan-match)

 (define list-matchers (list ??*))

 )
