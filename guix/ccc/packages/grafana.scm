(define-module (ccc packages grafana)
  #:use-module (guix records)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (guix build utils)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix build-system copy)
  #:use-module (guix download)
  #:use-module ((guix licenses) #:prefix license:)
  #:export (grafana-configuration
            grafana-service-type
            grafana)
  )

(define-record-type* <grafana-configuration> grafana-configuration make-grafana-configuration grafana-configuration?
  (arguments grafana-configuration-arguments (default '()))
  (config-path grafana-configuration-config-path)
  )

(define (grafana-service config)
  (list
   (shepherd-service
    (documentation "Run grafana server")
    (provision '(grafana))
    (respawn? #t)
    (auto-start? #t)
    (requirement '(user-processes))
    (start #~(make-forkexec-constructor
              (list #$(file-append grafana "/bin/grafana")
                    "server"
                    "--homepath" #$(file-append grafana "/share/grafana")
                    "--config" #$(grafana-configuration-config-path config))))
    (stop #~(make-kill-destructor)))))

(define grafana-service-type
  (service-type
   (name 'grafana)
   (description "Shepherd service for grafana")
   (extensions
    (list (service-extension shepherd-root-service-type grafana-service)))
   ))

(define grafana
  (package
    (name "grafana")
    (version "11.5.1")
    (source
     (origin
            (method url-fetch)
            (uri (string-append "https://dl.grafana.com/oss/release/grafana-" version ".linux-amd64.tar.gz"))
            (sha256 (base32 "0ihp9varx0sr556q0wfk5yf7zcx6nxplmflc3fyxpmxkjx4gr6d9"))))
    (build-system copy-build-system)
    (arguments
     `(#:install-plan '(("bin/grafana" "/bin/grafana")
                        ("./" "/share/grafana"))))
    (home-page "https://github.com/grafana/grafana")
    (synopsis "The open and composable observability and data visualization platform. Visualize metrics, logs, and traces from multiple sources like Prometheus, Loki, Elasticsearch, InfluxDB, Postgres and many more.")
    (description "The open and composable observability and data visualization platform. Visualize metrics, logs, and traces from multiple sources like Prometheus, Loki, Elasticsearch, InfluxDB, Postgres and many more.")
    (license license:agpl3)))
