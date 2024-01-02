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

(compiler-test-eq
 "string=? evaluates to true for two empty literal strings"
 #t (string=?-empty-literal-strings))

(compiler-test-eq
 "string=? evaluates to true for two equal one-character literal strings"
 #t (string=?-one-char-equal-strings))

(compiler-test-eq
 "string=? evaluates to false for two nonequal one-character literal strings"
 #f (string=?-one-char-nonequal-strings))

(compiler-test-eq
 "string=? evaluates to true for two literal strings with equal content"
 #t (string=?-literal-strings-with-equal-content))

(compiler-test-eq
 "string=? evaluates to false for two literal strings with same length but nonequal content"
 #f (string=?-literal-strings-with-same-length-nonequal-content))

(compiler-test-eq
 "string=? evaluates to false for two literal strings with different length"
 #f (string=?-literal-strings-with-different-length))

(compiler-test-error
 "string=? expectes a string as its first argument"
 (string=?-expects-string-first-argument) expected-string)

(compiler-test-error
 "string=? expectes a string as its second argument"
 (string=?-expects-string-second-argument) expected-string)

(compiler-test-end "string")
