#lang racket
(require net/base64 net/http-client net/url)
(require json)
(require sxml/sxpath)

(displayln "Generating listings for Snow Fort...")
;; Snow Fort repo is in SXML format. We can directly query it with SXPath.
(let ((repo (read (get-pure-port (string->url "https://snow-fort.org/pkg/repo"))))
      (query (sxpath '(package library name srfi))))
  (with-output-to-file "data/snow-fort.scm" #:exists 'replace
    (thunk (for-each displayln (sort (remove-duplicates (map cadr (query repo))) <)))))

(displayln "Generating listings for chez-srfi...")
;; GitHub API returns data in JSON format, which we can `read' into `hasheq's of lists.
(let ((repo (read-json (get-pure-port (string->url "https://api.github.com/repos/arcfide/chez-srfi/contents")))))
  (define results
    (sort
     (for/list ((file (map (curryr hash-ref 'name) repo))
                #:when (string-prefix? file "%3a")
                #:unless (string-suffix? file ".sls"))
       (string->number (substring file 3)))
     <))
  (with-output-to-file "data/chez-external.scm" #:exists 'replace
    (thunk (for-each displayln results)))
  (with-output-to-file "data/ironscheme-external.scm" #:exists 'replace
    (thunk (for-each displayln results)))
  (with-output-to-file "data/loko-external.scm" #:exists 'replace
    (thunk (for-each displayln results)
           (displayln 160))))
