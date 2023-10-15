(import (compiler-test)
	(symbol))

(compiler-test-begin "symbol")

(compiler-test-eq
 "literal symbol is symbol"
 #t (literal-symbol-is-symbol))

(compiler-test-eq
 "eq? is true for literal symbols with same name"
 #t (literal-symbols-with-same-name-are-eq))

(compiler-test-eq
 "eq? is false for literal symbols with different name"
 #f (literal-symbols-with-different-name-are-not-eq))

(compiler-test-eq
 "literal symbols as values are symbols"
 #t (literal-symbols-as-values-are-symbols))

(compiler-test-eq
 "literal symbol names may contain special characters"
 #t (symbol-may-contain-special-characters))

(compiler-test-end "symbol")
