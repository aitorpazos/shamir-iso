CREATE_DEBIAN_ISO_VERSION:=0.2.0

.PHONY: all
all: minimal xfce

.PHONY: minimal
minimal: files-min/custom-debian.iso

.PHONY: xfce
xfce: files-xfce/custom-debian.iso

files-min/custom-debian.iso:
	docker run --rm -t -v $(shell pwd)/files-min:/root/files aitorpazos/create-debian-iso:$(CREATE_DEBIAN_ISO_VERSION)
	
files-xfce/custom-debian.iso:
	docker run --rm -t -v $(shell pwd)/files-xfce:/root/files aitorpazos/create-debian-iso:$(CREATE_DEBIAN_ISO_VERSION)
