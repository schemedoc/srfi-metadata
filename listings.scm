(import (scheme base) (scheme file) (scheme write))

(define-record-type scheme (make-scheme name
                                        github-user
                                        github-repo
                                        git-ref/head git-ref/release
                                        filename contents)
                    scheme?
                    (name scheme-name)
                    (github-user scheme-github-user)
                    (github-repo scheme-github-repo)
                    (git-ref/head scheme-git-ref/head)
                    (git-ref/release scheme-git-ref/release)
                    (filename scheme-filename)
                    (contents scheme-contents))

(define schemes
  (list

   (make-scheme "bigloo"
                "manuel-serrano" "bigloo" "master" "4.3e"
                "manuals/srfi.texi" "^@item @code{srfi-[0-9]+} ")

   (make-scheme "chibi"
                "ashinn" "chibi-scheme" "master" "0.8"
                "lib/srfi/[0-9]+.sld" #f)

   (make-scheme "gambit"
                "gambit" "gambit" "master" #f
                "lib/srfi/[0-9]+" #f)

   (make-scheme "gauche"
                "shirok" "Gauche" "master" "release0_9_9"
                "src/srfis.scm" "^srfi-[0-9]+")

   (make-scheme "gerbil"
                "vyzo" "gerbil" "master" "v0.15.1"
                "doc/guide/srfi.md" "\\[SRFI +[0-9]+\\]")

   (make-scheme "loko"
                "weinholt" "loko" "master" #f
                "Documentation/manual/lib-std.texi" "^@code{\\(srfi :[0-9]+ ")

   ))

(define (displayln x) (display x) (newline))

(define (shell-pipeline commands)
  (write-string (car commands))
  (for-each (lambda (command)
              (displayln " |")
              (display "    ")
              (display command))
            (cdr commands))
  (newline))

(define (scheme-archive-url scm git-ref)
  (string-append "https://github.com"
                 "/" (scheme-github-user scm)
                 "/" (scheme-github-repo scm)
                 "/" "archive"
                 "/" git-ref ".tar.gz"))

(define (scheme-archive-filename scm git-ref)
  (string-append (scheme-github-repo scm)
                 "-"
                 (if (char=? #\v (string-ref git-ref 0))
                     (substring git-ref 1 (string-length git-ref))
                     git-ref)
                 "/"
                 (scheme-filename scm)))

(define (wri scm git-ref suffix)
  (with-output-to-file (string-append "listings" "/"
                                      (scheme-name scm) suffix ".sh")
    (lambda ()
      (displayln "#!/bin/bash")
      (displayln "set -eu -o pipefail")
      (displayln "cd \"$(dirname \"$0\")\"")
      (if (not git-ref)
          (shell-pipeline
           `(,(string-append "printf '' >" (scheme-name scm) suffix ".scm")))
          (shell-pipeline
           `(,(string-append
               "curl --fail --silent --show-error --location \\\n"
               "    " (scheme-archive-url scm git-ref))
             "gunzip"
             ,@(if (not (scheme-contents scm))
                   `("tar -tf -"
                     ,(string-append
                       "grep -ohE "
                       "'" (scheme-archive-filename scm git-ref) "'")
                     "sed 's@%3a@@'")
                   `(,(string-append
                       "tar -xf - --to-stdout "
                       "'" (scheme-archive-filename scm git-ref) "'")
                     ,(string-append
                       "grep -ohE"
                       " " "'" (scheme-contents scm) "'")))
             "grep -oE '[0-9]+'"
             "sort -g"
             ,(string-append "uniq >" (scheme-name scm) suffix ".scm")))))))

(for-each (lambda (scm)
            (wri scm (scheme-git-ref/head scm) "-head")
            (wri scm (scheme-git-ref/release scm) ""))
          schemes)
