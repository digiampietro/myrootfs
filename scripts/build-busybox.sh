#!/bin/bash

export MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $MYDIR/setenv.sh

if cd $BUILD/busybox*
then
    echo "-----> changed dir to `pwd`"
else
    echo "-----> ERROR IN changing dir to $BUILD/busybox* "
    echo "-----> ERROR exiting"
    exit 1
fi

# echo "-----> Configuring"
# ./configure --host=$TCPREFIX \
# 	    --prefix=$ROOTFS \
# 	    --disable-zlib \
# 	    CC=$TCGCC \
# 	    LD=$TCLD
# echo "-----> Make"
# make
export CROSS_COMPILE=${TCPREFIX}-

make CROSS_COMPILE=$CROSS_COMPILE distclean
make CROSS_COMPILE=$CROSS_COMPILE defconfig
cp   $CONFIGS/busybox_defconfig .config
make CROSS_COMPILE=$CROSS_COMPILE oldconfig
make CROSS_COMPILE=$CROSS_COMPILE dep
make CROSS_COMPILE=$CROSS_COMPILE

echo "-----> Make install"
fakeroot -i $FAKEROOTCONF -s $FAKEROOTCONF make install


