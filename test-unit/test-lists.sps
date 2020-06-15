#!r6rs
(import
 (rnrs base)
 (lists))

(define (assert-equal expected actual text)
  (if (not (equal? expected actual))
      (error text (list expected actual))))

(assert-equal
 '()
 (reject (lambda (x) #f) '())
 "Rejecting from empty list results to empty list")

(assert-equal
 '()
 (reject (lambda (x) #t) '(1 2 3))
 "Rejecting all from a list results to empty list")

(assert-equal
 '(1 2)
 (reject (lambda (x) (> x 2)) '(1 5 2 4 3))
 "Reject removes items from the result for which predicate returns true")

(assert-equal
 #f
 (index-of-equal '() '())
 "index-of-equal from empty list results to #f")

(assert-equal
 #f
 (index-of-equal '(1 2 3) 'a)
 "index-of-equal without a match results to #f")

(assert-equal
 1
 (index-of-equal '(1 a 3) 'a)
 "index-of-equal results to the index of the match")

(assert-equal
 '()
 (make-list 'x 0)
 "make-list with zero length results in empty list")

(assert-equal
 '(x)
 (make-list 'x 1)
 "make-list with length of one results in list with one item")

(assert-equal
 '(x x x)
 (make-list 'x 3)
 "make-list with length of n>1 results in list with n items")

(assert-equal
 '()
 (flatten-n 1 '())
 "flatten-n of empty list results in empty list")

(assert-equal
 'x
 (flatten-n 1 'x)
 "flatten-n of a value results in the value")

(assert-equal
 '(1 2 3)
 (flatten-n 1 '(1 2 3))
 "flatten-n of a flat list results in the list")

(assert-equal
 '(1 (2) 3)
 (flatten-n 0 '(1 (2) 3))
 "flatten-n of a 1-nested list with n=0 results in the list")

(assert-equal
 '(1 2 3)
 (flatten-n 1 '(1 (2) 3))
 "flatten-n of a 1-nested list with n=1 results in a flat list")

(assert-equal
 '(1 2 3)
 (flatten-n 2 '(1 (2) 3))
 "flatten-n of a 1-nested list with n=2 results in a flat list")

(assert-equal
 '(1 (2 3) 4)
 (flatten-n 1 '(1 ((2 3) 4)))
 "flatten-n of a 2-nested list with n=1 results in a 1-nested list")

(assert-equal
 '(1 2 3 4)
 (flatten-n 2 '(1 ((2 3) 4)))
 "flatten-n of a 2-nested list with n=2 results in a flat list")
