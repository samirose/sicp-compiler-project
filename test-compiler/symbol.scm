(define-library
    (symbol)

  (export
   literal-symbol-is-symbol
   literal-symbols-with-same-name-are-eq
   literal-symbols-with-different-name-are-not-eq
   literal-symbols-as-values-are-symbols
   symbol-may-contain-special-characters)

  (import (scheme base))

  (begin
    (define (literal-symbol-is-symbol)
      (symbol? 'foo))

    (define s1 'foo)
    (define s2 'foobar)

    (define (literal-symbols-with-same-name-are-eq)
      (and (eq? 'foo 'foo) (eq? s1 'foo)))

    (define (literal-symbols-with-different-name-are-not-eq)
      (or (eq? 'baz s1) (eq? s1 s2)))

    (define (is-symbol? x)
      (symbol? x))

    (define (get-symbol)
      'got-symbol)

    (define (literal-symbols-as-values-are-symbols)
      (let ((symb 'bound-symbol))
        (and
         (is-symbol? 'foobar)
         (is-symbol? s2)
         (symbol? (get-symbol))
         (symbol? symb))))

    (define (symbol-may-contain-special-characters)
      (let ((symb '|"foo" \t\n\r\\'bar'😀!@\x7f;\x07;|))
        (symbol? symb)))
    )
  )
