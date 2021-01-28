(use-modules (gnu packages ssh))
(use-modules (gnu))
(use-service-modules desktop networking ssh xorg docker)

;; (define syncthing-service
;;   (service-type
;;    (name 'syncthing)
;;    (extensions
;;     (list (service-extension shepherd-root-service-type guix-shepherd-service)
;;           ))

;;    (default-value (guix-configuration))

;;    ))

(operating-system
  (locale "en_US.utf8")
  (timezone "America/Los_Angeles")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "alpha")
  (users (cons* (user-account
                  (name "chaise")
                  (comment "Chaise")
                  (group "users")
                  (home-directory "/home/chaise")
                  (supplementary-groups
                    '("dialout" "wheel" "netdev" "audio" "video")))
                %base-user-accounts))
  (packages
    (append
      (list (specification->package "emacs")
            (specification->package "emacs-exwm")
            (specification->package "emacs-pdf-tools")
            (specification->package "emacs-desktop-environment")
            ; Required by org-roam
            (specification->package "sqlite")
            (specification->package "xrandr")
            (specification->package "autorandr")
            (specification->package "pulseaudio")
            (specification->package "docker")
            (specification->package "fd")
            (specification->package "git")
            (specification->package "file")
            (specification->package "nss-certs")
            (specification->package "gnupg")
            (specification->package "password-store")
            (specification->package "duplicity")
            (specification->package "cryptsetup")
            (specification->package "rng-tools")
            (specification->package "pinentry-qt")

            ;; This needs to be installed at the same level
            ;; as emacs so that mu4e gets installed
            (specification->package "mu")
            )
      %base-packages))
  (services
    (append
      (list (service openssh-service-type (openssh-configuration (openssh openssh-sans-x) (permit-root-login #f)))
            (set-xorg-configuration (xorg-configuration (keyboard-layout keyboard-layout)))
            ;; (service docker-service-type)
            ;; (service dhcp-client-service-type)
            ;; (simple-service )
            )
      %desktop-services))
  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (target "/boot/efi")
      (keyboard-layout keyboard-layout)))
  (file-systems
    (cons* (file-system
             (mount-point "/boot/efi")
             (device (uuid "2F4D-3557" 'fat32))
             (type "vfat"))
           (file-system
             (mount-point "/")
             (device
               (uuid "fd0ee01a-0f0a-4f64-b434-25367b58ebf4"
                     'btrfs))
             (type "btrfs"))
           %base-file-systems)))
