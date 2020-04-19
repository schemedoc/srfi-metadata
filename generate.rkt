#lang scribble/html

@(require (except-in scribble/html/extra map)
          racket/date
          racket/format)

@(define srfis (call-with-input-file "srfi.scm" read))

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
     Racket
     Sagittarius
     Scheme48
     SLIB
     STKlos
     TinyScheme
     Vicare
     Ypsilon))

@(define CSS
   (string-append "table { table-layout: fixed; text-align: center; } "
                  "td.yes { background-color: limegreen; } "
                  "td.no { background-color: orangered; } "
                  "th { border-right: 1px solid black; } "
                  "td.withdrawn { background-color: lightsalmon; } "
                  "td.draft { background-color: powderblue; }"))

@(define (support-box srfi)
   (let* ((elem (cdr (assoc srfi srfis)))
          (description (cdr (assoc 'description elem)))
          (url (cdr (assoc 'url elem)))
          (status (cdr (assoc 'status elem)))
          (support (cdr (assoc 'support elem))))
     (tr
      class: srfi
      title: (~a description " [" status "]")
      (cons
       (td
        class: status
        (a href: url srfi))
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
     (apply tbody (map support-box (range 193)))
     (tfoot))
    (footer
     (p "Generated on "
        (parameterize ((date-display-format 'iso-8601))
         (date->string (current-date))))))))
