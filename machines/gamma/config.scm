(use-modules (gnu packages ssh))
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
            (specification->package "wpa-supplicant")

            ;; This needs to be installed at the same level
            ;; as emacs so that mu4e gets installed
            (specification->package "mu")
            )
      %base-packages))
  (services
    (append
      (list (service openssh-service-type (openssh-configuration (openssh openssh-sans-x) (permit-root-login #f)))

            (set-xorg-configuration (xorg-configuration (keyboard-layout keyboard-layout)))
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
          (source (uuid "e9f22d24-573b-49c1-9db2-4915e92d501b"))
          (target "system-root")
          (type luks-device-mapping))))
  (file-systems
    (cons* (file-system
            (mount-point "/boot/efi")
            (device (uuid "2F4D-3557" 'fat32))
            (type "vfat"))
           (file-system
            (mount-point "/")
            (device "/dev/mapper/system-root")
            (type "btrfs"))
           %base-file-systems)))
