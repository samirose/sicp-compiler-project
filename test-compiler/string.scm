(define-library
    (string)

  (export
   literal-string-is-string
   literal-strings-as-values-are-strings
   string-may-contain-special-characters
   string=?-empty-literal-strings
   string=?-literal-strings-with-equal-content
   string=?-literal-strings-with-same-length-nonequal-content
   string=?-literal-strings-with-different-length)

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

    (define (string=?-empty-literal-strings)
      (string=? "" ""))

    (define (string=?-literal-strings-with-equal-content)
      (string=? ":foo#😀🤦🏼‍♂️bar!\r\n" ":foo#😀🤦🏼‍♂️bar!\r\n"))

    (define (string=?-literal-strings-with-same-length-nonequal-content)
      (string=? ":foobar#" ":foobaz#"))

    (define (string=?-literal-strings-with-different-length)
      (string=? ":foobar#" ":foobazz#"))
    )
  )
