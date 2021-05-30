(define-module (my-hello)
#:use-module (guix packages)
#:use-module (guix download)
#:use-module (guix build-system gnu)
#:use-module (guix licenses))


(define-public my-hello
  (package
    (name "my-hello")
    (version "2.10")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://gnu/hello/hello-" version
                                  ".tar.gz"))
              (sha256
               (base32
                "0ssi1wpaf7plaswqqjwigppsg5fyh99vdlb9kzl7c9lng89ndq1i"))))
    (build-system gnu-build-system)
    (synopsis "Hello, GNU world: An example custom Guix package")
    (description
     "GNU Hello prints the message \"Hello, world!\" and then exits.  It
  rves as an example of standard GNU coding practices.  As such, it supports
  mmand-line arguments, multiple languages, and so on.")
    (home-page "https://www.gnu.org/software/hello/")
    (license gpl3+)))

(define-public my-hello-2.9
  (package
    (name "my-hello")
    (version "2.9")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://gnu/hello/hello-" version
                                  ".tar.gz"))
              (sha256
               (base32
                "19qy37gkasc4csb1d3bdiz9snn8mir2p3aj0jgzmfv0r2hi7mfzc"))))
    (build-system gnu-build-system)
    (synopsis "Hello, GNU world: An example custom Guix package")
    (description
     "GNU Hello prints the message \"Hello, world!\" and then exits.  It
  rves as an example of standard GNU coding practices.  As such, it supports
  mmand-line arguments, multiple languages, and so on.")
    (home-page "https://www.gnu.org/software/hello/")
    (license gpl3+)))
