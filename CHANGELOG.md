# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.9.0] - 2021-04-22

### Changed

- [ssss-combine and ssss-split](http://point-at-infinity.org/ssss/) replaced by [ssss-rs](https://github.com/aitorpazos/ssss-rs)
  command

## [0.8.1] - 2021-03-28

### Added

- `skanlite` package to provide scanning capabilities

### Fixed

- Added missing printer drivers packages explicitly
- Reduce key text size in printable card so it does not overflow

## [0.8.0] - 2021-03-27

### Added

- `zbarcam` tool to be able to scan QR codes using the webcam
- `create-key-share-card` script to generate printable cards in xfce ISO

## [0.7.0] - 2021-03-14

### Added

- `scrypt-rs` binary from https://github.com/aitorpazos/scrypt-rs to generate derived keys using scrypt

### Removed

- `nettle-bin` package in favour of scrypt

## [0.6.0] - 2021-03-07

### Added

- `nettle-bin` package to provide PBKDF2 key derivation tools

## [0.5.0] - 2021-02-28

### Added

- `hal` command from [https://github.com/stevenroose/hal](https://github.com/stevenroose/hal) to manage BIP39 crypto wallets word lists

### Fixed

- Version set in GitHub release workflow

## [0.4.0] - 2021-02-27

### Added

- A separate image with XFCE

### Removed

- Printers support from minimal image

## [0.3.0] - 2021-02-21

### Added

- Printer support (experimental)
- Background with some tips

### Changed

- Automatically start X session
- Update ISO builder image to `aitorpazos/create-debian-iso:0.2.0`

## [0.2.0] - 2021-02-14

### Added

- `icewm` added and started on login

## [0.1.0] - 2021-02-13

### Added

- Initial release
