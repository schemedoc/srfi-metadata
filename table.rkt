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
     SLIB
     STKlos
     TinyScheme
     Vicare
     Ypsilon))

@(define srfi-data (with-input-from-file "srfi-data.scm" read-all))

@(define implementation-srfis
   (fold (lambda (impl h)
           (let* ((filename (string-append
                             "listings/"
                             (string-downcase (symbol->string impl)) ".scm"))
                  (srfis (with-input-from-file filename read-all)))
             (hash-set h impl srfis)))
         (hash) implementations))

@(define srfi-implementations
   (let ((h (hash)))
     (hash-for-each
      implementation-srfis
      (lambda (impl srfis)
        (for-each (lambda (srfi)
                    (set! h (hash-update h srfi
                                         (lambda (impls) (cons impl impls))
                                         list)))
                  srfis)))
     h))

@(define CSS
   (string-append "table { table-layout: fixed; text-align: center; } "
                  "td.yes { background-color: limegreen; } "
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
   (let* ((number (cadr (assoc 'number srfi)))
          (status (cadr (assoc 'status srfi)))
          (title  (cadr (assoc 'title  srfi)))
          (support (hash-ref srfi-implementations number list))
          (url (srfi-url number)))
     (tr
      class: number
      title: (~a title " [" status "]")
      (cons
       (td
        class: status
        (a href: url number))
       (map
        (lambda (s)
          (if (member s support)
              (td class: 'yes "\u2713")
              (td class: 'no "\u2717")))
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
    (p "Only includes SRFIs bundled in each implementation's"
       " respective standard library. "
       "Does not yet include third-party/external packages.")
    (table
     (apply (compose thead tr) (map th (cons 'SRFI implementations)))
     (apply tbody (map support-box srfi-data))
     (tfoot))
    (footer
     (p "Generated on "
        (parameterize ((date-display-format 'iso-8601))
          (date->string (current-date))) ".")
     (p "Submit your corrections and requests to "
        (a href: "https://github.com/SchemeDoc/srfi-metadata"
           "srfi-metadata repo") ".")))))
