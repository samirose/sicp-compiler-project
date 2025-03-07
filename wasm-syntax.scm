(define-library (wasm-syntax)

  (export wasm-definition-type wasm-definition-type?
          wasm-elem-definition-func-index
          wasm-const-value?
          wasm-define-locals wasm-locals-definition? wasm-local-definitions-to-top
          wasm-import-definition?
          i32-as-wasm-data string-as-wasm-data
          emit-wat)

  (import (scheme base)
          (scheme cxr)
          (scheme write)
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
      (let-values (((local-definitions statements)
                    (partition wasm-locals-definition? seq)))
	(append local-definitions statements)))

    (define (wasm-import-exp? exp)
      (pattern-match? `(import ,string? ,string?) exp))

    (define (wasm-import-definition? exp)
      (or (pattern-match? `(global ,wasm-import-exp? ,?? ,??*) exp)
          (pattern-match? `(func ,wasm-import-exp? ,?? ,??*) exp)))

    (define (i32-as-wasm-data n)
      (do ((bytes (make-bytevector 4))
           (i 0 (+ i 1)))
          ((= i 4) (values bytes 4))
        (bytevector-u8-set!
         bytes
         i
         (bitwise-and
          (arithmetic-shift n (* -8 i))
          #xff))))

    (define (string-as-wasm-data s)
      (values s (bytevector-length (string->utf8 s))))

    (define (emit-wat-string-char c port)
      ;; W3C / WebAssembly Core Specification / 6.3.3. Strings
      (cond
       ((char=? c #\x09) (write-string "\\t" port))
       ((char=? c #\x0A) (write-string "\\n" port))
       ((char=? c #\x0D) (write-string "\\r" port))
       ((char=? c #\x22) (write-string "\\\"" port))
       ((char=? c #\x27) (write-string "\\'" port))
       ((char=? c #\x5C) (write-string "\\\\" port))
       ((and (char>=? c #\x20) (not (char=? c #\x7F)))
        (write-char c port))
       ((or (char<=? c #\xD7FF) (char<=? #\xE000 c #\x10FFFF))
        (write-string "\\u{" port)
        (write-string (number->string (char->integer c) 16) port)
        (write-char #\} port))
       (else (error "Invalid UNICODE character" c))))

    (define (emit-wat-string s port)
      (write-char #\" port)
      (string-for-each
       (lambda (c) (emit-wat-string-char c port))
       s)
      (write-char #\" port))

    (define (emit-wat-bytes bytes port)
      (write-char #\" port)
      (do ((hexchars "0123456789abcdef")
           (i 0 (+ i 1))
           (l (bytevector-length bytes)))
          ((= i l))
        (let* ((b (bytevector-u8-ref bytes i))
               (hn (bitwise-and (arithmetic-shift b -4) #x0f))
               (ln (bitwise-and b #x0f)))
          (write-char #\\ port)
          (write-char (string-ref hexchars hn) port)
          (write-char (string-ref hexchars ln) port)))
      (write-char #\" port))

    (define (emit-wat-cont ast port k)
      (cond
       ((null? ast)
        (k))
       ((number? ast)
        (write-string (number->string ast) port) (k))
       ((symbol? ast)
        (write-string (symbol->string ast) port) (k))
       ((string? ast)
        (emit-wat-string ast port) (k))
       ((bytevector? ast)
        (emit-wat-bytes ast port) (k))
       ((pair? ast)
        (write-char #\( port)
        (let loop ((lst ast))
          (emit-wat-cont
           (car lst)
           port
           (if (null? (cdr lst))
               (lambda ()
                 (write-char #\) port)
                 (k))
               (lambda ()
                 (write-char #\ port)
                 (loop (cdr lst)))))))
       (else (error "Usupported WAT AST element" ast))))

    (define (emit-wat ast port)
      (emit-wat-cont ast port (lambda () (newline port))))

    ))
