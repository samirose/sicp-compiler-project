(assert_return (invoke "sequence-has-last-value") (i32.const 3))
(assert_return (invoke "sequence-has-last-expressions-value") (i32.const 2))
(assert_return (invoke "all-sequence-expressions-are-evaluated") (i32.const 6))
(assert_return (invoke "sequence-expressions-are-evaluated-in-order") (i32.const 1))
