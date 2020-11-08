#lang racket
(require net/base64 net/http-client net/url)
(require json)
(require sxml/sxpath)

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

(displayln "CHICKEN...")
;; GitHub API returns content in base64 format embedded in a JSON object.
(let* ((response (query-github "/repos/diamond-lizard/chicken-srfi-support/contents/srfi-table.org"))
       (table (string-split (base64-decode-string (hash-ref response 'content)) "\n"))
       (chicken-port (open-output-file "data/chicken.scm" #:exists 'replace))
       (egg-port (open-output-file "data/chicken-external.scm" #:exists 'replace)))
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
      (loop (cddr lines))))
  (close-output-port chicken-port)
  (close-output-port egg-port))

(displayln "Scraped.\n")
