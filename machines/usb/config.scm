(define-module (machines usb config))
(use-modules (gnu)
             (nongnu packages linux)
             (nongnu system linux-initrd)
             (srfi srfi-1))
(use-service-modules desktop networking xorg docker)

(define-public usb-os
  (operating-system
   (locale "en_US.utf8")
   (kernel linux)
   (initrd microcode-initrd)
   (firmware (list linux-firmware))
   (timezone "America/Los_Angeles")
   (keyboard-layout (keyboard-layout "us"))
   (host-name "usb")
   (users (cons* (user-account
                  (name "guest")
                  (password "root")
                  (group "users")
                  (home-directory "/home/guest")
                  (supplementary-groups
                   '("dialout" "wheel" "netdev" "audio" "video")))
                 %base-user-accounts))
   (packages
    (append
     (list (specification->package "emacs")
           (specification->package "emacs-exwm")
           (specification->package "emacs-pdf-tools")
           (specification->package "emacs-desktop-environment")
           (specification->package "xrandr")
           (specification->package "autorandr")
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
           (specification->package "wpa-supplicant-minimal")
           (specification->package "font-victor-mono")

                                        ; Required by org-roam
           (specification->package "sqlite")

           ;;  User programs
           (specification->package "mpv")
           (specification->package "parted")
           (specification->package "gparted")
           (specification->package "icecat")
           (specification->package "xmodmap")
           (specification->package "ncurses")
           (specification->package "ripgrep")
           (specification->package "rsync")
           (specification->package "wget")
           (specification->package "curl")
           (specification->package "ispell")
           (specification->package "lsof")
           (specification->package "net-tools")
           (specification->package "plantuml")
           (specification->package "jq")
           (specification->package "youtube-dl")
           (specification->package "gptfdisk")
           (specification->package "eza")
           (specification->package "alacritty")
           (specification->package "btrfs-progs")
           (specification->package "dosfstools")
           )
     %base-packages))
   (services
    (append
     (list (service gdm-service-type (gdm-configuration
                                      (auto-login? #t)
                                      (default-user "guest")
                                      (xorg-configuration (xorg-configuration (keyboard-layout keyboard-layout)))))
           )
     (remove (lambda (service) (eq? (service-kind service) gdm-service-type)) %desktop-services)))
   (sudoers-file (plain-file "sudoers" "\
root ALL=(ALL) ALL
%wheel ALL=(ALL) NOPASSWD:ALL\n"))
   (bootloader
    (bootloader-configuration
     (bootloader grub-efi-bootloader)
     (target "/boot/efi")
     (keyboard-layout keyboard-layout)))
   (file-systems
    (cons* (file-system
            (mount-point "/home")
            (device (file-system-label "Home"))
            (type "ext4"))
           %base-file-systems
           )
    )
   )
  )

usb-os
