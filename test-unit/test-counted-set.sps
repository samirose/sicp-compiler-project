#!r6rs
(import
 (rnrs base)
 (counted-set)
 (assert))

(assert-equal
 0
 (let ((s (make-counted-set)))
   (counted-set-count s 'x))
 "counted-set-count results to 0 with an empty set")

(assert-equal
 0
 (let ((s (make-counted-set)))
   (counted-set-unique-keys s))
 "empty counted-set should have 0 unique keys")

(assert-equal
 0
 (let* ((s (make-counted-set))
        (s (counted-set-add s 'x 1)))
   (counted-set-count s 'y))
 "counted-set-count results to 0 when the key has not been added")

(assert-equal
 1
 (let* ((s (make-counted-set))
        (s (counted-set-add s 'x 1)))
   (counted-set-count s 'x))
 "counted-set-count results to 1 when the key has been added")

(assert-equal
 3
 (let* ((s (make-counted-set))
        (s (counted-set-add s 'x 3)))
   (counted-set-count s 'x))
 "counted-set-count results to amount passed to counted-set-add")

(assert-equal
 2
 (let* ((s (make-counted-set))
        (s (counted-set-add s 'x 1))
        (s (counted-set-add s 'x 1)))
   (counted-set-count s 'x))
 "counted-set-count results to 2 when the key has been added twice")

(assert-equal
 4
 (let* ((s (make-counted-set))
        (s (counted-set-add s 'x 1))
        (s (counted-set-add s 'x 3)))
   (counted-set-count s 'x))
 "counted-set-count results to total of amounts of the same added key")

(assert-equal
 1
 (let* ((s (make-counted-set))
        (s (counted-set-add s 'x 1))
        (s (counted-set-add s 'y 1)))
   (counted-set-count s 'x))
 "counted-set-count results to 1 when the queried key has been added once")

(assert-equal
 1
 (let* ((s (make-counted-set))
        (s (counted-set-add s 'x 1))
        (s (counted-set-add s 'y 1)))
   (counted-set-count s 'y))
 "counted-set-count results to 1 when the queried key has been added once")

(assert-equal
 1
 (let* ((s (make-counted-set))
        (s (counted-set-add s 'x 1))
        (s (counted-set-add s 'x 1)))
   (counted-set-unique-keys s))
 "counted-set should have 1 unique key when the same key has been added twice")
