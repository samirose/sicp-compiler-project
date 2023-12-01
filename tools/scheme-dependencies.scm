;; R7RS Scheme module interdependencies discovery tool
;;
;; Used for constructing a depdendencies mapping for compiling a set of Scheme files using make.
;;
;; The tool reads a list of R7RS Scheme source files from the command line, and:
;; 1. reads the files and parses the library names and import definitions from them
;; 1. builds a mapping from the library names to the scheme source files where they are defined in
;; 2. builds a mapping from each source file to the libraries it imports and maps the library names
;;    to source files using the mapping from step 1.
;; 3. outputs the dependency mapping from step 2. in make tool's target: prequisites format.
;;
;; The output is limited to the closed set of dependencies between the source files that are passed
;; from the command line. The targets and prequisites are not presented in any specific order in the
;; output as this makes the tool more efficient and the ordering does not matter for the make tool.

(import
 (scheme base)
 (scheme process-context)
 (scheme file)
 (scheme read)
 (scheme write)
 (scheme cxr)
 (only (srfi srfi-1) fold))

(define (scheme-library? sexp)
  (and (pair? sexp)
       (eq? (car sexp) 'define-library)
       (not (null? (cdr sexp)))))

(define (library-name def)
  (cadr def))

(define (import-definition? sexp)
  (and (pair? sexp) (eq? (car sexp) 'import)))

(define (import-sets sets)
  (let collect-sets ((sets sets)
                     (imports '()))
    (cond
     ((null? sets) imports)
     (else
      (let ((import-decl (car sets)))
        (case (and (pair? import-decl) (car import-decl))
          ((only except prefix rename)
           (collect-sets
            (cdr sets)
            (append imports (collect-sets (list (cadar sets)) imports))))
          (else
           (collect-sets
            (cdr sets)
            (cons import-decl imports)))))))))

(define (scheme-library-imports library)
  (fold
   (lambda (definition imports)
     (if (import-definition? definition)
         (append (import-sets (cdr definition)) imports)
         imports))
   '()
   (cdr library)))

(define (scheme-program-imports first-definition)
  (do ((definition first-definition (read))
       (imports '() (if (import-definition? definition)
                        (append (import-sets (cdr definition)) imports)
                        imports)))
      ((eof-object? definition) imports)))

(define (scheme-module-imports filename sexp)
  ((cond ((scheme-library? sexp) scheme-library-imports)
         (else scheme-program-imports))
   sexp))

(define (scheme-library-name filename)
  (with-input-from-file
      filename
    (lambda ()
      (let ((sexp (read)))
        (and (scheme-library? sexp)
             (library-name sexp))))))

(define (process-scheme-files filenames)
  (let*
      ((library-file-alist
        (fold
         (lambda (filename alist)
           (cond ((scheme-library-name filename) =>
                  (lambda (library-name)
                    (if (assoc library-name alist)
                        (error "Duplicate library definition" library-name))
                    (cons (cons library-name filename) alist)))
                 (else alist)))
         '()
         filenames))

       (module-imports-to-files
        (lambda (filename)
          (with-input-from-file filename
            (lambda ()
              (let ((sexp (read)))
                (fold
                 (lambda (import module-files)
                   (cond ((assoc import library-file-alist) =>
                          (lambda (library.file)
                            (cons (cdr library.file) module-files)))
                         (else module-files)))
                 '()
                 (scheme-module-imports filename sexp)))))))

       (module-imports-alist
        (fold
         (lambda (filename alist)
           (cons (cons filename (module-imports-to-files filename))
                 alist))
         '()
         filenames)))

    (for-each
     (lambda (module.imports)
       (unless (null? (cdr module.imports))
         (begin
           (write-string (car module.imports))
           (write-char #\:)
           (for-each
            (lambda (import)
              (write-char #\ )
              (write-string import))
            (cdr module.imports)))
         (newline)))
     module-imports-alist)))

(let ((filenames (cdr (command-line))))
  (process-scheme-files filenames)
  (newline))
