(module
  (global $errorcode (mut i32) (i32.const 0))
  (func (export "get_error") (result i32) (global.get $errorcode))
  (func (export "test")
    (global.set $errorcode (i32.const 42))
    (unreachable)
    ))

(assert_trap (invoke "test") "unreachable")
(assert_return (invoke "get_error") (i32.const 42))
