SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c

BUILD_DIR := build

USB_USER := guest
USB_IMAGE := $(BUILD_DIR)/usb.raw
USB_CONFIG := guix/machines/usb/image.scm
USB_HOME_UUID := 77941632-5715-4b77-a1f0-a32aeeae7a38


HOME_FS := $(BUILD_DIR)/home/$(USB_USER)
ROOT_MOUNT := $(BUILD_DIR)/root

FILES := $(BUILD_DIR)

.DEFAULT_GOAL := $(USB_IMAGE)
# .DEFAULT_GOAL := $(HOME_FS)

GUIX_RUN := guix environment --container --user=$(USB_USER) \
							--pure --network --no-cwd \
							--ad-hoc grep sed diffutils patch gawk tar gzip bzip2 xz lzip emacs git bash coreutils fd ripgrep findutils curl wget nss-certs which

.PHONY: boot-qemu
boot-qemu: ## Boot the machine image using QEMU
	@qemu-system-x86_64 \
        -smp 2 \
        -m 2048 \
        -enable-kvm \
        -vga std \
        -cpu host \
    -drive if=pflash,format=raw,readonly,file=/run/current-system/profile/share/firmware/ovmf_x64.bin \
        -drive format=raw,file=/home/chaise/Downloads/guix-system-install-1.4.0.x86_64-linux.iso    \
    -object rng-random,filename=/dev/urandom,id=rng0 \
        -device virtio-rng-pci,rng=rng0,id=rng-device0 \
        -net nic,model=virtio \
        -net user

.PHONY: help
help: ## Show help message
	@grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:[[:blank:]]*\(##\)[[:blank:]]*/\1/' | column -s '##' -t

.PHONY: clean
clean: ##Remove all generated files
	@rm -rf $(FILES)

.PHONY: mostlyclean
mostlyclean: ##Remove most generated files
	@rm -rfv $(USB_IMAGE)

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

$(ROOT_MOUNT):
	@mkdir -p $(ROOT_MOUNT)

$(HOME_FS):
	@mkdir -p $(HOME_FS)
	@git clone --depth 1 'https://github.com/hlissner/doom-emacs' $(HOME_FS)/.emacs.d
	@git clone --depth 1 'https://github.com/Jdaco/dotfiles' $(HOME_FS)/dotfiles
	@./bin/config-tangle $(PWD) $(HOME_FS) usb
	@$(GUIX_RUN) --share=$(HOME_FS)=/home/$(USB_USER) -- bash /home/$(USB_USER)/.emacs.d/bin/doom install --no-config --no-env
	@$(GUIX_RUN) --share=$(HOME_FS)=/home/$(USB_USER) -- bash /home/$(USB_USER)/.emacs.d/bin/doom upgrade
	@rm -fv $(HOME_FS)/.emacs.d/.local/autoloads*.elc
	@mkdir $(HOME_FS)/org

usb:
	@cp -v $(shell guix system image -L $(PWD)/guix $(USB_CONFIG)) ./image.raw

$(USB_IMAGE): $(BUILD_DIR) $(ROOT_MOUNT) $(HOME_FS)
	@cp $(shell guix system image -L $(PWD)/guix $(USB_CONFIG)) $(USB_IMAGE)
	@chmod 755 $(USB_IMAGE)
	@sleep 5
	export DEV=$$(sudo losetup -Pvf --show --direct-io=on $(USB_IMAGE)) && \
	sudo mount "$${DEV}p2" $(ROOT_MOUNT) && \
	sudo cp -a $(HOME_FS) $(ROOT_MOUNT)/$(USB_USER) && \
	sudo chown -R 1000:998 $(ROOT_MOUNT) && \
	sudo umount $(ROOT_MOUNT)
	@sudo losetup -D
