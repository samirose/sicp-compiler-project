#!r6rs
(library
 (wasm-syntax)
 (export wasm-definition-type?
         wasm-elem-def? wasm-elem-definition-func-index)
 (import (rnrs base))

 (define (wasm-definition-type? type wasm-definition)
   (eq? (car wasm-definition) type))

 (define (wasm-elem-def? wasm-definition)
   (wasm-definition-type? 'elem wasm-definition))

 (define (wasm-elem-definition-func-index elem-definition)
   (caddr elem-definition))
 )
