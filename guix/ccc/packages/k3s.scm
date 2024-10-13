(define-module (ccc packages k3s)
  #:use-module (guix licenses)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (guix packages)
  #:use-module (guix build-system gnu)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (guix build utils)
  #:use-module (guix build-system trivial)
  )

(define-public (k3s-service config)
  (list
   (shepherd-service
    (documentation "Run k3s daemon")
    (provision '(k3s))
    (respawn? #t)
    (auto-start? #t)
    (requirement '(user-processes))
    (start #~(make-forkexec-constructor
              (list #$(file-append k3s "/bin/k3s") "server")))
    (stop #~(make-kill-destructor)))))

(define-public k3s-service-type
  (service-type
   (name 'k3s)
   (description "Shepherd service for k3s")
   (extensions
    (list (service-extension shepherd-root-service-type k3s-service)))
   (default-value '())))

(define-public k3s
  (package
   (name "k3s")
   (version "1.31.1")
   (source (origin
            (method url-fetch)
            (uri (string-append "https://github.com/k3s-io/k3s/releases/download/v" version "+k3s1/k3s"))
            (sha256 (base32 "15ixh232gzq0kq3gyjmlyib7mp00fbyg34a1g13446bbib042ha0"))))
   (build-system trivial-build-system)
   (arguments (list
               #:modules '((guix build utils))
               #:builder
               #~(begin
                   (use-modules (guix build utils))
                   (mkdir-p (string-append #$output "/bin"))
                   (copy-recursively #$source (string-append #$output "/bin/k3s"))
                   (chmod (string-append #$output "/bin/k3s") #o555))
               ))
   (synopsis "Lightweight Kubernetes")
   (description "")
   (home-page "")
   (license asl2.0)))

k3s
