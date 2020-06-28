#!/bin/bash
#
# Prpares the environment for cross compilation and then invoke
# make with the parameters passed to this script
#
# useful during kernel configuration/compilation
#
export MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $MYDIR/setenv.sh


LNXDIR=`/bin/ls -d $BUILD/linux-*`
BLDDIR=$BUILD/linux/build

# remove from path the default toolchain
rmpath $TCPATH
# add the Cose Sourcery tool chain to path
add2path /opt/cs/bin
# set the Code Sourcery prefix
TCPREFIX=arm-none-linux-gnueabi


if [ ! -d $LNXDIR ]
then
    echo "-----> ERROR Linux source tree $LNXDIR not found"
    exit 1
fi

echo "-----> MYDIR:   $MYDIR"
echo "-----> LNXDIR:  $LNXDIR"
echo "-----> BLDDIR:  $BLDDIR"
echo "-----> TCREFIX: $TCPREFIX"
echo "-----> PATH:    $PATH"


if which ${TCPREFIX}-gcc
then
    echo "-----> gcc compiler: ${TCPREFIX}-gcc"
else
    echo "-----> ERROR gcc compiler ${TCPREFIX}-gcc not found"
    exit 1
fi

make -C $LNXDIR \
     ARCH=arm \
     CROSS_COMPILE=${TCPREFIX}- \
     O=$BLDDIR \
     $1 
