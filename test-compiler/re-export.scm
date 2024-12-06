(define-library (re-export)

  (import (scheme base))

  ;; should export the re-defined number?
  (export number?)

  ;; should export the original zero?
  (export zero?)

  (begin
    ;; re-define imported number?
    (define (number? x) 42)

    ))
