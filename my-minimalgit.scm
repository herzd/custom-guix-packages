(define-module (my-minimalgit)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (gnu packages ssh)
  #:use-module (gnu packages web)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages tls))


(define-public my-minimalgit
  ;; The size of the closure of 'git-minimal' is two thirds that of 'git'.
  ;; Its test suite runs slightly faster and most importantly it doesn't
  ;; depend on packages that are expensive to build such as Subversion.
  (package
    (inherit git)
    (name "my-minimalgit")
    (arguments
     (substitute-keyword-arguments (package-arguments git)
       ((#:phases phases)
        `(modify-phases ,phases
           (replace 'patch-makefiles
             (lambda _
               (substitute* "Makefile"
                 (("/usr/bin/perl") (which "perl")))
               #t))
           (delete 'build-subtree)
           (delete 'split)
           (delete 'install-man-pages)
           (delete 'install-subtree)
           (delete 'install-credential-netrc)
           (delete 'install-credential-libsecret)
           (add-after 'install 'remove-unusable-perl-commands
             (lambda* (#:key outputs #:allow-other-keys)
               (let* ((out     (assoc-ref outputs "out"))
                      (bin     (string-append out "/bin"))
                      (libexec (string-append out "/libexec")))
                 (for-each (lambda (file)
                             (delete-file (string-append libexec
                                                         "/git-core/" file)))
                           '("git-svn" "git-cvsimport" "git-archimport"
                             "git-cvsserver" "git-request-pull"
                             "git-add--interactive" "git-cvsexportcommit"
                             "git-instaweb" "git-send-email"))
                 (delete-file (string-append bin "/git-cvsserver"))

                 ;; These templates typically depend on Perl.  Remove them.
                 (delete-file-recursively
                  (string-append out "/share/git-core/templates/hooks"))

                 ;; Gitweb depends on Perl as well.
                 (delete-file-recursively
                  (string-append out "/share/gitweb"))
                 #t)))))
       ((#:make-flags flags)
        `(delete "USE_LIBPCRE2=yes" ,flags))
       ((#:configure-flags flags)
        `(list
          ,@(if (%current-target-system)
                git-cross-configure-flags
                '())))
       ((#:disallowed-references lst '())
        `(,perl ,@lst))))
    (outputs '("out"))
    (native-inputs
     `(("bash" ,bash-minimal)
       ("bash-for-tests" ,bash)
       ("native-perl" ,perl)
       ("gettext" ,gettext-minimal)))
    (inputs
     `(("curl" ,curl)                             ;for HTTP(S) access
       ("expat" ,expat)                           ;for 'git push' over HTTP(S)
       ("openssl" ,openssl)
       ("perl" ,perl)
       ("zlib" ,zlib)))))
