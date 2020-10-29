#!r6rs
(library
 (wasm-syntax)
 (export wasm-definition-type wasm-definition-type?
         wasm-elem-definition-func-index
         wasm-const-value?
         wasm-define-locals wasm-locals-definition?)
 (import (rnrs base)
         (rnrs lists)
         (lists)
         (pattern-match))

 (define (wasm-definition-type wasm-definition)
   (car wasm-definition))

 (define (wasm-definition-type? type wasm-definition)
   (eq? (wasm-definition-type wasm-definition) type))

 (define (wasm-elem-definition-func-index elem-definition)
   (cadr elem-definition))

 (define wasm-const-instructions
   '(i32.const f32.const))

 (define (wasm-const-instruction? instr)
   (memq instr wasm-const-instructions))

 (define (wasm-const-value? instr)
   (pattern-match? '(,wasm-const-instruction? ,??) instr))

 (define (wasm-define-locals type n)
   (cons 'local (make-list type n)))

 (define (wasm-locals-definition? exp)
   (pattern-match? `(local ,?? ,??*) exp))

 )
