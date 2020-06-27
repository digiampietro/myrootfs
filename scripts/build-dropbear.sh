#!/bin/bash

export MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $MYDIR/setenv.sh

if cd $BUILD/dropbear*
then
    echo "-----> changed dir to `pwd`"
else
    echo "-----> ERROR IN changing dir to $BUILD/dropbear* "
    echo "-----> ERROR exiting"
    exit 1
fi

echo "-----> Configuring"
./configure --host=$TCPREFIX \
	    --prefix=$ROOTFS \
	    --disable-zlib \
	    CC=$TCGCC \
	    LD=$TCLD
echo "-----> Make"
make
echo "-----> Make install"
fakeroot -i $FAKEROOTCONF -s $FAKEROOTCONF make install


