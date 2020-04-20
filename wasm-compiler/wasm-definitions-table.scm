#lang sicp
(#%require "lists.scm")
(#%provide make-wasm-definitions-table)

(define (make-definition-list)
  (let*
      ((head '())
       (tail head)
       (next-index 0))
    (lambda (m)
      (cond
        ((eq? m 'add!)
         (lambda (definition)
           (let ((new-pair (cons definition '()))
                 (index next-index))
             (cond ((null? head)
                    (set! head new-pair)
                    (set! tail new-pair))
                   (else
                    (set-cdr! tail new-pair)
                    (set! tail new-pair)))
             (set! next-index (+ index 1))
             index)))
        ((eq? m 'definitions)
         head)
        (else
         (error "Unknown message -- definition-list:" m))))))

(define (make-wasm-definitions-table)
  (let*
      ((definition-keys '(type func table elem))
       (definitions-table
         (map (lambda (key)
                (cons key (make-definition-list)))
              definition-keys))
       (definition-vector
         (lambda (tag)
           (let ((entry (assq tag definitions-table)))
             (if entry
                 (cdr entry)
                 (error "Unsupported definition type -- definitions-table:" tag))))))
    (lambda (m)
      (cond
        ((eq? m 'add-definition!)
         (lambda (definition)
           (((definition-vector (car definition)) 'add!) definition)))
        ((eq? m 'definition-index)
         (lambda (definition)
           (index-of-equal
            ((definition-vector (car definition)) 'definitions)
            definition)))
        ((eq? m 'definitions-of-type)
         (lambda (type)
           ((definition-vector type) 'definitions)))
        ((eq? m 'definitions)
         (apply append
                (map (lambda (entry)
                       ((cdr entry) 'definitions))
                     definitions-table)))
        (else
         (error "Unknown message -- wasm-module"))))))
