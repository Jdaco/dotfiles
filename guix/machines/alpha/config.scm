(define-module (machines alpha config))
(use-modules (gnu)
             (gnu packages)
             (gnu packages ssh)
             (nongnu packages linux)
             (nongnu system linux-initrd))
(use-service-modules desktop networking ssh xorg docker pm virtualization)

(operating-system
 (kernel linux)
 (initrd microcode-initrd)
 (firmware (list linux-firmware))
 (locale "en_US.utf8")
 (timezone "America/Los_Angeles")
 (keyboard-layout (keyboard-layout "us"))
 (host-name "alpha")
 (users (cons* (user-account
                (name "chaise")
                (group "users")
                (home-directory "/home/chaise")
                (supplementary-groups
                 '("dialout" "wheel" "netdev" "audio" "video" "docker")))
               %base-user-accounts))
 (groups (cons* (user-group (name "docker"))
                %base-groups))
 (packages
  (append
   (list (specification->package "emacs")
         (specification->package "emacs-exwm")
         (specification->package "emacs-pdf-tools")
         ;; (specification->package "emacs-emacsql-sqlite3")
         (specification->package "emacs-desktop-environment")
                                        ; Required by org-roam
         (specification->package "sqlite")
         (specification->package "xrandr")
         (specification->package "autorandr")
         (specification->package "pulseaudio")
         (specification->package "docker")
         (specification->package "containerd")
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
         (specification->package "libvirt")

         ;; This needs to be installed at the same level
         ;; as emacs so that mu4e gets installed
         (specification->package "mu")
         )
   %base-packages))
 (services
  (append
   (list (service openssh-service-type (openssh-configuration (openssh openssh-sans-x) (permit-root-login #f)))
         (service tlp-service-type
                  (tlp-configuration
                   (usb-autosuspend? #f)))
         (set-xorg-configuration (xorg-configuration (keyboard-layout keyboard-layout)))
         (service libvirt-service-type)
         ;; (service docker-service-type)
         ;; (service dhcp-client-service-type)
         ;; (simple-service )
         )
   %desktop-services

   ))
 (bootloader
  (bootloader-configuration
   (bootloader grub-efi-bootloader)
   (targets '("/boot/efi"))
   (keyboard-layout keyboard-layout)))
 (file-systems
  (cons* (file-system
          (mount-point "/boot/efi")
          (device (uuid "4DCC-B536" 'fat32))
          (type "vfat"))
         (file-system
          (mount-point "/")
          (device
           (uuid "9691e892-1564-4fec-91f7-c3d4c2d8aa73"
                 'btrfs))
          (type "btrfs"))
         %base-file-systems)))
