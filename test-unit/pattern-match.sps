#!r6rs
(import
 (rnrs base)
 (pattern-match)
 (assert))

(define (assert-matches pat exp message)
  (assert-equal
   #t
   (pattern-match pat exp)
   message))

(define (assert-does-not-match pat exp message)
  (assert-equal
   #f
   (pattern-match pat exp)
   message))

(assert-matches '() '()  "Empty list matches an empty list")
(assert-matches 'a 'a "Symbol matches the same symbol")
(assert-matches 10 10 "Number matches an equal number")
(assert-matches "str" "str" "String matches an equal string")
(assert-matches #f #f "Boolean false matches boolean false")
(assert-matches #t #t "Boolean true matches boolean true")
(assert-matches symbol? 'x
                "An object matches a predicate procedure that returns true for the object")
(assert-matches '(a b (1 2) "c" #t) '(a b (1 2) "c" #t)
                "List matches a list with the same structure and values")
(assert-matches `(a ,symbol? (,number? 2)) '(a b (1 2))
                "Predicate procedures match items in a list")
(assert-matches ?? 123 "The ?? operator matches any single object")
(assert-matches `(a b ,?? "c" ,??) '(a b (1 2) "c" #t)
                "The ?? operator matches any single item in a list")

(assert-does-not-match '() '(1)  "Empty list does not match a non-empty list")
(assert-does-not-match 'a 'b "Symbol does not match a different symbol")
(assert-does-not-match 10 42 "Number does not match an unequal number")
(assert-does-not-match "foo" "bar" "String does not match an unequal string")
(assert-does-not-match #t #f "Boolean false does not match a boolean true")
(assert-does-not-match #f #t "Boolean true does not match a boolean false")
(assert-does-not-match symbol? 10
                       "An object does not match a predicate procedure that returns false for the object")
(assert-does-not-match '(a b 1 2 "c" #t) '(a b (1 2) "c" #t)
                       "List does not match a list with the same values but different structure")
(assert-does-not-match 'a '(a b) "List does not match a non-list")
(assert-does-not-match '(a b) 'a "Non-list does not match a list")
(assert-does-not-match `(a ,symbol? (,symbol? ,number?)) '(a b (1 2))
                       "A list does not match a when predicate procedure returns false for an item in the list")
(assert-does-not-match `(a ,symbol? (,number?)) '(a b (1 2))
                       "Predicate procedures do not match multiple items in a list")
(assert-does-not-match `(a b (1 2) ,??) '(a b (1 2) "c" #t)
                       "The ?? operator does not match multiple items in a list")
(assert-does-not-match `(a b (1 2) ,??) '(a b (1 2) "c" #t)
                       "The ?? operator does not match multiple items in a list")
