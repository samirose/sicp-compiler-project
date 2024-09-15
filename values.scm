(define-library (values)

  (export
   i32-size
   fixnum-mask fixnum-shift fixnum-max fixnum-min
   immediate-value-mask immediate-mask immediate-shift
   procedure-tag
   boolean-tag false-value true-value
   special-tag uninitialized-value unspecified-value
   number->fixnum-value
   boolean->boolean-value
   funcidx->procedure-value
   heap-object-type-mask heap-object-size-mask heap-object-header-size
   heap-object-type-symbol heap-object-type-string
   macro-align-heap-address
   symbol-literal-header string-literal-header
   error-no-error
   error-uninitialized
   error-expected-number
   error-expected-procedure
   error-expected-string
   error-expected-symbol
   symbol->error)

  (import
   (scheme base)
   (srfi srfi-60))

  (begin
    (define i32-size 4) ; bytes

    ;; fixnums are encoded with least signigicant bit set
    (define fixnum-mask #x00000001)     ; ..00000001
    (define fixnum-shift 1)
    (define fixnum-max #x3fffffff)
    (define fixnum-min (- (+ fixnum-max 1)))

    ;; Other immediate value types are encoded in the least significant 4 bits
    ;; Note that the least significant two bits need to be non-zero for all immediate type tags to
    ;; enable detecting 32-bit aligned pointers from immediates.
    (define immediate-value-mask #x00000003) ; ...00000011
    (define immediate-mask       #x0000000f) ; ...00001111
    (define immediate-shift 4)

    ;; Type tag for procedure values.
    ;; Wasm function index of the procedure is encoded in the 3 most significant bytes
    (define procedure-tag #x00000002)   ; ...00000010

    ;; Type tag and values for boolean values
    (define boolean-tag #x00000006)     ; ...00000110
    (define false-value #x00000006)     ; ...00000110
    (define true-value  #x00000016)     ; ...00010110

    ;; Special type tag and values
    (define special-tag         #x0000000e) ; ...00001110
    (define uninitialized-value #x0000002e) ; ...00011110
    (define unspecified-value   #x0000001e) ; ...00101110

    (define (number->fixnum-value n)
      (bitwise-ior (arithmetic-shift n fixnum-shift) fixnum-mask))

    (define (boolean->boolean-value b)
      (if b true-value false-value))

    (define (funcidx->procedure-value i)
      (bitwise-ior (arithmetic-shift i immediate-shift) procedure-tag))

    (define heap-object-mem-mask    #xf0000000) ; 11110000...
    (define heap-object-blob-bit    #x10000000) ; 00010000...
    (define heap-object-type-mask   #x0f000000) ; 000011110...
    (define heap-object-type-symbol #x01000000) ; 000100010...
    (define heap-object-type-string #x02000000) ; 000100100...
    (define heap-object-size-mask   #x00ffffff) ; 001...
    (define heap-object-max-size heap-object-size-mask)
    (define heap-object-header-size i32-size)

    (define (symbol-literal-header length)
      (if (<= length heap-object-max-size)
          (bitwise-ior heap-object-type-symbol length)
          (error "Too large symbol length" length)))

    (define (string-literal-header length)
      (if (<= length heap-object-max-size)
          (bitwise-ior heap-object-type-string length)
          (error "Too large string length" length)))

    (define (macro-align-heap-address)
      '(i32.const 3
        i32.add
        i32.const 2
        i32.shr_u))

    (define error-no-error 0)
    (define error-uninitialized 1)
    (define error-expected-number 2)
    (define error-expected-procedure 3)
    (define error-expected-symbol 4)
    (define error-expected-string 5)

    (define symbol->error
      `((no-error . ,error-no-error)
        (uninitialized . ,error-uninitialized)
        (expected-number . ,error-expected-number)
        (expected-procedure . ,error-expected-procedure)
        (expected-symbol . ,error-expected-symbol)
        (expected-string . ,error-expected-string)))
    )
  )
