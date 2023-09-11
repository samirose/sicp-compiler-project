(define-library (wasm-syntax)

  (export wasm-definition-type wasm-definition-type?
          wasm-elem-definition-func-index
          wasm-const-value?
          wasm-define-locals wasm-locals-definition? wasm-local-definitions-to-top
          wasm-import-definition?
          wasm-data-offset wasm-data-length wasm-data-value wasm-data-definition)

  (import (scheme base)
          (scheme cxr)
          (srfi srfi-60)
          (lists)
          (pattern-match))

  (begin
    (define (wasm-definition-type wasm-definition)
      (car wasm-definition))

    (define (wasm-definition-type? type wasm-definition)
      (eq? (wasm-definition-type wasm-definition) type))

    (define (wasm-elem-definition-func-index elem-definition)
      (cadr elem-definition))

    (define wasm-const-instructions
      '(i32.const f32.const))

    (define (wasm-const-instruction? instr)
      (memq instr wasm-const-instructions))

    (define (wasm-const-value? instr)
      (pattern-match? `(,wasm-const-instruction? ,??) instr))

    (define (wasm-define-locals type n)
      (cons 'local (make-list n type)))

    (define (wasm-locals-definition? exp)
      (pattern-match? `(local ,?? ,??*) exp))

    (define (wasm-local-definitions-to-top seq)
      (let ((split-code (partition-list wasm-locals-definition? seq)))
	(append (car split-code) (cdr split-code))))

    (define (wasm-import-definition? exp)
      (cond ((null? exp) #f)
            ((pattern-match? `(import ,string? ,??*) exp))
            ((pattern-match? `((import ,string? ,??*) ,??*) exp))
            (else (wasm-import-definition? (cdr exp)))))

    (define (wasm-data-offset exp)
      (cadr exp))

    (define (wasm-data-length exp)
      (caddr exp))

    (define (wasm-data-value exp)
      (cadddr exp))

    (define (byte-as-data-char byte)
      (string-append
       "\\"
       (if (< byte #x10) "0" "")
       (number->string byte 16)))

    (define (word-as-data-chars word)
      (fold
       (lambda (sr result)
         (string-append
          result
          (byte-as-data-char (bitwise-and (arithmetic-shift word sr) #xff))))
       ""
       '(0 -8 -16 -24)))

    (define (value-as-data-chars v)
      (cond ((and (number? v) (<= #x00 v #xff)) ; byte
             (cons (byte-as-data-char v) 1))
             ((and (number? v) (<= 0 v #xffffffff)) ; 32bit word
              (cons (word-as-data-chars v) 4))
             ((number? v)
              (error "Unsupported number" v))
             ((string? v)
              (cons v (bytevector-length (string->utf8 v))))
             (else
              (error "Unsupported data value" v))))

      (define (make-wasm-data-value vs)
        (cond ((null? vs) (cons "" 0))
              ((pair? vs)
               (fold
                (lambda (v r)
                  (let ((r' (value-as-data-chars v)))
                    (cons (string-append (car r) (car r')) (+ (cdr r) (cdr r')))))
                (cons "" 0)
                vs))
              (else (value-as-data-chars vs))))

      (define (wasm-data-definition offset values)
        (let ((dl (make-wasm-data-value values)))
          `(data-with-length ,offset ,(cdr dl) ,(car dl))))

      ))
