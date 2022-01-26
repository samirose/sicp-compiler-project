(module
  (func (export "test1") (result i32) (i32.const 1))
  (func (export "test2") (result i32) (i32.const 2)))
(register "test-module")

(module $use-module
  (func (import "test-module" "test2") (result i32))
  (func (import "test-module" "test1") (result i32))

  ;; Local function
  (func $local-func (param i32 i32) (result i32)
    (local.get 0) (local.get 1) (i32.sub))

  (func (export "test") (result i32)
    (call 0) ;; Expect to call "test2"
    (call 1) ;; Expect to call "test1"
    (call 2) ;; Expect to call $local-func
  )

  (export "test2-2" (func 0))
)

(assert_return (invoke "test") (i32.const 1))
(assert_return (invoke "test2-2") (i32.const 2))
