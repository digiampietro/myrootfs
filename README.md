# About

This is a simple, and limited, project to build, from scratch, a (old)
linux kernel and a (old) root file system to emulate (using QEMU) and
reverse engineer some interesting binaries of an industrial, special
purpose printer based on an Intel Xscale PXA27x ARM processor.

It is easy to adapt this project to other versions of Linux or other
embedded architectures, it can be especially useful, as a starting
point, to re-build very old kernels and root file systems using very
old toolchains.

Using tools like [Buildroot](https://www.buildroot.org), [The Yocto
Project](https://www.yoctoproject.org/), [The OpenWrt Build
System](https://openwrt.org/docs/guide-developer/build-system/start),
[PTX Dist](https://www.ptxdist.org/) or similar tools is, by far, much
better than building a toolchain, a linux kernel and a root file
system, from scratch, using this project or similar set of scripts;
unless you want to do this for educational purposes.

If you want to re-build an old system with same, or similar, linux
kernel, with same, or similar gcc and glibc versions and other old
libraries version, you start looking at old versions of the tools
mentioned above. Sometimes it is not possible to find the right
combinations of kernel, toolchain, and libraries supported by old
versions of the tools mentioned above, when this happen this project
can be useful.

# Introduction

## The Challenge

A friend of mine asked me to support him to overcome a limitation of
his industrial printer, a [Linx
CJ400](https://www.kemek.eu/en/product/linx-cj400-continuous-inkjet-printer/)
used, mainly, to print expire dates on products, he provided me a dump
of the printer flash EEPROM. Because I didn't have access to the
physical printer I started gathering information from the flash EEPROM
and building an emulation enviroment on QEMU following the approach
described in a [talk at Hack In Paris
2019](http://va.ler.io/2019/0616/hack_paris_2019_cyber_security_conference.html)
Cybersecurity Conference and in the [Hardware Hacking
Tutorial](https://www.youtube.com/playlist?list=PLoFdAHrZtKkhcd9k8ZcR4th8Q8PNOx7iU)
series on the [Make Me
Hack](https://www.youtube.com/channel/UCoyNuc5bJ-z4X-6OlpNtJUw)
YouTube channel.

## Information gathering

The main results of the information gathering is:

 * The kernel identify itself as:

   ```
   Linux version 2.6.10-mainstone_pxa27x_dev (root@Caolila711) \
   (gcc version 3.4.3 (MontaVista 3.4.3-25.0.156.1001317 2010-03-14)) \
   #771 Fri Dec 13 13:35:05 GMT 2013
   ```
   
 * The kernel was compiled in 2013, but uses a version (2.6.10) that
   was released in 2004, 9 years before!

 * The commercial toolchain and development system used is Montavista
   Mobilinux 4.1 that was released in 2006;

 * The gcc version used to compile the kernel and other applications
   is gcc 3.4.3 (released in 2004);

 * The system uses glibc version 2.3.3 (released in 2004);

 * It uses the graphical library QT 4.7.3 to drive the small touch screen display;

 * It uses the Tslib library to get input from the touchscreen,
   version is unedentified, but the related library file has the name:
   libts-0.0.so.0.1.1;

 * The kernel defconfig file, used to configure the kernel, is
   included in the firmware/kernel image; this provides additional
   information;

 * The kernel uses many custom drivers, included in the kernel, but not
   available on the [supplier's website](https://www.linxglobal.com);
   a possible GNU license violation?

 * The mainboard seems based on the Intel Mainstone devolpoment board
   that is supported by the Linux kernel and by QEMU;

 * It seems that there are also patches to fix issues that the kernel
   2.6.10 is known to have with the Mainstone board;

 * QEMU is able, emulating the Mainstone board, to successfully boot
   the unmodified original kernel and original root file system;

 * The applications we are interested in crash in QEMU, because of
   missing, special purpose devices, on the emulated board;

 * Some graphical applications start in QEMU, can display the initial
   screen, but are unable to accept input from the emulated touch
   screen display;

## Building the emulation environment

### First step, easiest but less accurate

I did the first trial to build the emulated environment using
Buildroot and the oldest Buildroot version (released in 2013) that was
supporting glibc. Previous versions were supporting alternative, and
smaller, libc variants like uClibc.

Buildroot didn't explicitly support the Mainstone board, anyway the
Linux kernel supported it. The result was that the Linux kernel,
produced by Buildroot, didn't successfully boot on the emulated QEMU
board.

I compiled a much more recent Linux Kernel (4.7.5, released in 2016)
using a toolchain built with
[crosstool-NG](http://crosstool-ng.github.io/); I used the root file
system built by Buildroot and I was able to successfully boot the
emulated system.

I copied the original printer's root file system on a directory of the
actual root file system of the QEMU machine and, using chroot, I was
able to have some applications to display their graphical screen on
the emulated display, but weren't able to accept emulated touchpad
input.

Executing these applications outside of the chroot environment I
received the following error:

```
./UsbAuthDialog: /lib/libpthread.so.0: version `GLIBC_2.0' \
not found (required by ./UsbAuthDialog)
```

This is probably related to the fact thet the glibc version installed
on our root file system (2.18, released in 2013) is more recent than
the original glibc version (2.3.3, released in 2004)

### Second step, harder but more accurate

To build a more accurate emulation system I decided to build
everything (Toolchain, Linux Kernel and root file system) from
scratch, because I wasn't able to find any automatic (old) build
system with the right combinations of toolchain/kernel/glibc versions.

The target was to use same, or similar, versions as in our industrial
printer:

 * gcc 3.4.3

 * glibc 2.3.3

 * kernel 2.6.10

The nearest toolchain I was able to build, using an old verison (0.43)
of [Crosstool](http://kegel.com/crosstool/) (before it became
[Crosstool-NG](http://crosstool-ng.github.io/)), is based on:

 * gcc 3.4.5, it should be ok, only the patch level is slightly higher
   than our original target;

 * glibc 2.3.5, it should be ok, only the patch level is slightly higher
   than our original target.

Regarding the kernel I successfully compiled the kernel 2.6.10 with
the above toolchain, but, probably because I didn't have the same
patches that the printer's firmware developer applied to this kernel
version, I wasn't able to mount the root file system on the emulated
SD card.

I found on the Internet some issues with some kernel version and the
support of the Intel Mainstone board; making a long story short, I
found that the kernel 2.6.21 (released in 2007) was the older mainline
kernel supporting without, big issues, the QEMU emulated Mainstone
board.

But to compile the 2.6.21 kernel a toolchain based on gcc 3.4.5 was
not fit for the job.

I downloaded another, additional, old toolchain, originally released
by [Code Sourcery](http://codesourcery.com) (now part of Mentor
Graphics, a Siemens Company) based on gcc 4.6.1 and that is able to
compile the kernel 2.6.21.

I used the crosstool toolchain to build the root file system.

I was not able to use a recent Linux distribution to recompile
everything, because it is impossible to recompile old, and complex,
software (like the toolchain) with a modern gcc compiler. To reduce
the risks of difficult or impossible to fix compilation errors it is
much better to use a Linux distribution of the same age, more or less,
of the toolchain we want to build. For this reason I used a Debian
Etch (released in 2007) in a Docker container sharing the user's home
directory with the Linux host.

The QEMU emulation, instead, runs on a modern Linux distribution (in
my case Ubuntu 18.04 and Ubuntu 20.04).

# Description

This project has the following folders:

 * **build** used for compilation and image generation;

 * **configs** used for configurations, like the kernel defconfig and
     other packages configuration;

 * **download** used to store packages, toolchain and kernels
     downloaded from the Internet;

 * **templates** used to store files that will be copied to the root
     file system;

 * **scripts** used to store the scripts used to build the toolchain,
     the kernel, the packages and to generate the root file system.


## Main scripts

The main scripts in the **scripts** folder are:

 * **setenv.sh** this file is sourced by all of the other files and
     contains environment variable settings;

 * **rebuild.sh** this is the main file to download and compile
     everything (toolchain, kernel, packages) and to generate the root
     file system;

 * **pkgs-download.sh** downlad packages and extract them in the
     **build** directory;

 * **packages.txt** list of URLs containing toolchains, kernel and
     packages to download;

 * **install-toolchains.sh** compile and install the two toolchains
     (one used for kernel compilation and the other for packages
     compilation);

 * **build-...** build script to build the kernel or the related packages;

 * **install-templates.sh** installs template files to the root file system;

 * **install-libs.sh** installs toolchain libreries to the root file system;

 * **make-clean.sh** clean (remove files) the root file system and the
     root file system image;

 * **make-images.sh** create the root file system image;

 * **kermake.sh** set the correct environment for kernel compilation
     and then execute the make command;

 * **mytc.sh** set the crosstoolchain environment and then executes
     the command passed as argument;

 * **qr.sh** executes QEMU with the Linux Kernel zImage and the root
     file system image.



