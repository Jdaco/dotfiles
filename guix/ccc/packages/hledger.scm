(define-module (ccc packages hledger)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system haskell)
  #:use-module (gnu packages haskell-xyz)
  #:use-module (gnu packages haskell-web)
  #:use-module (gnu packages haskell-check)
  #:use-module ((guix licenses) #:prefix license:)
  #:export (hledger)
  )
(define-public ghc-safe
  (package
    (name "ghc-safe")
    (version "0.3.21")
    (source
     (origin
       (method url-fetch)
       (uri (hackage-uri "safe" version))
       (sha256
        (base32
         "00bz022kvs0wd3rs9ycx0nxfyc2gqlg3q13lhx4fqydy5fjgx09c"))))
    (build-system haskell-build-system)
    (properties '((upstream-name . "safe")))
    (native-inputs
     (list ghc-quickcheck))
    (home-page "https://github.com/ndmitchell/safe#readme")
    (synopsis "Library of safe (exception free) functions")
    (description "This library provides wrappers around @code{Prelude} and
@code{Data.List} functions, such as @code{head} and @code{!!}, that can throw
exceptions.")
    (license license:bsd-3)))

(define-public ghc-deferred-folds
  (package
    (name "ghc-deferred-folds")
    (version "0.9.18.1")
    (source
     (origin
       (method url-fetch)
       (uri (hackage-uri "deferred-folds" version))
       (sha256
        (base32
         "1hf14xa9fdfyk9ijxnll402x96m59giqrpj9s5rjqkd5pyi1yj6w"))))
    (build-system haskell-build-system)
    (properties '((upstream-name . "deferred-folds")))
    (native-inputs
     (list ghc-quickcheck
           ghc-tasty
           ghc-tasty-quickcheck
           ghc-tasty-hunit
           ghc-rerebase
           ghc-quickcheck-instances
           ghc-vector
           ghc-unordered-containers
           ghc-primitive
           ghc-hashable
           ghc-foldl
           ))
    (home-page "")
    (synopsis "")
    (description "")
    (license license:expat)))

(define-public ghc-text-builder-dev
  (package
    (name "ghc-text-builder-dev")
    (version "0.3.1")
    (source
     (origin
       (method url-fetch)
       (uri (hackage-uri "text-builder-dev" version))
       (sha256
        (base32
         "18ipiiqrr0hz0yl7lqv2y730vl6mzqp0jg1yir097gp53ky6hzyw"))))
    (build-system haskell-build-system)
    (properties '((upstream-name . "text-builder-dev")))
    (native-inputs
     (list ghc-quickcheck
           ghc-tasty
           ghc-tasty-quickcheck
           ghc-tasty-hunit
           ghc-rerebase
           ghc-quickcheck-instances
           ghc-split
           ghc-deferred-folds
           ))
    (home-page "")
    (synopsis "")
    (description "")
    (license license:expat)))

(define-public ghc-text-builder
  (package
    (name "ghc-text-builder")
    (version "0.6.7")
    (source
     (origin
       (method url-fetch)
       (uri (hackage-uri "text-builder" version))
       (sha256
        (base32
         "00pl4jbqpcrfc00m3hf871g9k7s0n6xf2igb7ba1dnqh76w4lw4h"))))
    (build-system haskell-build-system)
    (properties '((upstream-name . "text-builder")))
    (native-inputs
     (list ghc-quickcheck
           ghc-tasty
           ghc-tasty-quickcheck
           ghc-tasty-hunit
           ghc-rerebase
           ghc-quickcheck-instances
           ghc-text-builder-dev))
    (home-page "")
    (synopsis "")
    (description "")
    (license license:expat)))

(define-public ghc-text-ansi
  (package
    (name "ghc-text-ansi")
    (version "0.2.1")
    (source
     (origin
       (method url-fetch)
       (uri (hackage-uri "text-ansi" version))
       (sha256
        (base32
         "1s0ad0nap9z0pzwl3nm2vglkz148qv120bngwy08bqb6vbs8w90p"))))
    (build-system haskell-build-system)
    (properties '((upstream-name . "text-ansi")))
    (native-inputs
     (list ghc-text-builder))
    (home-page "")
    (synopsis "")
    (description "")
    (license license:expat)))

(define-public ghc-base-compat
  (package
    (name "ghc-base-compat")
    (version "0.14.0")
    (source (origin
              (method url-fetch)
              (uri (hackage-uri "base-compat" version))
              (sha256
               (base32
                "0l4wg4xna7dnphlzslbxvi4h2rm35pw0sdn9ivhynf6899kdwipi"))))
    (build-system haskell-build-system)
    (properties '((upstream-name . "base-compat")))
    (home-page "https://hackage.haskell.org/package/base-compat")
    (synopsis "Haskell compiler compatibility library")
    (description
     "This library provides functions available in later versions
of base to a wider range of compilers, without requiring the use of CPP
pragmas in your code.")
    (license license:expat)))

(define-public ghc-hledger-lib
  (package
    (name "ghc-hledger-lib")
    (version "1.41")
    (source (origin
              (method url-fetch)
              (uri (hackage-uri "hledger-lib" version))
              (sha256
               (base32
                "1lzqd1jfvgrnmf0jr48nxf779a8cskqd49ira9whb0k5dah4shqw"))))
    (build-system haskell-build-system)
    (properties '((upstream-name . "hledger-lib")))
    (inputs (list ghc-decimal
                  ghc-glob
                  ghc-aeson
                  ghc-lucid
                  ghc-base-compat
                  ghc-blaze-html
                  ghc-terminal-size
                  ghc-aeson-pretty
                  ghc-ansi-terminal
                  ghc-blaze-markup
                  ghc-breakpoint
                  ghc-call-stack
                  ghc-cassava
                  ghc-cassava-megaparsec
                  ghc-cmdargs
                  ghc-data-default
                  ghc-doclayout
                  ghc-extra
                  ghc-file-embed
                  ghc-hashtables
                  ghc-megaparsec
                  ghc-microlens
                  ghc-microlens-th
                  ghc-parser-combinators
                  ghc-pretty-simple
                  ghc-regex-tdfa
                  ghc-safe
                  ghc-tabular
                  ghc-tasty
                  ghc-tasty-hunit
                  ghc-timeit
                  ghc-uglymemo
                  ghc-unordered-containers
                  ghc-utf8-string))
    (native-inputs (list ghc-doctest))
    (home-page "http://hledger.org")
    (synopsis "Reusable library providing the core functionality of hledger")
    (description
     "A reusable library containing hledger's core functionality.
This is used by most hledger* packages so that they support the same common
file formats, command line options, reports etc.

hledger is a robust, cross-platform set of tools for tracking money, time, or
any other commodity, using double-entry accounting and a simple, editable file
format, with command-line, terminal and web interfaces.  It is a Haskell
rewrite of Ledger, and one of the leading implementations of Plain Text
Accounting.")
    (license license:gpl3)))

(define-public ghc-hledger
  (package
    (name "ghc-hledger")
    (version "1.41")
    (source (origin
              (method url-fetch)
              (uri (hackage-uri "hledger" version))
              (sha256
               (base32
                "0ijl7yr6svnwvk6sxm4nq35crksla8ffn3mg2dz8ai9a9gycaslk"))))
    (build-system haskell-build-system)
    (properties '((upstream-name . "hledger")))
    (inputs (list ghc-decimal
                  ghc-diff
                  ghc-aeson
                  ghc-modern-uri
                  ghc-text-ansi
                  ghc-ansi-terminal
                  ghc-breakpoint
                  ghc-cmdargs
                  ghc-data-default
                  ghc-extra
                  ghc-githash
                  ghc-hashable
                  ghc-hledger-lib
                  ghc-lucid
                  ghc-math-functions
                  ghc-megaparsec
                  ghc-microlens
                  ghc-regex-tdfa
                  ghc-safe
                  ghc-shakespeare
                  ghc-split
                  ghc-tabular
                  ghc-tasty
                  ghc-temporary
                  ghc-timeit
                  ghc-unordered-containers
                  ghc-utf8-string
                  ghc-utility-ht
                  ghc-wizards))
    (home-page "http://hledger.org")
    (synopsis "Command-line interface for the hledger accounting system")
    (description
     "The command-line interface for the hledger accounting system.  Its basic
function is to read a plain text file describing financial transactions and
produce useful reports.

hledger is a robust, cross-platform set of tools for tracking money, time, or
any other commodity, using double-entry accounting and a simple, editable file
format, with command-line, terminal and web interfaces.  It is a Haskell
rewrite of Ledger, and one of the leading implementations of Plain Text
Accounting.")
    (license gpl3)))

(define-public hledger
  (package
    (inherit ghc-hledger)
    (name "hledger")
    (arguments
     (list #:haddock? #f))))

hledger
