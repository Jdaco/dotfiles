(define-module (ccc)
  #:use-module (guix git-download)
  #:use-module (gnu packages golang)
  #:use-module (gnu packages syncthing)
  #:use-module (gnu packages databases)
  #:use-module (guix build-system go)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (guix build-system gnu)
  #:use-module (guix download))

(define-public s5cmd
  (package
    (name "s5cmd")
    (version "2.2.2")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/peak/s5cmd")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0np2jwqbas0bwfbqv28ijhrdaqxqm1rczbgm901z19gnlcdk44p4"))))
    (build-system go-build-system)
    (arguments
     (list #:import-path "github.com/peak/s5cmd/v2"
           #:go go-1.19))
    (home-page "https://github.com/peak/s5cmd")
    (synopsis "s5cmd")
    (description
     "@@code{s5cmd} is a very fast S3 and local filesystem execution tool.  It comes
with support for a multitude of operations including tab completion and wildcard
support for files, which can be very handy for your object storage workflow
while working with large number of files.")
    (license expat)))
