# Shamir ISO

This project creates an ISO image with enough tooling to create and recover Shamir keys using [ssss-rs](https://github.com/aitorpazos/ssss-rs).

It uses the [create-debian-iso](https://github.com/aitorpazos/create-debian-iso) project to generate the ISO images.

## Why bother?

The main reason for this project is to provide a minimalistic environment which allows us to split secrets in multiple
pieces and use any number of those pieces (configurable) to recover the original secret (See [Shamir's Secret Sharing](https://en.wikipedia.org/wiki/Shamir%27s_Secret_Sharing)).

This environment greatly reduces the risk of exposing the key to malware or other software we may run in our daily work
environment. When booting into it on computer startup, we are booting into a stack that has no networking capabilities which
doesn't do any persistence to disk. It is just your device firmware + the little tools in the ISO.

Even running it in a VM may provide a safer environment than your usual OS, but not as safe as booting into it.

Use cases include:
- Store pieces in multiple sites to protect against losing the key in case of a disaster
- Share cryptocurrency seeds with multiple people but prevent any of them from using the seed without the knowledge
  of the rest of participants

## Included tools

| Tool | Version | Description |
|------|---------|-------------|
| [ssss-rs](https://github.com/aitorpazos/ssss-rs) | 1.0.0 | Shamir's Secret Sharing split/combine |
| [scrypt-rs](https://github.com/aitorpazos/scrypt-rs) | 1.0.0 | scrypt key derivation |
| [hal](https://github.com/stevenroose/hal) | 0.9.3 | Bitcoin/BIP39 utilities |
| qrencode | — | QR code generation |
| zbar-tools | — | QR code scanning (webcam) |

## Download the image

The latest image is published to the [GitHub releases page](https://github.com/aitorpazos/shamir-iso/releases).

Two variants are available:
- **minimal** — IceWM, CLI-focused, smallest footprint
- **xfce** — XFCE desktop with printing support and a card generator script

## Run the image

You can run this image in a VM by selecting it as the CD-ROM image and booting from it, or burn it to a CD/USB stick.

To write it to a USB memory stick (**this will erase all data on the device**):

```shell
dd status=progress if=shamir-manage.iso of=/dev/<your USB stick device> bs=1M
```

**Credentials:**
- Minimal image: `root` / `toor`
- XFCE image: `user` / `user` (starts as `user`)

> **Note:** If your system has UEFI Secure Boot enabled, you will need to disable it or switch to BIOS/legacy mode
> in your firmware options.

### Split a key

To split a given key, use the `ssss-rs split` command. Example where the key is divided in 5 pieces and can be recovered with any 3 of them:

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

To recover a key from the split shares:

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

If you want to use this image to backup or restore your crypto wallet words list, the image includes the `hal` command which provides different crypto related operations.

For example:
- Generate entropy value from words list and pass it to `ssss-rs split`:
```shell
hal bip39 get-seed "your BIP words" | jq -r .entropy | ssss-rs split -t <x> -s <n> -i -
```
- Generate words list from entropy value:
```shell
hal bip39 generate -w <number of words> --entropy <entropy value>
```
The possible number of words are: 3, 6, 9, 12, 15, 18, 21 or 24 (the usual ones being 12 and 24).

### Generate a QR code

```shell
echo "My text" | qrencode -o qr.png
display qr.png
```

### Scan a QR code (webcam)

```shell
zbarcam --raw
```

### Print a share card (XFCE image only)

```shell
create-key-share-card SHARE_NAME SHARE_KEY_VALUE
```

This generates an HTML file with a printable card containing the share value and a QR code.

## Build the images

You can build the images yourself with `make`. A Rust toolchain and Docker are required.

```shell
make minimal   # Build the minimal (IceWM) image
make xfce      # Build the XFCE image
make           # Build both
```

## License

GPLv3
