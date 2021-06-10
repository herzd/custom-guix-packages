(define-module (gnu packages chmlib)
  #:use-module ((guix licenses)
		#:select (gpl3+))
  #:use-module (gnu packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages pkg-config)  
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system trivial)
  #:use-module (srfi srfi-1)
  #:export (glibc
	    libiconv-if-needed))

(define-public chmlib
  (package
   (name "chmlib")
   (version "0.0.1")
   (source (origin 
  
