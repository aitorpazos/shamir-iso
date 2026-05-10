CREATE_DEBIAN_ISO_VERSION:=0.4.0
HAL_VERSION:=0.9.3
HAL_VENDORED_FILE:=hal-$(HAL_VERSION)-vendored.tar.gz
SCRYPT_RS_VERSION:=1.0.0
SSSS_RS_VERSION:=1.0.0
EXTRACT_DIR:=/tmp/shamir-iso-files

# Architecture: amd64 (default) or arm64
ARCH ?= amd64

ifeq ($(ARCH),arm64)
  SCRYPT_RS_TARBALL:=scrypt-rs-linux-arm64.tar.gz
  SSSS_RS_TARBALL:=ssss-rs-linux-arm64.tar.gz
  HAL_CARGO_TARGET:=aarch64-unknown-linux-gnu
else
  SCRYPT_RS_TARBALL:=scrypt-rs-linux-amd64.tar.gz
  SSSS_RS_TARBALL:=ssss-rs-linux-amd64.tar.gz
  HAL_CARGO_TARGET:=x86_64-unknown-linux-gnu
endif

.PHONY: all
all: minimal xfce

.PHONY: clean
clean:
	rm -rf hal scrypt-rs ssss-rs
	rm -rf files-{min,xfce}/config/{hal,scrypt-rs,ssss-rs}
	sudo rm -rf files-{min,xfce}/custom-debian.iso

hal:
	mkdir -p $(EXTRACT_DIR)
	curl -L -o $(EXTRACT_DIR)/hal-vendored.tar.gz \
		https://github.com/stevenroose/hal/releases/download/v$(HAL_VERSION)/$(HAL_VENDORED_FILE)
	(cd $(EXTRACT_DIR); tar -xf hal-vendored.tar.gz)
	(cd $(EXTRACT_DIR)/hal-$(HAL_VERSION); cargo build --release --target $(HAL_CARGO_TARGET))
	cp $(EXTRACT_DIR)/hal-$(HAL_VERSION)/target/$(HAL_CARGO_TARGET)/release/hal ./hal

scrypt-rs:
	mkdir -p $(EXTRACT_DIR)
	curl -L -o $(EXTRACT_DIR)/scrypt-rs.tar.gz \
		https://github.com/aitorpazos/scrypt-rs/releases/download/v$(SCRYPT_RS_VERSION)/$(SCRYPT_RS_TARBALL)
	(cd $(EXTRACT_DIR); tar -xf scrypt-rs.tar.gz)
	cp $(EXTRACT_DIR)/scrypt-rs ./scrypt-rs

ssss-rs:
	mkdir -p $(EXTRACT_DIR)
	curl -L -o $(EXTRACT_DIR)/ssss-rs.tar.gz \
		https://github.com/aitorpazos/ssss-rs/releases/download/v$(SSSS_RS_VERSION)/$(SSSS_RS_TARBALL)
	(cd $(EXTRACT_DIR); tar -xf ssss-rs.tar.gz)
	cp $(EXTRACT_DIR)/ssss-rs ./ssss-rs

.PHONY: minimal
minimal: files-min/custom-debian.iso

.PHONY: xfce
xfce: files-xfce/custom-debian.iso

files-min/custom-debian.iso: hal scrypt-rs ssss-rs
	cp hal scrypt-rs ssss-rs files-min/config/
	docker run --rm -t -v $(shell pwd)/files-min:/root/files aitorpazos/create-debian-iso:$(CREATE_DEBIAN_ISO_VERSION)

files-xfce/custom-debian.iso: hal scrypt-rs ssss-rs
	cp hal scrypt-rs ssss-rs files-xfce/config/
	docker run --rm -t -v $(shell pwd)/files-xfce:/root/files aitorpazos/create-debian-iso:$(CREATE_DEBIAN_ISO_VERSION)
