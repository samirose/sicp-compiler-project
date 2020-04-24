#lang sicp

(#%provide (all-defined))

(define (wasm-definition-type? type wasm-definition)
  (eq? (car wasm-definition) type))

(define (wasm-elem-definition-func-index elem-definition)
  (caddr elem-definition))
