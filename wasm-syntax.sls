#!r6rs
(library
 (wasm-syntax)
 (export wasm-definition-type wasm-definition-type?
         wasm-elem-definition-func-index)
 (import (rnrs base))

 (define (wasm-definition-type wasm-definition)
   (car wasm-definition))

 (define (wasm-definition-type? type wasm-definition)
   (eq? (wasm-definition-type wasm-definition) type))

 (define (wasm-elem-definition-func-index elem-definition)
   (caddr elem-definition))
 )
