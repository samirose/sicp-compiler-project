(assert_return (invoke "set!-local-lambda") (i32.const 13))
(assert_return (invoke "set!-local-let") (i32.const 13))
(assert_return (invoke "set!-global") (i32.const 13))
(assert_return (invoke "get-global") (i32.const 5))
(invoke "increment-global!")
(assert_return (invoke "get-global") (i32.const 6))
