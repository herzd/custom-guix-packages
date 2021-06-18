(use-modules (gnu packages)
	     (gnu packages multiprecision)
	     (gnu packages pkg-config)
	     (guix packages)
	     (guix download)
	     (guix build-system gnu)
	     (guix licenses))

(package
 (name "flintlib")
 (version "2.7.1")
 (source (origin
          (method url-fetch)
          (uri (string-append "http://flintlib.org/flint-" version
                              ".tar.gz"))
          (sha256
           (base32
            "07j8r96kdzp19cy3a5yvpjxf90mkd6103yr2n42qmpv7mgcjyvhq"))))
 (build-system gnu-build-system)
 (native-inputs `(("pkg-config",pkg-config)))
 (inputs `(("gmp" ,gmp)
	   ("mpfr",mpfr)))
 (arguments
  `(#:configure-flags
    (list
     (string-append "--with-gmp="
		    (assoc-ref %build-inputs "gmp") "/")
     (string-append "--with-mpfr="
		    (assoc-ref %build-inputs "mpfr") "/")
     (string-append "--prefix="
		    (assoc-ref %outputs "out")))
    #:phases (modify-phases %standard-phases
			    (replace 'configure (lambda* (#:key configure-flags  #:allow-other-keys)
						  (apply invoke "./configure" configure-flags))))))
 (outputs '("out" "debug"))
 (synopsis "FLINT: Fast Library for Number Theory")
 (description
  "FLINT is a C library for doing number theory, maintained by William Hart.")
 (license lgpl2.1+)
 (home-page "http://flintlib.org/"))
