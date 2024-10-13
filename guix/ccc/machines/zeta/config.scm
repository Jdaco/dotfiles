(define-module (ccc machines zeta config)
  #:export (usb-os))
(use-modules (gnu)
             (gnu packages)
             (gnu packages ssh)
             (srfi srfi-1)
             (ccc packages k3s)
             (ccc lib btrfs))
(use-service-modules ssh networking nfs syncthing mcron)

(define zeta-os
  (operating-system
   (initrd-modules (append (list "mpt3sas") %base-initrd-modules))
   (locale "en_US.utf8")
   (timezone "America/Los_Angeles")
   (keyboard-layout (keyboard-layout "us"))
   (host-name "zeta")
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
     (list
      k3s
      (specification->package "git")
      (specification->package "file")
      (specification->package "gnupg")
      (specification->package "cryptsetup")
      (specification->package "rng-tools")
      (specification->package "freeipmi")
      (specification->package "isc-dhcp")
      (specification->package "ovmf-x86-64")
      (specification->package "parted")
      (specification->package "ncdu")
      (specification->package "dfc")
      (specification->package "zip")
      (specification->package "unzip")
      (specification->package "rsync")
      (specification->package "btop")
      (specification->package "gcc-toolchain")
      (specification->package "wget")
      (specification->package "curl")
      (specification->package "lsof")
      (specification->package "net-tools")
      (specification->package "gptfdisk")
      (specification->package "eza")
      (specification->package "btrfs-progs")
      (specification->package "dosfstools")
      (specification->package "vim")
      (specification->package "docker")
      (specification->package "docker-cli")
      (specification->package "containerd")
      (specification->package "libcgroup")
      (specification->package "syncthing")
      )
     %base-packages))
   (services
    (append  (list
              (service nfs-service-type
                       (nfs-configuration
                        (exports '(("/data" "*(rw,insecure,no_subtree_check,crossmnt,fsid=0)")))))
              (simple-service 'cron-jobs mcron-service-type
                              (list (btrfs-snapshot-job 5 "/data/data")
                                    (btrfs-snapshot-job 5 "/data/backups/gamma")
                                    (btrfs-snapshot-job 5 "/data/backups/delta")))
              (service k3s-service-type)
              (service dhcp-client-service-type)
              (service syncthing-service-type
                       (syncthing-configuration
                        (arguments '("--gui-address=0.0.0.0:8384"))
                        (user "chaise")))
              (service guix-publish-service-type
                       (guix-publish-configuration
                        (host "0.0.0.0")
                        (port 8888)))
              (service openssh-service-type
                       (openssh-configuration (openssh openssh-sans-x) (permit-root-login #f))))
             %base-services))

   (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets '("/boot/efi"))))



   (mapped-devices
    (let ((raid-disks '("3ec5a14a-5efb-4a7e-baf9-d07cbe40f135"
                        "5b5f84e0-069b-4d31-9030-da5a4f728541"
                        "747a8b6e-2d8c-457e-a935-fe6ea69e6c70"
                        "82965fc4-6077-45e4-bd0a-4d380aa767db"
                        "904d2cbe-8940-47da-b7eb-f2f2b1044bc7"
                        "e6ecc5d5-414c-44f0-8082-ee852d539f42" )))
      (cons
       (mapped-device
        (source (uuid "7d08f13b-da31-4af8-b6ab-2151dd4b6b8c"))
        (target "rc")
        (type luks-device-mapping))
       (map (lambda (disk-uuid disk-num)
              (mapped-device
               (source (uuid disk-uuid))
               (target (string-append "raid-disk-" (number->string disk-num)))
               (type (luks-device-mapping-with-options #:key-file "/root/disk-key"))))
            raid-disks
            (iota (length raid-disks))))))
   (file-systems
    (cons* (file-system
            (mount-point "/boot/efi")
            (device (uuid "AF22-DF16" 'fat32))
            (type "vfat"))
           (file-system
            (mount-point "/")
            (device "/dev/mapper/rc")
            (type "btrfs"))
           (file-system
            (mount-point "/data")
            (create-mount-point? #t)
            (device (uuid "47ebaa3f-0fbe-4937-9900-1ebc0bd42d80"))
            (type "btrfs"))
           (append
            %control-groups
            %base-file-systems)))
   ))

zeta-os
