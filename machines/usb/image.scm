(use-modules (gnu)
             (gnu image)
             (gnu tests)
             (gnu system image)
             (guix gexp)
             (machines usb config))

(define MiB (expt 2 20))

(image
 (format 'disk-image)
 (operating-system usb-os)
 (partitions
  (list
   (partition
    (size (* 40 MiB))
    (offset (* 1024 1024))
    (label "ESP")
    (file-system "vfat")
    (flags '(esp))
    (initializer (gexp initialize-efi-partition)))
   (partition
    (size (* 5000 MiB))
    (label "Home")
    (file-system "ext4")
    (initializer #~(lambda* (root . rest)
                    (mkdir root))))
   (partition
    (size 'guess)
    (label root-label)
    (file-system "ext4")
    (flags '(boot))
    (initializer (gexp initialize-root-partition))))))
