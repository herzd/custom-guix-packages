(define-module (gnu packages my-flintlib)
  #:use-module ((guix licenses)
                #:select (gpl3+ lgpl2.0+ lgpl3+ public-domain))
  #:use-module (gnu packages)
  #:use-module (gnu packages multiprecision)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages hurd)
  #:use-module (gnu packages pkg-config)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system trivial)
  #:use-module (ice-9 format)
  #:use-module (ice-9 match)
  #:use-module (ice-9 optargs)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-26))

(define-public my-flintlib
  (package
   (name "my-flintlib")
   (version "2.7.1")
   (source (origin
            (method url-fetch)
            (uri (string-append "http://flintlib.org/flint-" version
                                ".tar.gz"))
            (sha256
             (base32
              "07j8r96kdzp19cy3a5yvpjxf90mkd6103yr2n42qmpv7mgcjyvhq"))
            (patches (search-patches "make-impure-dirs.patch"))))
   (build-system gnu-build-system)
   (native-inputs `(("pkg-config",pkg-config)))  ; to detect further inputs
   (inputs `(("gmp" ,gmp)
	     ("mpfr",mpfr)))
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
   (synopsis "FLINT: Fast Library for Number Theory")
   (description
    "FLINT is a C library for doing number theory, maintained by William Hart.")
   (license gpl3+)
   (home-page "http://flintlib.org/")))
