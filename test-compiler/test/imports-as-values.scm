(import (compiler-test)
	(imports-as-values))

(compiler-test-begin "imports-as-values")

(compiler-test-eq
 "Imported procedure value is a procedure"
 #t (imported-procedure-value-is-procedure))

(compiler-test-eq
 "number? can be applied as a value"
 #t (apply-number?-as-value 42))

(compiler-test-eq
 "number? can be applied as a value"
 #f (apply-number?-as-value #t))

(compiler-test-end "imports-as-values")
