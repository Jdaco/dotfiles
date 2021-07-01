SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c

BUILD_DIR := build

USB_USER := guest
USB_IMAGE := $(BUILD_DIR)/usb.raw
USB_CONFIG := machines/usb/config.scm
USB_HOME_UUID := 77941632-5715-4b77-a1f0-a32aeeae7a38

HOME_FS := $(BUILD_DIR)/home/$(USB_USER)
ROOT_MOUNT := $(BUILD_DIR)/root

FILES := $(BUILD_DIR)

.DEFAULT_GOAL := $(USB_IMAGE)
# .DEFAULT_GOAL := $(HOME_FS)

GUIX_RUN := guix environment --container --user=$(USB_USER) \
							 		  --pure --network --no-cwd \
								 	  --ad-hoc grep sed diffutils patch gawk tar gzip bzip2 xz lzip emacs git bash coreutils fd ripgrep findutils curl wget nss-certs which

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
	@git clone 'https://github.com/hlissner/doom-emacs' $(HOME_FS)/.emacs.d
	@./bin/config-tangle $(PWD) $(HOME_FS) usb
	@$(GUIX_RUN) --share=$(HOME_FS)=/home/$(USB_USER) -- bash /home/$(USB_USER)/.emacs.d/bin/doom install --no-config --no-env
	@sed -i "s,$(shell $(GUIX_RUN) -- bash -c 'echo $${GUIX_ENVIRONMENT}'),/run/current-system/profile,g" $(HOME_FS)/.emacs.d/.local/autoloads*.el
	@rm -fv $(HOME_FS)/.emacs.d/.local/autoloads*.elc
	@mkdir $(HOME_FS)/org

$(USB_IMAGE): $(BUILD_DIR) $(ROOT_MOUNT) $(HOME_FS)
	@cp $(shell guix system image $(USB_CONFIG)) $(USB_IMAGE)
	@chmod 755 $(USB_IMAGE)
	@dd if=/dev/zero bs=1M count=1024 >> $(USB_IMAGE)
	@sudo kpartx -av $(USB_IMAGE)
	@sudo parted --script --align optimal /dev/loop0 mkpart primary 7600MB 100%
	@sudo kpartx -uv $(USB_IMAGE)
	@sudo mkfs.ext4 -v -U "$(USB_HOME_UUID)" /dev/mapper/loop0p3
	@sudo mount /dev/mapper/loop0p3 $(ROOT_MOUNT)
	@sudo cp -a $(HOME_FS) $(ROOT_MOUNT)/$(USB_USER)
	@sudo chown -R 1000:998 $(ROOT_MOUNT)
	@sudo umount /dev/mapper/loop0p3
	@sudo kpartx -dv $(USB_IMAGE)
