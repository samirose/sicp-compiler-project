(register "import_scm")

;; Helper module for testing re-exported import
(module
  (import "import_scm" "number?" (func $re-exported-number? (param i32) (result i32)))
  (import "import_scm" "zero?" (func $re-exported-zero? (param i32) (result i32)))

  (func (export "test-number?") (param $x i32) (result i32)
    local.get $x
    call $re-exported-number?)

  (func (export "test-zero?") (param $x i32) (result i32)
    local.get $x
    call $re-exported-zero?)
)

;; i32(1) = fixnum(0), i32(85) = fixnum(42)
(assert_return (invoke "test-number?" (i32.const 1)) (i32.const 85))

;; i32(1) = fixnum(0), i32(22) = boolean(#t)
(assert_return (invoke "test-zero?" (i32.const 1)) (i32.const 22))

;; i32(3) = fixnum(1), i32(6) = boolean(#f)
(assert_return (invoke "test-zero?" (i32.const 3)) (i32.const 6))
