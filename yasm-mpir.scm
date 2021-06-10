(define-module (gnu packages my-yasm)
  #:use-module (guix build-system meson)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system gnu)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (gnu packages)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bison)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages flex)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages image)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages man)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages texinfo)
  #:use-module (gnu packages python)
  #:use-module (gnu packages sphinx)
  #:use-module (gnu packages shells)
  #:use-module (gnu packages xml)
  #:use-module ((guix utils)
                #:select (%current-system cc-for-target)))



(define-public my-yasm
  (package
    (name "my-yasm")
    (version "1.3.0")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "http://www.tortall.net/projects/yasm/releases/yasm-"
                    version ".tar.gz"))
              (sha256
               (base32
                "0gv0slmm0qpq91za3v2v9glff3il594x5xsrbgab7xcmnh0ndkix"))))
    (build-system gnu-build-system)
    (arguments
     '(#:parallel-tests? #f))           ; Some tests fail
                                        ; non-deterministically when run in
                                        ; parallel
    (inputs
     `(("python" ,python-wrapper)
       ("xmlto" ,xmlto)))
    (home-page "https://yasm.tortall.net/")
    (synopsis "Rewrite of the NASM assembler")
    (description
     "Yasm is a complete rewrite of the NASM assembler.

Yasm currently supports the x86 and AMD64 instruction sets, accepts NASM
and GAS assembler syntaxes, outputs binary, ELF32, ELF64, 32 and 64-bit
Mach-O, RDOFF2, COFF, Win32, and Win64 object formats, and generates source
debugging information in STABS, DWARF 2, and CodeView 8 formats.")
    (license (license:non-copyleft "file://COPYING"
                                   "See COPYING in the distribution."))))


(define-module (my-mpir)
  #:use-module ((guix licenses)
                #:select (gpl3+ lgpl2.0+ lgpl3+ public-domain))
  #:use-module (gnu packages)
  #:use-module (gnu packages assembly)
  #:use-module (gnu packages my-yasm)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages bison)
  #:use-module (gnu packages build-tools)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages pcre)
  #:use-module (gnu packages texinfo)
  #:use-module (gnu packages hurd)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages m4)
  #:use-module (gnu packages assembly)
  #:use-module (gnu packages guile)
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

(define-public my-mpir
  (package
   (name "my-mpir")
   (version "3.0.0")
   (source (origin
            (method url-fetch)
            (uri (string-append "http://mpir.org/mpir-" version
                                ".tar.bz2"))
            (sha256
             (base32
              "1fvmhrqdjs925hzr2i8bszm50h00gwsh17p2kn2pi51zrxck9xjj"))))
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
   (home-page "http://mpir.org")))

my-mpir
