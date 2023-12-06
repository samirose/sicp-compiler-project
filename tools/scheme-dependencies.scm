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

(define (fold-scheme-objects-in-file kons init filename)
  (with-input-from-file filename
    (lambda ()
      (do ((definition (read) (read))
           (result init (kons definition result)))
          ((eof-object? definition) result)))))

(define (library-definition? object)
  (and (pair? object)
       (eq? (car object) 'define-library)
       (or (not (null? (cdr object)))
           (error "Expected ⟨library name⟩" object))))

(define (library-name library-definition)
  (cadr library-definition))

(define (library-declarations library-definition)
  (cddr library-definition))

(define (import-definition? object)
  (and (pair? object)
       (eq? (car object) 'import)
       (or (not (null? (cdr object)))
           (error "Expected ⟨import set⟩" object))))

(define (import-sets import-definition)
  (let collect-sets ((sets (cdr import-definition))
                     (imports '()))
    (if (null? sets)
        imports
        (let ((import-decl (car sets)))
          (case (and (pair? import-decl) (car import-decl))
            ((only except prefix rename)
             (collect-sets
              (cdr sets)
              (fold cons
                    imports
                    (collect-sets (list (cadar sets)) '()))))
            (else
             (collect-sets
              (cdr sets)
              (cons import-decl imports))))))))

(define (scheme-definition-imports definition)
  (cond ((import-definition? definition)
         (import-sets definition))
        ((library-definition? definition)
         (fold
          (lambda (declaration imports)
            (if (import-definition? declaration)
                (fold cons
                      imports
                      (import-sets declaration))
                imports))
          '()
          (library-declarations definition)))
        (else '())))

(define (scheme-module-imports filename)
  (fold-scheme-objects-in-file
   (lambda (object imports)
     (fold cons
           imports
           (scheme-definition-imports object)))
   '()
   filename))

(let*
    ((filenames (cdr (command-line)))

     (library-module-alist
      (fold
       (lambda (filename alist)
         (fold-scheme-objects-in-file
          (lambda (object alist)
            (if (library-definition? object)
                (let ((library-name (library-name object)))
                  (if (assoc library-name alist)
                      (error "Duplicate library definition" library-name)
                      (cons (cons library-name filename)
                            alist)))
                alist))
          alist
          filename))
       '()
       filenames))

     (imports-to-defining-modules
      (lambda (filename)
        (fold
         (lambda (import defining-modules)
           (let ((defining-module
                   (cond ((assoc import library-module-alist) => cdr)
                         (else #f))))
             (cond
              ;; library is not defined by modules in filenames
              ((not defining-module) defining-modules)
              ;; import is in the same file as definition
              ((string=? defining-module filename) defining-modules)
              (else (cons defining-module defining-modules)))))
         '()
         (scheme-module-imports filename)))))

  (for-each
   (lambda (filename)
     (let ((prequisites (imports-to-defining-modules filename)))
       (unless (null? prequisites)
         (begin
           (write-string filename)
           (write-char #\:)
           (for-each
            (lambda (prequisite)
              (write-char #\ )
              (write-string prequisite))
            prequisites)
           (newline)))))
   filenames)

  (newline))
