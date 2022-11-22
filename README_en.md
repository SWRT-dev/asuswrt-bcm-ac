[中文](README.md)
=======

AC series:[https://github.com/SWRT-dev/asuswrt-bcm-ac](https://github.com/SWRT-dev/asuswrt-bcm-ac)
AX series:[https://github.com/SWRT-dev/asuswrt-bcm](https://github.com/SWRT-dev/asuswrt-bcm)

NOTE：
=
1. **DO NOT USE** **root** user for git or compilation!!!
2. if you are in china, you need a network proxy

## Compilation

1. Install Ubuntu 64bit，Ubuntu 18 LTS x64 and Mint 19.1 are recommended

2. Run `sudo apt-get update` in terminal, and then run
`
sudo apt-get -y install build-essential asciidoc binutils bzip2 gawk gettext git libncurses5-dev libz-dev patch python3.5 python2.7 unzip zlib1g-dev lib32gcc1 libc6-dev-i386 subversion flex uglifyjs git-core gcc-multilib p7zip p7zip-full msmtp libssl-dev texinfo libglib2.0-dev xmlto qemu-utils upx libelf-dev autoconf automake libtool autopoint device-tree-compiler g++-multilib antlr3 gperf wget libncurses5:i386 libelf1:i386 lib32z1 lib32stdc++6 gtk-doc-tools intltool binutils-dev cmake lzma liblzma-dev lzma-dev uuid-dev liblzo2-dev xsltproc dos2unix libstdc++5 docbook-xsl-* sharutils autogen shtool gengetopt libltdl-dev libtool-bin
`

3. Run `git clone https://github.com/SWRT-dev/asuswrt-bcm-ac` to clone the source code 

4. Run `git clone https://github.com/SWRT-dev/bcmhnd-toolchains` to clone the toolchains

5. Run `cd bcmhnd-toolchains` to enter the directory, and follow commands step by step 

    `sudo mkdir -p /opt/toolchains/`

    `sudo ln -sf $(pwd)/crosstools-aarch64-gcc-5.3-linux-4.1-glibc-2.22-binutils-2.25 /opt/toolchains/`

    `sudo ln -sf $(pwd)/crosstools-arm-gcc-5.3-linux-4.1-glibc-2.22-binutils-2.25 /opt/toolchains/`

    `sudo ln -sf $(pwd)/crosstools-aarch64-gcc-5.3-linux-4.1-glibc-2.24-binutils-2.25 /opt/toolchains/`
    
    `sudo ln -sf $(pwd)/crosstools-aarch64-gcc-5.5-linux-4.1-glibc-2.26-binutils-2.28.1 /opt/toolchains/`
    
    `sudo ln -sf $(pwd)/crosstools-arm-gcc-5.3-linux-4.1-glibc-2.24-binutils-2.25 /opt/toolchains/`
    
    `sudo ln -sf $(pwd)crosstools-arm-gcc-5.5-linux-4.1-glibc-2.26-binutils-2.28.1 /opt/toolchains/`
    
    `sudo ln -sf $(pwd)/crosstools-gcc-5.3-linux-4.1-uclibc-1.0.12-glibc-2.24-binutils-2.25 /opt/toolchains/`
    
    `sudo mkdir -p /projects/`
    
    `sudo mkdir -p /projects/bca/`
    
    `sudo mkdir -p /projects/bca/tools/`
    
    `sudo mkdir -p /projects/bca/tools/linux/`
    
    `sudo mkdir -p /projects/bca/tools/linux/bin/`
    
    `sudo ln -sf $(pwd)/hndtools-armeabi-2013.11 /projects/bca/tools/linux/`
    
    `sudo ln -sf $(pwd)/fwtag.ini /projects/bca/tools/linux/bin/`
    
    `sudo ln -sf /projects/bca/ /projects/hnd/`

    `chsh -s /bin/bash`

    `sudo ln -sf /bin/bash /bin/sh`

6. Build firmware

	`cd asuswrt-bcm-ac/release/src-rt-6.x.4708`

	`make rt-ac68u`

	`cd asuswrt-bcm-ac/release/src-rt-7.14.114.x/src` 

	`make rt-ac88u`

	`make rt-ac3100`

	`make rt-ac5300`

	`cd asuswrt-bcm-ac/release/src-rt-5.02hnd` 

	`make rt-ac86u`

	`make gt-ac2900`

	Build result will be produced to `asuswrt-bcm/release/src-rt-xxxxx/image` directory

	asuswrt-bcm-ac/release/src-rt-6.x.4708/image 

	asuswrt-bcm-ac/release/src-rt-7.14.114.x/src/image

	asuswrt-bcm-ac/release/src-rt-5.02hnd/image


This source code is promised to be compiled successfully.

You can use this source code freely, but please link this GitHub repository when redistributing. Thank you for your cooperation!

## Donate

If this project does help you, please consider donating to support the development of this project.

### PayPal

[![Support via PayPal](https://cdn.rawgit.com/twolfson/paypal-github-button/1.0.0/dist/button.svg)](https://paypal.me/paldier9/)

### Alipay 支付宝

![alipay](doc/alipay_donate.jpg)

### Wechat 微信
  
![wechat](doc/wechat_donate.jpg)

