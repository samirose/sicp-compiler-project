(module
    (memory 1)

    (func (export "memeequal") (param $addr1 i32) (param $addr2 i32) (param $len i32) (result i32)
        block $same_contents
            block $process_words
                loop $compare_words
                    ;; exit loop if length less than word size
                    local.get $len
                    i32.const 4
                    i32.lt_u
                    br_if $process_words
                    ;; load word from addr1 and increment it by word
                    local.get $addr1
                    i32.load
                    local.get $addr1
                    i32.const 4
                    i32.add
                    local.set $addr1
                    ;; load word from addr2 and increment it by word
                    local.get $addr2
                    i32.load
                    local.get $addr2
                    i32.const 4
                    i32.add
                    local.set $addr2
                    ;; subtract word from len
                    local.get $len
                    i32.const 4
                    i32.sub
                    local.set $len
                    ;; compare words
                    i32.eq
                    br_if $compare_words
                    br $same_contents
                end
            end
            block $process_bytes
                loop $compare_bytes
                    ;; exit when length reaches zero
                    local.get $len
                    i32.eqz
                    br_if $process_bytes
                    ;; load byte from addr1 and increment it by one
                    local.get $addr1
                    i32.load8_u
                    local.get $addr1
                    i32.const 1
                    i32.add
                    local.set $addr1
                    ;; load byte from addr2 and increment it by one
                    local.get $addr2
                    i32.load8_u
                    local.get $addr2
                    i32.const 1
                    i32.add
                    local.set $addr2
                    ;; subtract one from len
                    local.get $len
                    i32.const 1
                    i32.sub
                    local.set $len
                    ;; compare bytes
                    i32.eq
                    br_if $compare_bytes
                    br $same_contents
                end
            end
            ;; all elements were equal
            i32.const 1
            return
        end
        ;; an element was not equal
        i32.const 0)

    (data (i32.const 0) "\cd\ab\34\12")
    (data (i32.const 4) "\cd\ab\34\12")
    (data (i32.const 8) "\00\11\22\33aBCd")
)

(assert_return (invoke "memeequal" (i32.const 0) (i32.const 4) (i32.const 4)) (i32.const 1))
(assert_return (invoke "memeequal" (i32.const 0) (i32.const 4) (i32.const 0)) (i32.const 1))
(assert_return (invoke "memeequal" (i32.const 0) (i32.const 4) (i32.const 1)) (i32.const 1))
(assert_return (invoke "memeequal" (i32.const 0) (i32.const 4) (i32.const 2)) (i32.const 1))
(assert_return (invoke "memeequal" (i32.const 0) (i32.const 4) (i32.const 3)) (i32.const 1))

(assert_return (invoke "memeequal" (i32.const 0) (i32.const 0) (i32.const 4)) (i32.const 1))
(assert_return (invoke "memeequal" (i32.const 0) (i32.const 1) (i32.const 3)) (i32.const 0))
(assert_return (invoke "memeequal" (i32.const 0) (i32.const 2) (i32.const 2)) (i32.const 0))
(assert_return (invoke "memeequal" (i32.const 0) (i32.const 3) (i32.const 1)) (i32.const 0))

(assert_return (invoke "memeequal" (i32.const 0) (i32.const 8) (i32.const 4)) (i32.const 0))
(assert_return (invoke "memeequal" (i32.const 8) (i32.const 8) (i32.const 8)) (i32.const 1))
(assert_return (invoke "memeequal" (i32.const 8) (i32.const 8) (i32.const 7)) (i32.const 1))
(assert_return (invoke "memeequal" (i32.const 8) (i32.const 8) (i32.const 6)) (i32.const 1))
(assert_return (invoke "memeequal" (i32.const 8) (i32.const 8) (i32.const 5)) (i32.const 1))
