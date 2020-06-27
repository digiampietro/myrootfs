#!/bin/bash

export MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $MYDIR/setenv.sh

echo "-----> Installing library from toolchain to rootfs"
if [ ! -d $ROOTFS/lib ]
then
    echo "-----> creating $ROOTFS/lib"
    mkdir $ROOTFS/lib
fi

for i in `ls -l $TCLIB | grep ^l | awk '{print $9,$11}'`
do
    echo "-----> installing $i"
    rsync -av $TCLIB/$i $ROOTFS/lib/
done
    
