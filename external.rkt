#lang racket
(require net/base64 net/http-client net/url)
(require json)
(require sxml/sxpath)
(require (only-in rnrs/io/ports-6 call-with-port))
(require (only-in srfi/13 string-contains))

(define (read-all)
  (let loop ((xs '()))
    (let ((x (read)))
      (if (eof-object? x) (reverse xs) (loop (cons x xs))))))

(define (write-sexp-file filename forms)
  (call-with-atomic-output-file
   filename
   (lambda (port _)
     (parameterize ((current-output-port port))
       (for-each writeln forms)))))

(define (command->string command . args)
  (let-values (((sub stdout stdin stderr)
                (apply subprocess #f
                       (current-input-port)
                       (current-error-port)
                       (find-executable-path command)
                       args)))
    (let ((output (port->string stdout)))
      (subprocess-wait sub)
      (if (eqv? 0 (subprocess-status sub))
          output
          (error "Command failed:" (cons command args))))))

(define (call-with-url-port url proc)
  (call-with-port (get-pure-port (string->url url)) proc))

(define (query-github query)
  (read-json (get-pure-port (string->url (string-append "https://api.github.com" query)))))

(define (base64-decode-string str)
  (bytes->string/utf-8 (base64-decode (string->bytes/utf-8 str))))

(define (not-space? str)
  (not (string=? str " ")))

(displayln "Scraping listings for")

(displayln "Snow Fort...")
;; Snow Fort repo is in SXML format. We can directly query it with SXPath.
(let ((repo (read (get-pure-port (string->url "https://snow-fort.org/pkg/repo"))))
      (query (sxpath '(package library name srfi))))
  (with-output-to-file "data/snow-fort.scm" #:exists 'replace
    (thunk (for-each displayln (sort (remove-duplicates (map cadr (query repo))) <)))))

(displayln "chez-srfi...")
;; GitHub API returns data in JSON format, which we can `read' into `hasheq's of lists.
(let ((repo (query-github "/repos/arcfide/chez-srfi/contents")))
  (define results
    (sort
     (for/list ((file (map (curryr hash-ref 'name) repo))
                #:when (string-prefix? file "%3a")
                #:unless (string-suffix? file ".sls"))
       (string->number (substring file 3)))
     <))
  (with-output-to-file "data/chez-external.scm" #:exists 'replace
    (thunk (for-each displayln results)))
  (with-output-to-file "data/iron-external.scm" #:exists 'replace
    (thunk (for-each displayln results)))
  (with-output-to-file "data/loko-external.scm" #:exists 'replace
    (thunk (for-each displayln results)
           (displayln 160))))

(define (parse-org-mode-table table chicken-port egg-port)
  ;; Ad hoc, quick-and-dirty org-mode table parser
  (define (get-srfi-number cells)
    (cadr (regexp-match #rx"\\[\\[.+\\]\\[(.+)\\]\\]" (string-trim (list-ref cells 6)))))
  (let loop ((lines (map string-normalize-spaces (cdddr table)))) ; Skip the header row
    (unless (< (length lines) 2)
      (let ((cells (string-split (cadr lines) "|"))) ; Divide meaningful lines into cells
        (when (not-space? (car cells))  ; First row = core
          (displayln (get-srfi-number cells) chicken-port))
        (when (not-space? (cadr cells)) ; Second row = egg
          (displayln (get-srfi-number cells) egg-port)))
      ;; Every other line is a horizontal rule, so we always skip one.
      (loop (cddr lines)))))

(define (get-chicken-built-in-srfis)
  (let* ((whole-page (call-with-url-port
                      "https://wiki.call-cc.org/supported-standards"
                      port->string))
         (c3-c4-start (string-contains
                       whole-page "<h4 id=\"chicken-3-and-4\">"))
         (c5-part (substring whole-page 0 c3-c4-start)))
    (map (lambda (srfi-nnn)
           (string->number (substring srfi-nnn (string-length "srfi-"))))
         (regexp-match* #rx"SRFI-[0-9]+" c5-part))))

(define (get-chicken-external-srfis)
  (sort
   (append-map
    (lambda (egg)
      (let ((name (symbol->string (car egg))))
        (cond ((string=? name "box") '(111))
              ((string=? name "srfi-69") '(69 90))
              ((string=? name "vector-lib") '(43))
              ((and (string-prefix? name "srfi-")
                    (string->number (substring name (string-length "srfi-"))))
               => list)
              (else '()))))
    (with-input-from-string
        (command->string
         "curl"
         "--location"
         "--fail"
         "--silent"
         "--show-error"
         "--user" "anonymous:"
         "https://code.call-cc.org/svn/chicken-eggs/release/5/egg-locations")
      read-all))
   <))

(displayln "CHICKEN...")
(write-sexp-file "data/chicken.scm" (get-chicken-built-in-srfis))
(write-sexp-file "data/chicken-external.scm" (get-chicken-external-srfis))
(displayln "Scraped.")
