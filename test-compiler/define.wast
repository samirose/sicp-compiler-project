(assert_return (invoke "define-constants") (i32.const 42))
(assert_return (invoke "define-combinations") (i32.const 43))
(assert_return (invoke "define-procedure") (i32.const 16))
(assert_return (invoke "define-procedure-with-lambda") (i32.const 25))
