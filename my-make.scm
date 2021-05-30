(define-module (my-gnu-make)
  #:use-module ((guix licenses)
                #:select (gpl3+ lgpl2.0+ lgpl3+ public-domain))
  #:use-module (gnu packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages acl)
  #:use-module (gnu packages algebra)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages bison)
  #:use-module (gnu packages ed)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages multiprecision)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages pcre)
  #:use-module (gnu packages texinfo)
  #:use-module (gnu packages hurd)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages gettext)
  #:use-module (guix i18n)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system trivial)
  #:use-module (ice-9 format)
  #:use-module (ice-9 match)
  #:use-module (ice-9 optargs)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-26)
  #:export (glibc
            libiconv-if-needed))



(define-public my-gnu-make
  (package
   (name "my-gnu-make")
   (version "4.3")
   (source (origin
            (method url-fetch)
            (uri (string-append "mirror://gnu/make/make-" version
                                ".tar.gz"))
            (sha256
             (base32
              "06cfqzpqsvdnsxbysl5p2fgdgxgl9y4p7scpnrfa8z2zgkjdspz0"))
            (patches (search-patches "make-impure-dirs.patch"))))
   (build-system gnu-build-system)
   (native-inputs `(("pkg-config" ,pkg-config)))  ; to detect Guile
   (inputs `(("guile" ,guile-3.0)))
   (outputs '("out" "debug"))
   (arguments
    `(,@(if (hurd-target?)
            '(#:configure-flags '("CFLAGS=-D__alloca=alloca"
                                  "ac_cv_func_posix_spawn=no"))
            '())
      #:phases
      (modify-phases %standard-phases
        (add-before 'build 'set-default-shell
          (lambda* (#:key inputs #:allow-other-keys)
            ;; Change the default shell from /bin/sh.
            (let ((bash (assoc-ref inputs "bash")))
              (substitute* "src/job.c"
                (("default_shell =.*$")
                 (format #f "default_shell = \"~a/bin/sh\";\n"
                         bash)))
              #t))))))
   (synopsis "Remake files automatically")
   (description
    "Make is a program that is used to control the production of
executables or other files from their source files.  The process is
controlled from a Makefile, in which the developer specifies how each file is
generated from its source.  It has powerful dependency resolution and the
ability to determine when files have to be regenerated after their sources
change.  GNU make offers many powerful extensions over the standard utility.")
   (license gpl3+)
   (home-page "https://www.gnu.org/software/make/")))
