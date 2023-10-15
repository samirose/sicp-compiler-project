(module
    (memory 1)

    (func (export "read-data") (param $a i32) (result i32)
        (i32.load (local.get $a)))

    (data (i32.const 0) "\cd\ab\34\12")
    (data (i32.const 4) "\00\11\22\33aBCd")
    (data (i32.const 16) "😀"))

(assert_return (invoke "read-data" (i32.const 0)) (i32.const 0x1234abcd))
(assert_return (invoke "read-data" (i32.const 4)) (i32.const 0x33221100))
(assert_return (invoke "read-data" (i32.const 8)) (i32.const 0x64434261))
(assert_return (invoke "read-data" (i32.const 16)) (i32.const 0x80989ff0))
