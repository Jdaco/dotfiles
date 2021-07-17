(use-modules (gnu packages ssh))
(use-modules (gnu packages wm))
(use-modules (gnu))
(use-modules (gnu)
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
                    '("dialout" "wheel" "netdev" "audio" "video" "lp")))
                %base-user-accounts))
  (packages
    (append
      (list (specification->package "emacs")
            (specification->package "emacs-exwm")
            (specification->package "emacs-pdf-tools")
            (specification->package "emacs-desktop-environment")
            (specification->package "emacs-pdf-tools")
            (specification->package "emacs-desktop-environment")
            (specification->package "emacs-emacsql-sqlite3")
            (specification->package "emacs-all-the-icons")
            (specification->package "emacs-all-the-icons-dired")
            (specification->package "adwaita-icon-theme")
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
            (specification->package "rsync")
            (specification->package "gnupg")
            (specification->package "password-store")
            (specification->package "duplicity")
            (specification->package "cryptsetup")
            (specification->package "rng-tools")
            (specification->package "pinentry-qt")
            (specification->package "wpa-supplicant")
            (specification->package "ovmf")
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
            (bluetooth-service #:auto-enable? #t)
            (screen-locker-service i3lock-color "i3lock")
            )
      %desktop-services))
  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (target "/boot/efi")
      (keyboard-layout keyboard-layout)))
  (swap-devices '("/swapfile"))
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
