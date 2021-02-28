CREATE_DEBIAN_ISO_VERSION:=0.2.0
HAL_VERSION:=0.6.1
HAL_RPM_FILE:=hal-bitcoin-$(HAL_VERSION)-1.el7.x86_64.rpm
EXTRACT_DIR:=/tmp/shamir-iso-hal

.PHONY: all
all: minimal xfce

.PHONY: clean
clean:
	rm -rf hal
	sudo rm -rf files-min/debian-custom.iso files-xfce/debian-custom.iso

hal: 
	mkdir -p $(EXTRACT_DIR)
	curl -L -o $(EXTRACT_DIR)/hal.rpm https://github.com/stevenroose/hal/releases/download/v$(HAL_VERSION)/$(HAL_RPM_FILE)
	(cd $(EXTRACT_DIR); rpm2cpio ./hal.rpm | cpio -idmv)
	cp $(EXTRACT_DIR)/usr/bin/hal ./hal

.PHONY: minimal
minimal: files-min/custom-debian.iso

.PHONY: xfce
xfce: files-xfce/custom-debian.iso

files-min/custom-debian.iso: hal
	cp hal files-min/config/
	docker run --rm -t -v $(shell pwd)/files-min:/root/files aitorpazos/create-debian-iso:$(CREATE_DEBIAN_ISO_VERSION)
	
files-xfce/custom-debian.iso: hal
	cp hal files-xfce/config/
	docker run --rm -t -v $(shell pwd)/files-xfce:/root/files aitorpazos/create-debian-iso:$(CREATE_DEBIAN_ISO_VERSION)
