(import (compiler-test)
	(string))

(compiler-test-begin "string")

(compiler-test-eq
 "literal string is string"
 #t (literal-string-is-string))

(compiler-test-eq
 "literal strings as values are strings"
 #t (literal-strings-as-values-are-strings))

(compiler-test-eq
 "literal string may contain special characters"
 #t (string-may-contain-special-characters))

(compiler-test-end "string")
