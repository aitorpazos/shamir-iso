# Shamir ISO

This project creates an ISO image with enough tooling to create and recover Shamir keys with [ssss](http://point-at-infinity.org/ssss/).

It uses the https://github.com/aitorpazos/create-debian-iso project to generate the ISO images.

## Why bother?

The main reason for this project is to provide a minimalistic environment which allows us to split secrets in multiple
pieces and use any number of those pieces (configurable) to recover the original secret (See [Shamir's Secret Sharing](https://en.wikipedia.org/wiki/Shamir%27s_Secret_Sharing)).

This environment greatly reduces the risk of exposing the key to malware or other software we may run in our daily work
environment. When booting into it on computer startup, we are booting into a stack that has no networking capabilities which
doesn't do any persistence to disk. It is just your device firmware + the little tools in the ISO.

Even running it in a VM may provide a safer environment than your usual OS, but not as safe as booting into it.

Use cases include:
    - Store pieces in multiple sites to protect against losing the key in case of a disaster
    - Share cryptocurrencies seeds with multiple people but prevent any of them to use the seed without the knowledge
      of the rest of participants

## Run the image

To run this image, you can run it in a VM by selecting it as the CD-ROM image and booting from it or you can burn it into
a CD. You can also write it to an USB memory stick with the following command (only use this command if you know what you
are doing):

```shell
dd status=progress if=shamir-manage.iso of=/dev/<your USB stick device> bs=1M
```

## Download the image

The latest image is published to the GitHub releases page.

## Build the image

You can build the image yourself with `make build`.
