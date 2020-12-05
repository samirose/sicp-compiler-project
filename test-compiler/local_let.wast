(assert_return (invoke "constant-let") (i32.const 42))
(assert_return (invoke "expression-let") (i32.const 30))
(assert_return (invoke "multi-variable-let") (i32.const 6))
(assert_return (invoke "nested-let") (i32.const 6))
(assert_return (invoke "let-shadowing-let") (i32.const 10))
(assert_return (invoke "let-in-lambda") (i32.const 10))
(assert_return (invoke "lambda-as-let-value") (i32.const 12))
(assert_return (invoke "let-value-referring-lambda-arg") (i32.const 18))
(assert_return (invoke "let-value-shadowing-lambda-arg") (i32.const 36))
(assert_return (invoke "get-global-with-let-value") (i32.const 5))
(assert_return (invoke "main") (i32.const 9))
