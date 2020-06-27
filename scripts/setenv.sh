#!/bin/bash

# MYDIR: directory where this script is located
# if it is sourced do not reset the MYDIR directory

if [ "$MYDIR" = "" ]
then
    export MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
fi

# variables far various, old, toolchains
# ---- ---------------------------------
# CS:  Code Sourcery
# CT:  CROSS TOOL NG
# PTX: Ptxdist - OSELAS toolchain
# OCT: Original Cross Tool

CS_TCBINPATH=/opt/cs/bin
CS_TCLIBPATH=unknown
 CS_TCPREFIX=arm-none-linux-gnueabi-

CT_TCBINPATH=/home/valerio/x-tools/arm-unknown-linux-uclibcgnueabi/bin
CT_TCLIBPATH=unknown
 CT_TCPREFIX=arm-unknown-linux-uclibcgnueabi-

PTX_TCBINPATH=/opt/OSELAS.Toolchain-1.1.1/arm-xscale-linux-gnueabi/gcc-4.1.2-glibc-2.5-kernel-2.6.18/bin
PTX_TCLIBPATH=unknown
 PTX_TCPREFIX=arm-xscale-linux-gnueabi-

OCT_TCBINPATH=/opt/crosstool/gcc-3.4.5-glibc-2.3.5/arm-xscale-linux-gnu/bin
OCT_TCLIBPATH=/opt/crosstool/gcc-3.4.5-glibc-2.3.5/arm-xscale-linux-gnu/arm-xscale-linux-gnu/lib
 OCT_TCPREFIX=arm-xscale-linux-gnu-


# --------------------------------------------------------------------------------------------------------------
# add2path: add a dir to PATH if not already in path
# -------------------------------------------------------------------------------------------------------------- 
#   $1 dir to add
#   $2 optional, if "front" the dir will be added in front of existing PATH
# ref: https://codereview.stackexchange.com/questions/88236/unix-shell-function-for-adding-directories-to-path
# --------------------------------------------------------------------------------------------------------------                                   

add2path() {
  if ! echo "$PATH" | PATH=$(getconf PATH) grep -Eq '(^|:)'"${1:?missing argument}"'(:|\$)' ; then # Use the POSIX grep implementation
    if [ -d "$1" ]; then        # Don't add a non existing directory to the PATH
      if [ "$2" = front ]; then # Use a standard shell test
        PATH="$1:$PATH"
      else
        PATH="$PATH:$1"
      fi
      export PATH
    fi
  fi
}

 
# Actual variables
# -------------------------------------------------------------------------------------------------------
# CURRTC:     Current Toolchain
# MAINDIR:    Top directory of this project
# ROOTFS:     Root target file system dir
# BUILD:      Build directory
# IMAGES:     Images directory 
# TEMPLATES:  Target root file system templates
# TCLIB:      Toolchain target library files 
# TCPATH:     Toolchain executable binary path
# TCPATH:     Toolchain prefix, without "-" at the end
# TCGCC:      Toolchain full path to the gcc executable
# TCLD:       Toolchain full path to the ld executable
# FAKEROOTCONF: fakeroot conf file use with -i and -s options

export CURRTC="OCT"
export MAINDIR="$( cd $MYDIR/.. && pwd )"
export ROOTFS="$MAINDIR/build/rootfs"
export BUILD="$MAINDIR/build"
export IMAGES="$MAINDIR/build/images"
export TEMPLATES="$MAINDIR/templates"
export CONFIGS="$MAINDIR/configs"
eval   TCLIB=\$${CURRTC}_TCLIBPATH
export TCLIB
eval   TCPATH=\$${CURRTC}_TCBINPATH
export TCPATH
eval   TCPREFIX=\$${CURRTC}_TCPREFIX
TCPREFIX=`echo $TCPREFIX | sed 's/-$//'`
export TCPREFIX
export TCGCC=$TCPATH/$TCPREFIX-gcc
export TCLD=$TCPATH/$TCPREFIX-ld
export FAKEROOTCONF=$BUILD/rootfs.fakeroot
export OLDPATH=$PATH

add2path $TCPATH
add2path $MYDIR

if [ "$1" = "debug" ]
then
    for i in MAINDIR ROOTFS BUILD IMAGES TEMPLATES CONFIGS TCLIB TCPATH TCPREFIX TCGCC TCLD FAKEROOTCONF OLDPATH PATH
    do
	printf "%-13s : " $i
	eval v=\$$i
	echo $v
    done
fi

