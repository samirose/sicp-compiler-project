#!r6rs
(library
 (assert)

 (export assert-equal
         install-test-compilation-error-handler! assert-raises-compilation-error)

 (import (rnrs base)
         (rnrs exceptions)
         (compilation-error))

 (define (assert-equal expected actual text)
   (if (not (equal? expected actual))
       (error text (list expected actual))))

 (define (make-test-compilation-error message object)
   (list 'test-compilation-error message object))

 (define (test-compilation-error? e)
   (and (list? e) (eq? (car e) 'test-compilation-error)))

 (define (assert-equal-test-compilation-error expected actual)
   (assert-equal (cadr expected) (cadr actual) "Error messages should be equal")
   (assert-equal (caddr expected) (caddr actual) "Error objects should be equal"))

 (define (error-handler message object)
   (raise (make-test-compilation-error message object)))

 (define (install-test-compilation-error-handler!)
   (set-compilation-error-handler! error-handler))

 (define (assert-raises-compilation-error action expected-message expected-object description)
   (let ((expected-error (make-test-compilation-error expected-message expected-object)))
     (guard (cond
              ((test-compilation-error? cond)
               (assert-equal-test-compilation-error expected-error cond)
               expected-error))
            (let ((result (action)))
              (if (not (eq? result expected-error))
                  (error description (list (cdr expected-error) result)))))))
 )
