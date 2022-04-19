(import
 (rnrs base)
 (lists)
 (assert))

(assert-equal
 (cons '() '())
 (partition-list even? '())
 "Partitioning an empty list returns a pair of empty lists")

(assert-equal
 (cons '(2 4 6) '())
 (partition-list even? '(2 4 6))
 "Partitioning a list with all matching elements returns all elements in car")

(assert-equal
 (cons '() '(1 3 5))
 (partition-list even? '(1 3 5))
 "Partitioning a list with all non-matching elements returns all elements in cdr")

(assert-equal
 (cons '(4 2 6) '(3 1 1 5 9))
 (partition-list even? '(3 1 4 1 5 9 2 6))
 "Partitioning a list with collects matching elements to car and non-matching to cdr")

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
 (first-duplicate '())
 "Empty list does not contain duplicates")

(assert-equal
 '()
 (first-duplicate '(1))
 "List of one element does not contain duplicates")

(assert-equal
 '()
 (first-duplicate '(1 2 3 a))
 "List without duplicates does not contain duplicates")

(assert-equal
 '(2)
 (first-duplicate '(1 2 3 a b 2))
 "first-duplicate returns the remaining list starting from the first found duplicate")

(assert-equal
 '(2 a b)
 (first-duplicate '(1 2 3 2 a b))
 "first-duplicate returns the remaining list starting from the first found duplicate")

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

(assert-equal
 #t (all? number? '())
 "all is true for an empty list")

(assert-equal
 #t (all? number? '(1 2 3))
 "all is true for a list where the predicate is true for all items")

(assert-equal
 #f (all? number? '(1 2 'foo 3))
 "all is false for a list where the predicate is false for any item")
