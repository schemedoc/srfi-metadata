#lang scribble/html

@(require (except-in scribble/html/extra map)
          srfi/1
          racket/date
          racket/format)

@(define (read-all)
   (let loop ((forms '()))
     (let ((form (read)))
       (if (eof-object? form) (reverse forms) (loop (cons form forms))))))

@(define implementations
   '(Bigloo
     Chez
     Chibi
     CHICKEN
     Gambit
     Gauche
     Gerbil
     Guile
     Kawa
     Larceny
     Loko
     MIT
     Racket
     Sagittarius
     Scheme48
     STKlos
     TinyScheme
     Vicare
     Ypsilon
     SLIB
     Snow-Fort))

@(define srfi-data (with-input-from-file "data/srfi-data.scm" read-all))

@(define (read-listing impl suffix)
   (let* ((impl (string-downcase (symbol->string impl)))
          (filename (string-append "data/" impl suffix ".scm")))
     (with-input-from-file filename read-all)))

@(define implementation-support
   (map
    (lambda (impl)
      (letrec ((srfis (make-hasheq))
               (tag-as (lambda (tag)
                         (lambda (number)
                           (hash-set! srfis number tag)))))
        (for-each (tag-as 'external) (read-listing impl "-external"))
        (for-each (tag-as 'head)     (read-listing impl "-head"))
        (for-each (tag-as 'release)  (read-listing impl ""))
        (cons impl
              (map (lambda (number) (cons number (hash-ref srfis number)))
                   (sort (hash-keys srfis) <)))))
    implementations))

@(define CSS
   (string-append "table { table-layout: fixed; text-align: center; } "
                  "td.release { background-color: limegreen; } "
                  "td.head { background-color: green; } "
                  "td.external { background-color: gold; } "
                  "td.no { background-color: orangered; } "
                  "th { border-right: 1px solid black; } "
                  "td.withdrawn { background-color: lightsalmon; } "
                  "td.draft { background-color: powderblue; }"))

@(define (srfi-url number)
   (let ((number (number->string number)))
     (string-append "https://srfi.schemers.org"
                    "/srfi-" number
                    "/srfi-" number ".html")))

@(define (support-box srfi)
   (define (assoc? key alist)
     (let ((pair (assoc key alist)))
       (and pair (cdr pair))))
   (let* ((number (cadr (assoc 'number srfi)))
          (status (cadr (assoc 'status srfi)))
          (title  (cadr (assoc 'title  srfi)))
          (url (srfi-url number)))
     (tr
      class: number
      title: (~a title " [" status "]")
      (cons
       (td
        class: status
        (a href: url number))
       (map
        (lambda (implementation)
          (let ((supported (assoc? number (assoc? implementation
                                                  implementation-support))))
            (if (not supported)
                (td class: 'no "\u2717")
                (case supported
                  ((release)  (td class: 'release  "\u2713"))
                  ((head)     (td class: 'head     "\u2713"))
                  ((external) (td class: 'external "\u2713"))
                  (else      (error "Huh?"))))))
        implementations)))))

@(list
  (doctype 'html)
  (html
   lang: "en"
   (head
    (meta charset: "utf-8")
    (style/inline CSS)
    (title "SRFI Table"))
   (body
    (h1 "SRFI Table")
    (p "Please submit your corrections, suggestions, ideas and requests to the "
       (a href: "https://github.com/SchemeDoc/srfi-metadata"
          (code "srfi-metadata")) " repo.")
    (br)
    (table
     (tr
      (td (b "Legend")) (td))
     (tr
      (td class: 'release "\u2713") (td "Supported in the latest version"))
     (tr
      (td class: 'head "\u2713") (td "Support not yet released"))
     (tr
      (td class: 'external "\u2713") (td "Supported through third-party libraries*"))
     (tr
      (td class: 'no "\u2717") (td "Unsupported")))
    (br)
    (table
     (apply (compose thead tr) (map th (cons 'SRFI implementations)))
     (apply tbody (map support-box srfi-data))
     (tfoot))
    (p
     (b "* On third-party libraries: ")
     (a href: "https://people.csail.mit.edu/jaffer/SLIB.html" "SLIB") " and "
     (a href: "http://snow-fort.org" "Snow Fort")
     " provide portable third-party SRFI implementations for R5RS and R7RS Scheme respectively."
     (br)
     (a href: "https://github.com/arcfide/chez-srfi" (code "chez-srfi")) " is included as the "
     (i "de facto") " SRFI implementation library for Chez Scheme and Loko Scheme"
     " with broad R6RS compatibility.")
    (footer
     (p "Generated on "
        (parameterize ((date-display-format 'iso-8601))
          (date->string (current-date))) ".")))))
