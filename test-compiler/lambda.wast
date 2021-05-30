(assert_return (invoke "lambda-application") (i32.const 4))
(assert_return (invoke "lambda-argument") (i32.const 120))
(assert_return (invoke "lambda-without-parameters") (i32.const 42))
