(import (scheme base)
        (scheme char)
        (scheme file)
        (scheme write)
        (srfi 28)
        (srfi 193))

(define (disp . xs)
  (for-each display xs)
  (newline))

(define-record-type scheme
  (make-scheme name host
               user repo
               git-ref/head
               git-ref/release
               filename
               contents
               extras)
  scheme?
  (name scheme-name)
  (host scheme-host)
  (user scheme-user)
  ;; TODO: Add Bitbucket and Savannah support
  (repo scheme-repo)
  (git-ref/head scheme-git-ref/head)
  (git-ref/release scheme-git-ref/release)
  (filename scheme-filename)
  (contents scheme-contents)
  (extras   scheme-extras))

(define schemes
  (list
   (make-scheme "bigloo" "github"
                "manuel-serrano" "bigloo"
                "master" "4.5b"
                "manuals/srfi.texi"
                "^@item @code{srfi-[0-9]+} "
                '())

   (make-scheme "chibi" "github"
                "ashinn" "chibi-scheme"
                "master" "0.11"
                "lib/srfi/[0-9]+.sld"
                #f
                '(0))

   (make-scheme "gambit" "github"
                 "gambit" "gambit"
                 "master" "v4.9.5"
                 "lib/srfi/[0-9]+"
                 #f
                 '())

   (make-scheme "gauche" "github"
                "shirok" "Gauche"
                "master" "release0_9_15"
                "src/srfis.scm"
                "^srfi-[0-9]+"
                '())

   (make-scheme "gerbil" "github"
                "mighty-gerbils" "gerbil"
                "master" "v0.18.1"
                "doc/reference/srfi/README.md"
                "\\[SRFI +[0-9]+\\]"
                '())

   (make-scheme "kawa" "gitlab"
                "kashell" "Kawa"
                "master" "3.1.1"
                "doc/kawa.texi"
                "^@uref{http://srfi.schemers.org/srfi-[0-9]+.*, ?SRFI[ -][0-9]+}:"
                '())

   (make-scheme "loko" "gitlab"
                "weinholt" "loko"
                "master" "v0.12.1"
                "Documentation/manual/lib-std.texi"
                "^@code{\\(srfi :[0-9]+ "
                '())

   (make-scheme "sagittarius" "github"
                "ktakashi" "sagittarius-scheme"
                "master" "v0.9.13"
                "doc/srfi.md"
                "SRFI-[0-9]+]"
                '())

   (make-scheme "racket" "github"
                "racket" "srfi"
                "master" "v8.12"
                "srfi-lib/srfi/[%a0-9]*"
                #f
                '())

   (make-scheme "stklos" "github"
                "egallesio" "STklos"
                "master" "stklos-2.10"
                "SUPPORTED-SRFIS"
                "SRFI-[0-9]+:"
                '(15))

   (make-scheme "tr7" "gitlab"
                "jobol" "tr7"
                "v1" "v1.0.10"
                "tr7libs/srfi/[0-9]+.sld"
                #f
                '(0))

   (make-scheme "unsyntax" "gitlab"
                "nieper" "unsyntax"
                "master" "v0.0.3"
                "src/srfi/[0-9]+.s.?.?"
                #f
                '(0 7 46))

   ;; "On hiatus" since 2019.
   #|
   (make-scheme "vicare" "github"
                "marcomaggi" "vicare"
                "master" "v0.4d1.2"
                "doc/srfi.texi"
                "@ansrfi{[0-9]+}"
                '())
   |#
   ))

(define (scheme-archive-url scm git-ref)
  (apply format "https://~a.com/~a/~a/~a/~a.tar.gz"
         (scheme-host scm)
         (scheme-user scm)
         (scheme-repo scm)
         (cond
          ((or (string=? (scheme-host scm) "github"))
           (list "archive"
                 git-ref))
          ((string=? (scheme-host scm) "gitlab")
           (list "-/archive"
                 (if (string=? git-ref (scheme-git-ref/head scm))
                     git-ref
                     (string-append git-ref
                                    "/" (scheme-name scm)
                                    "-" git-ref)))))))

(define (scheme-archive-filename scm git-ref)
  (define archive-filename
    ;; HACK: GitHub archives strip the #\v in the dirname in archive
    (if (and (>= (string-length git-ref) 2)
             (string=? (scheme-host scm) "github")
             (char=? #\v (string-ref git-ref 0))
             (char-numeric? (string-ref git-ref 1)))
        (substring git-ref 1 (string-length git-ref))
        git-ref))
  (format "~a-~a/~a"
          (scheme-repo scm)
          ;; HACK: Workaround for GitLab's wonky "add hash to dirname" quirk
          (if (string=? (scheme-host scm) "gitlab")
              (string-append archive-filename
                             (if (scheme-contents scm) "*" ".*"))
              archive-filename)
          (scheme-filename scm)))

(define (write-listing scm git-ref suffix)
  (define name (string-append (scheme-name scm) suffix))
  (with-output-to-file
      (string-append (script-directory) "listings/" name ".sh")
    (lambda ()
      (define tab "    ")
      (disp "#!/usr/bin/env bash")
      (disp "# Auto-generated by listings.scm")
      (disp "set -eu -o pipefail")
      (disp "cd \"$(dirname \"$0\")\"")
      (disp "{")
      (for-each (lambda (extra) (disp tab "echo " extra))
                (scheme-extras scm))
      (when git-ref
        (disp tab "curl --location --fail --silent --show-error \\")
        (disp tab tab (scheme-archive-url scm git-ref) " |")
        (disp tab tab "gunzip |")
        (cond ((not (scheme-contents scm))
               (disp tab tab "${TAR:-tar} -tf - |")
               (disp tab tab "sed 's@[^/]*/@@' |")
               (disp tab tab "grep -oE '" (scheme-filename scm) "' |")
               (disp tab tab "sed 's@%3a@@' |")
               (disp tab tab "sed 's/.*\\///'"))
              (else
               (disp tab tab "${TAR:-tar} -xf - --to-stdout --wildcards '"
                     (scheme-archive-filename scm git-ref) "' |")
               (disp tab tab "grep -oE '" (scheme-contents scm) "'"))))
      (disp "} | grep -oE '[0-9]+' | sort -g | uniq"
            " >../data/" name ".pose"))))

(for-each (lambda (scm)
            (write-listing scm (scheme-git-ref/head scm) "-head")
            (write-listing scm (scheme-git-ref/release scm) ""))
          schemes)
