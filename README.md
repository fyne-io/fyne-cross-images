# Fyne Cross Images

fyne-cross is a simple tool to cross compile and create distribution packages
for [Fyne](https://fyne.io) applications using docker images that include Linux,
the MinGW compiler for Windows, FreeBSD, and a macOS SDK, along with the Fyne
requirements.

This project provides the docker images required by fyne-cross to cross compile.

## Requirements

- docker / podman

## Supported targets

Table below reports the status of `fyne-cross`'s supported cross compilation targets.
The supported architectures for the host are `amd64`and `arm64`. 

|                | amd64              | arm64 |
| -------------- | ------------------ | ----- |
| android/386    |                    |       |
| android/amd64  |                    |       |
| android/arm    |                    |       |
| android/arm64  |                    |       |
| darwin/amd64   |                    |       |
| darwin/arm64   |                    |       |
| freebsd/amd64  |                    |       |
| freebsd/arm64  |                    |       |
| linux/amd64    | :white_check_mark: |       |
| linux/386      | :white_check_mark: |       |
| linux/arm      | :white_check_mark: |       |
| linux/arm64    | :white_check_mark: |       |
| windows/amd64  | :white_check_mark: |       |
| windows/386    | :white_check_mark: |       |

## Contribute

- Fork and clone the repository
- Make and test your changes
- Open a pull request against the `develop` branch

### Contributors

See [contributors](https://github.com/fyne-io/fyne-cross-images/graphs/contributors) page
