#!/bin/bash

export MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $MYDIR/setenv.sh

LNXDIR=`/bin/ls -d $BUILD/linux-*`
BLDDIR=$BUILD/linux/build

if [ ! -d $BLDDIR ]
then
    echo "-----> making dir $BLDDIR"
    mkdir -p $BLDDIR
fi

if [ ! -d $LNXDIR ]
then
    echo "-----> ERROR Linux source tree $LNXDIR not found"
    exit 1
fi

if [ ! -d $BLDDIR ]
then
    mkdir -p $BLDDIR
fi

kermake.sh mrproper
cp $CONFIGS/kernel_defconfig $BLDDIR/.config
kermake.sh oldconfig
kermake.sh zImage
