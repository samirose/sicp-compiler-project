(assert_return (invoke "if-true") (i32.const 1))
(assert_return (invoke "if-true-consquent-only") (i32.const 3))
(assert_return (invoke "if-false") (i32.const 2))
(assert_return (invoke "if-false-consquent-only") (i32.const 1))
(assert_return (invoke "if-lambda-condition") (i32.const 1))
(assert_return (invoke "if-lambda-consquent") (i32.const 2))
(assert_return (invoke "if-lambda-alternative") (i32.const 4))
