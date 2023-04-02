(register "import_scm")

;; Helper module for testing re-exported import
(module
  (import "scheme base" "i32->fixnum"  (func $i32->fixnum  (param i32) (result i32)))
  (import "scheme base" "fixnum->i32"  (func $fixnum->i32  (param i32) (result i32)))
  (import "scheme base" "boolean->i32"  (func $boolean->i32 (param i32) (result i32)))

  (import "import_scm" "number?" (func $re-exported-number? (param i32) (result i32)))
  (import "import_scm" "zero?" (func $re-exported-zero? (param i32) (result i32)))

  (func (export "test-number?") (param $x i32) (result i32)
    local.get $x
    call $re-exported-number?
    call $fixnum->i32)

  (func (export "test-zero?") (param $x i32) (result i32)
    local.get $x
    call $i32->fixnum
    call $re-exported-zero?
    call $boolean->i32)
)

(assert_return (invoke "test-number?" (i32.const 0)) (i32.const 42))

(assert_return (invoke "test-zero?" (i32.const 0)) (i32.const 1))
(assert_return (invoke "test-zero?" (i32.const 1)) (i32.const 0))
