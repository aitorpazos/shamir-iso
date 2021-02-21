.PHONY: all
all: files/custom-debian.iso

files/custom-debian.iso:
	docker run --rm -t -v $(shell pwd)/files:/root/files aitorpazos/create-debian-iso:0.2.0
