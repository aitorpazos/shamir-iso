CREATE_DEBIAN_ISO_VERSION:=0.2.0
HAL_VERSION:=0.6.1
HAL_RPM_FILE:=hal-bitcoin-$(HAL_VERSION)-1.el7.x86_64.rpm
SCRYPT_RS_VERSION:=0.2.0
SCRYPT_RS_TARBALL_FILE:=scrypt-rs-amd64-v$(SCRYPT_RS_VERSION).tar.gz
EXTRACT_DIR:=/tmp/shamir-iso-files

.PHONY: all
all: minimal xfce

.PHONY: clean
clean:
	rm -rf hal scrypt-rs
	rm -rf files-{min,xfce}/config/{hal,scrypt-rs}
	sudo rm -rf files-{min,xfce}/debian-custom.iso

hal: 
	mkdir -p $(EXTRACT_DIR)
	curl -L -o $(EXTRACT_DIR)/hal.rpm https://github.com/stevenroose/hal/releases/download/v$(HAL_VERSION)/$(HAL_RPM_FILE)
	(cd $(EXTRACT_DIR); rpm2cpio ./hal.rpm | cpio -idmv)
	cp $(EXTRACT_DIR)/usr/bin/hal ./hal

scrypt-rs: 
	mkdir -p $(EXTRACT_DIR)
	curl -L -o $(EXTRACT_DIR)/scrypt-rs.tar.gz https://github.com/aitorpazos/scrypt-rs/releases/download/v$(SCRYPT_RS_VERSION)/$(SCRYPT_RS_TARBALL_FILE)
	(cd $(EXTRACT_DIR); tar -xvf scrypt-rs.tar.gz)
	cp $(EXTRACT_DIR)/scrypt-rs ./scrypt-rs

.PHONY: minimal
minimal: files-min/custom-debian.iso

.PHONY: xfce
xfce: files-xfce/custom-debian.iso

files-min/custom-debian.iso: hal scrypt-rs
	cp hal scrypt-rs files-min/config/
	docker run --rm -t -v $(shell pwd)/files-min:/root/files aitorpazos/create-debian-iso:$(CREATE_DEBIAN_ISO_VERSION)
	
files-xfce/custom-debian.iso: hal scrypt-rs
	cp hal scrypt-rs files-xfce/config/
	docker run --rm -t -v $(shell pwd)/files-xfce:/root/files aitorpazos/create-debian-iso:$(CREATE_DEBIAN_ISO_VERSION)
