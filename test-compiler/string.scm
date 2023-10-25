(define-library
    (string)

  (export
   literal-string-is-string
   literal-strings-as-values-are-strings
   string-may-contain-special-characters)

  (import (scheme base))

  (begin
    (define (literal-string-is-string)
      (string? "foo"))

    (define s1 "foobar")

    (define (is-string? x)
      (string? x))

    (define (get-string)
      "got string")

    (define (literal-strings-as-values-are-strings)
      (let ((str "bound string"))
        (and
         (is-string? "foobar")
         (is-string? s1)
         (string? (get-string))
         (string? str))))

    (define (string-may-contain-special-characters)
      (let ((str "foo \t\n\r\\'bar' 😀 🤦🏼‍♂️ !@\x7f;\x07;"))
        (string? str)))
    )
  )
