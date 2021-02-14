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

Log in using `root` user and `toor` as a password.

**If your system has UEFI Secure Boot enabled, you will need to disable it or switch to BIOS mode (also called legacy mode)
in your firmware options**

### Split a key

To split a given key use the `ssss-split` command setting how many shares you want to create and how many of them are needed
to recover the original key. Example where the key is divided in 5 pieces and can be recovered with any of 3 pieces):

```shell
echo "hello world" | ssss-split -t 3 -n 5
```

Output:

```
Generating shares using a (3,5) scheme with dynamic security level.
Enter the secret, at most 128 ASCII characters: Using a 48 bit security level.
1-79f847d32bc7d404219fe0
2-358a7ebd071055db71670f
3-ce9914f9142d07c513d320
4-e937954b216efe6ffb2379
5-1224ff0f3253ac71999744
```

### Recover a key

To recover a key from the splitted keys, you can run the following command (using above split):

```shell
ssss-combine -t 3
```

Output:

```
Enter 3 shares separated by newlines:
Share [1/3]: 2-358a7ebd071055db71670f
Share [2/3]: 4-e937954b216efe6ffb2379
Share [3/3]: 5-1224ff0f3253ac71999744
Resulting secret: hello world
```

## Download the image

The latest image is published to the [GitHub releases page](https://github.com/aitorpazos/shamir-iso/releases).

## Build the image

You can build the image yourself with `make build`.
