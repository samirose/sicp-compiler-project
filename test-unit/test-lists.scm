(import
 (scheme base)
 (lists)
 (assert))

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

(assert-equal
 '() (replace-seqs '() '() '())
 "replace-seqs of an empty sequence with empty sequence from an empty list is empty list")

(assert-equal
 '() (replace-seqs '() '(a b) '())
 "replace-seqs of an empty sequence with any sequence from an empty list is empty list")

(assert-equal
 '() (replace-seqs '(x y) '(a b) '())
 "replace-seqs of any sequence with any sequence from an empty list is empty list")

(assert-equal
 '(x) (replace-seqs '() '(a b) '(x))
 "replace-seqs an empty sequence with any sequence from any list results to the list")

(assert-equal
 '(2 3) (replace-seqs '(1) '() '(1 2 3))
 "replace-seqs a sequence from start of a list with empty list results in rest of the list")

(assert-equal
 '(3) (replace-seqs '(1 2) '() '(1 2 3))
 "replace-seqs a sequence from start of a list with empty list results in rest of the list")

(assert-equal
 '() (replace-seqs '(1 2 3) '() '(1 2 3))
 "replace-seqs the whole list with empty list results in empty list")

(assert-equal
 '(1 2) (replace-seqs '(3) '() '(1 2 3))
 "replace-seqs a sequence from end of a list with empty list results in head of the list")

(assert-equal
 '(1) (replace-seqs '(2 3) '() '(1 2 3))
 "replace-seqs a sequence from end of a list with empty list results in head of the list")

(assert-equal
 '(a b c) (replace-seqs '(1 2 3) '(a b c) '(1 2 3))
 "replace-seqs a sequence equal to the list results in the replacement list")

(assert-equal
 '(1 2 3) (replace-seqs '(0 1) '(a b) '(1 2 3))
 "replace-seqs a sequence not in the list results in the original list")

(assert-equal
 '(1 2 3) (replace-seqs '(3 4) '(x y) '(1 2 3))
 "replace-seqs a sequence not in the list results in the original list")

(assert-equal
 '(1 2 3) (replace-seqs '(5) '(a)  '(1 2 3))
 "replace-seqs a sequence not in the list results in the original list")

(assert-equal
 '(1 a 4 a 5 a 2) (replace-seqs '(2 3) '(a) '(1 2 3 4 2 3 5 2 3 2))
 "replace-seqs a sequence replaces all occurences of it from the list")

(assert-equal
 '(a b c a b c) (replace-seqs '(1 2) '(a b c) '(1 2 1 2))
 "replace-seqs a sequence replaces all occurences of it from the list")

(assert-equal
 '(a b a b) (replace-seqs '(1 2) '(a b) '(1 2 1 2))
 "replace-seqs a sequence replaces all occurences of it from the list")

(assert-equal
 '(1 4 5 2) (replace-seqs '(2 3) '() '(1 2 3 4 2 3 5 2 3 2))
 "replace-seqs a sequence with empty list removes all occurences of sequence from the list")

(assert-equal
 '() (replace-seqs '(1 2) '() '(1 2 1 2))
 "replace-seqs a sequence with empty list removes all occurences of sequence from the list")
