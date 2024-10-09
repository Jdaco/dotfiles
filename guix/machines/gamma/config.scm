(define-module (machines gamma config))
(use-modules (gnu)
             (gnu packages)
             (gnu packages ssh)
             (gnu packages wm)
             (nongnu packages linux)
             (nongnu system linux-initrd))
(use-service-modules desktop networking ssh xorg docker)

(operating-system
 (kernel linux)
 (initrd microcode-initrd)
 (firmware (list linux-firmware))
  (locale "en_US.utf8")
  (timezone "America/Los_Angeles")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "gamma")
  (users (cons* (user-account
                  (name "chaise")
                  (group "users")
                  (home-directory "/home/chaise")
                  (supplementary-groups
                    '("dialout" "wheel" "netdev" "audio" "video" "lp" "docker")))
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
            (specification->package "i3lock-color")
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
            (specification->package "wpa-supplicant")
            (specification->package "ovmf-x86-64")
            (specification->package "bluez-alsa")
            (specification->package "bluez")

            ;; This needs to be installed at the same level
            ;; as emacs so that mu4e gets installed
            (specification->package "mu")
            )
      %base-packages))
  (services
    (append
      (list (service openssh-service-type (openssh-configuration (openssh openssh-sans-x) (permit-root-login #f)))
            (set-xorg-configuration (xorg-configuration (keyboard-layout keyboard-layout)))
            (service bluetooth-service-type (bluetooth-configuration))
            (service screen-locker-service-type (screen-locker-configuration
                                                 (name "i3lock")
                                                 (program (file-append i3lock-color "/bin/i3lock"))))
            )
      %desktop-services))
  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (targets '("/boot/efi"))
      (keyboard-layout keyboard-layout)))
  (mapped-devices
   (list (mapped-device
          (source (uuid "d2706825-09fb-4564-9832-6a17c88d2758"))
          (target "cryptroot")
          (type luks-device-mapping))))
  (file-systems
    (cons* (file-system
            (mount-point "/boot/efi")
            (device (uuid "5E06-132C" 'fat32))
            (type "vfat"))
           (file-system
            (mount-point "/")
            (device "/dev/mapper/cryptroot")
            (type "btrfs"))
           %base-file-systems)))
