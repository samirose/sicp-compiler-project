#!r6rs
(library
 (wasm-syntax)
 (export wasm-definition-type wasm-definition-type?
         wasm-elem-definition-func-index
         wasm-const-value?)
 (import (rnrs base)
         (rnrs lists))

 (define (wasm-definition-type wasm-definition)
   (car wasm-definition))

 (define (wasm-definition-type? type wasm-definition)
   (eq? (wasm-definition-type wasm-definition) type))

 (define (wasm-elem-definition-func-index elem-definition)
   (cadr elem-definition))

 (define wasm-const-instructions
   '(i32.const f32.const))

 (define (wasm-const-value? exp)
   (and (list? exp)
        (= (length exp) 2)
        (memq (car exp) wasm-const-instructions)))

 )
