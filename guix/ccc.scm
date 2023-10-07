(define-module (ccc)
  #:use-module (guix build utils)
  #:use-module (guix git-download)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages golang)
  #:use-module (gnu packages syncthing)
  #:use-module (gnu packages databases)
  #:use-module (guix build-system go)
  #:use-module (guix packages)
  #:use-module (guix build-system gnu)
  #:use-module (guix download))

(import (only (guix licenses) expat))

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

(define-public k3d
  (package
    (name "k3d")
    (version "5.6.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/k3d-io/k3d")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1p296igp61c5k4xzsb2zz0j4v3khhdpmsgfzrd81pip46fw311i8"))))
    (build-system go-build-system)
    (arguments
     `(#:import-path "github.com/k3d-io/k3d/v5"
      #:install-source? #f
      #:phases
        (modify-phases %standard-phases
         (add-after 'install 'rename-binaries
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out")))
               (rename-file
                     (string-append out "/bin/v5")
                     (string-append out "/bin/k3d"))
               #t))))
           #:go ,go-1.19))
    (home-page "https://github.com/k3d-io/k3d")
    (synopsis " Little helper to run CNCF's k3s in Docker")
    (description "k3d creates containerized k3s clusters. This means, that you can spin up a multi-node k3s cluster on a single machine using docker.")
    (license expat)))

(define-public s3fs
  (package
    (name "s3fs")
    (version "1.93")
    (propagated-inputs (list libxml2 curl openssl awscli))
    (inputs (list automake autoconf-2.71 pkg-config fuse-2))
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/s3fs-fuse/s3fs-fuse")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "157g8w1kmr143b6spnzyhkxww3h1qjx3m90qznkk693j16fwgcpf"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? ,#f
       #:phases
       (modify-phases %standard-phases
                      (add-before 'configure 'autogen
                                  (lambda* (#:key outputs #:allow-other-keys)
                                    (invoke "./autogen.sh"))))))
    (home-page "https://github.com/s3fs-fuse/s3fs-fuse")
    (synopsis "FUSE-based file system backed by Amazon S3")
    (description "FUSE-based file system backed by Amazon S3")
    (license expat)))
