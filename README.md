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

`root` user has the password set to `toor`.
Xfce image starts as `user` (password `user`).

**If your system has UEFI Secure Boot enabled, you will need to disable it or switch to BIOS mode (also called legacy mode)
in your firmware options**

### Split a key

To split a given key use the `ssss-rs split` command setting how many shares you want to create and how many of them are needed
to recover the original key. Example where the key is divided in 5 pieces and can be recovered with any of 3 pieces):

```shell
echo "hello world" | ssss-rs split -t3 -s5 -i -
```

Output:

```
017ec708e757c335e716f36b
0274d0d41038183484dfffd0
036272b09b00fb760cbb60df
049091dc4b5de9c00fbcbf89
058633b8c0650a8287d82086
```

### Recover a key

To recover a key from the splitted keys, you can run the following command (using above split):

```shell
ssss-rs combine 0274d0d41038183484dfffd0 049091dc4b5de9c00fbcbf89 058633b8c0650a8287d82086
```

Output:

```
Recovered key: hello world
Recovered key in base64: aGVsbG8gd29ybGQ=
Error decoding key to hex (expected for non hexadecimal keys): OddLength
BIP39 words list generation skipped
```

### BIP39 Keys

If you want to use this image to backup or restore your crypto wallet words list, the image includes the `hal` command (from [https://github.com/stevenroose/hal](https://github.com/stevenroose/hal)) which provides different crypto related operations.

For example:
- Generate entropy value from words list and pass it to `ssss-split`:
```shell
hal bip39 get-seed "your BIP words" | jq -r .entropy | ssss-split -t <x> -n <n>
```
- Generate words list from entropy value:
```shell
hal bip39 generate -w <number of words> --entropy <entropy value>
```
If you don't select the correct number of words, the generation will fail. However the possible values are: 3, 6, 9, 12, 15, 18, 21 or 24 (the usual ones being 12 and 24).

## Download the image

The latest image is published to the [GitHub releases page](https://github.com/aitorpazos/shamir-iso/releases).

## Build the images

You can build the image yourself with `make`.

`make minimal` will build the minimal image
`make xfce` will build xfce based image

## TODO

- Create image for arm64 boards
