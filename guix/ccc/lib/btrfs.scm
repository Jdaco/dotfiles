(define-module (ccc lib btrfs))
(use-modules (gnu)
             (gnu services mcron))

(define-public (btrfs-snapshot-job hour path)
#~(job '(next-hour '(#$hour))
       (lambda ()
         (let ((date (strftime "%F-%T" (localtime (current-time)))))
           (system* "btrfs" "subvolume" "snapshot" "-r" #$path (format #f "~a/.snapshots/~a" #$path date))))))
