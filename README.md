# lineageos14.1-arch-docker-builder

* Image is based on arch. This allows to use [lineageos-devel](https://aur.archlinux.org/packages/lineageos-devel/) AUR package.
* I only tested building it on LineageOS 14.1 (Nougat).
    - It should also work with Oreo, but I have not tested that.
    - It should also work with other versions, but you need to install the right jdk version.
    - It should also work with AOSP, just install `aosp-devel` istead of `lineageos-devel`
* ccache is enabled by default (`50G`)

For more documentation, please see [Archwiki: Building Android](https://wiki.archlinux.org/title/android#Building)

## Usage

* Get docker and GNU Make
* Run `make` - it will build the image and run it, mounting `android/` folder into the image.
* Follow build instructions for your device. Example: [crackling](https://wiki.lineageos.org/devices/crackling/build).
