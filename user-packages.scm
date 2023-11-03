(specifications->manifest
  '(
    ;;  Virtualization
    "qemu"
    "virt-manager"
    "libvirt"
    ;;  Fonts
    "font-linuxlibertine"
    "font-liberation"
    "font-victor-mono"
    ;;  Disk Utilities
    "gparted"
    "nvme-cli"
    "hdparm"
    "parted"
    "sdparm"
    "gptfdisk"
    ;; Monitoring
    "iotop"
    "sysstat"
    "smartmontools"
    "ncdu"
    "acpi"
    "lsof"
    "lshw"
    ;;  Media
    "imv"
    "imagemagick"
    "ffmpeg"
    "pulsemixer"
    "mpv"
    "yt-dlp"
    "gallery-dl"
    "nerd-dictation"
    ;; Security
    "pinentry-qt"
    "pinentry-emacs"
    "password-store"
    "gnupg"
    ;; Xorg
    "xclip"
    "xdg-utils"
    "xmodmap"
    "alacritty"
    "xset"
    ;; File utils
    "zip"
    "unzip"
    "exa"
    "ripgrep"
    "duplicity"
    "python-boto3"                      ; required by duplicity
    ;; Office
    "mupdf"
    "libreoffice"
    "ispell"
    "plantuml"
    "scribus"
    "offlineimap"
    "wordnet"
    ;; Network
    "nmap"
    "sshfs"
    "nfs-utils"
    "syncthing"
    "curl"
    "wget"
    "rsync"
    "tor"
    "i2pd"
    ;; Containers
    "docker"
    "docker-cli"
    "containerd"
    ;;
    "libvterm" ;; This is needed to compile emacs-vterma
    "go"
    "stow"
    "bpytop"
    "icecat"
    "pandoc"
    "awscli"
    "scrot"
    "ledger"
    "jq"
    "multipath-tools"
    "gcc"
    "k9s"))
