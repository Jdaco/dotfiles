(define-module (ccc packages keyd)
 #:use-module (gnu services)
 #:use-module (gnu services shepherd)
 #:use-module (guix gexp)
 #:use-module (guix git-download)
 #:use-module (gnu packages autotools)
 #:use-module (gnu packages gcc)
 #:use-module (gnu packages version-control)
 #:use-module (guix packages)
 #:use-module (guix build-system gnu))


(import (only (guix licenses) expat))

(define (keyd-service config)
  (list
   (shepherd-service
    (documentation "Run keyd daemon")
    (provision '(keyd))
    (respawn? #t)
    (auto-start? #t)
    (requirement '(user-processes))
    (start #~(make-forkexec-constructor
              (list #$(file-append keyd "/bin/keyd"))))
    (stop #~(make-kill-destructor)))))

(define-public keyd-service-type
  (service-type
   (name 'keyd)
   (description "Shepherd service for keyd")
   (extensions
    (list (service-extension shepherd-root-service-type keyd-service)))
   (default-value '())))

(define-public keyd
  (package
    (name "keyd")
    (version "2.5.0")
    (inputs (list automake gcc git))
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/rvaiya/keyd")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0nkra6lwdjhjcwj6486cgy562n4bcp98fjgl52rj8pp76i15yad7"))))
    (build-system gnu-build-system)
    (arguments
     (list
       #:tests? #f
       #:make-flags #~(list "PREFIX=/"
                            "CC=gcc"
                            (string-append "DESTDIR=" #$output)
                            "COMMIT=5e4ef41b41ce02f7d6a9f2e51298810d84589e76")
       #:phases
       '(modify-phases %standard-phases
                      (delete 'configure)
                      )
       ))
    (home-page "https://github.com/rvaiya/keyd")
    (synopsis "A key remapping daemon for linux")
    (description "A key remapping daemon for linux")
    (license expat)))

keyd
