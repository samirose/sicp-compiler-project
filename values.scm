(define-library (values)

  (export
   uninitialized-value
   unspecified-value
   number->fixnum-value
   boolean->boolean-value
   funcidx->procedure-value)

  (import
   (scheme base)
   (srfi srfi-60))

  (begin
    (define uninitialized-value #x0000002e)
    (define unspecified-value   #x0000001e)

    (define (number->fixnum-value n)
      (bitwise-ior (arithmetic-shift n 1) #x00000001))

    (define (boolean->boolean-value b)
      (if b #x00000016 #x00000006))

    (define (funcidx->procedure-value i)
      (bitwise-ior (arithmetic-shift i 4) #x00000002))
    )
  )
