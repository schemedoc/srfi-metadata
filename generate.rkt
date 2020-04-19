#lang scribble/html

@(require (except-in scribble/html/extra map)
          racket/date)

@(define srfis (call-with-input-file "srfi.scm" read))

@(define implementations
   '(Bigloo
     Chibi
     CHICKEN
     Gambit
     Gauche
     Gerbil
     Guile
     Kawa
     Larceny
     Racket
     Sagittarius
     Scheme48
     SLIB
     STKlos
     TinyScheme))

@(define CSS
   "table, th, td
{
 border: 1px solid black;
 border-collapse: collapse;
 table-layout: fixed;
}
td#yes { background-color: limegreen; }
td#no { background-color: orangered; }")

@(define (support-box srfi)
   (let* ((elem (cdr (assoc srfi srfis)))
          (description (cdr (assoc 'description elem)))
          (url (cdr (assoc 'url elem)))
          (support (cdr (assoc 'support elem))))
     (tr
      id: srfi
      title: description
      (cons
       (td (a href: url srfi))
       (map
        (lambda (s)
          (if (member s support)
              (td id: 'yes "\u2713")
              (td id: 'no "\u2717")))
        implementations)))))

@(list
  (doctype 'html)
  (html
   lang: "en"
   (head
    (meta charset: "utf-8")
    (style/inline
     type: "text/css" CSS)
    (title "SRFI Table"))
   (body
    (h1 "SRFI Table")
    (table
     (apply (compose thead tr) (map th (cons 'SRFI implementations)))
     (apply tbody (map support-box (range 193)))
     (tfoot))
    (footer
     (p "Generated on "
        (parameterize ((date-display-format 'iso-8601))
         (date->string (current-date))))))))
