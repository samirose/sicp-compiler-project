#!r6rs
(library
 (assert)
 (export assert-equal)
 (import (rnrs base))

 (define (assert-equal expected actual text)
   (if (not (equal? expected actual))
       (error text (list expected actual))))
 )
