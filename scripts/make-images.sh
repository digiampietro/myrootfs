#!/bin/bash

export MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $MYDIR/setenv.sh

if [ ! -e $IMAGES ]
then
    mkdir $IMAGES
fi

echo "-----> creating root file system image $IMAGES/root.ext2"
fakeroot -i $FAKEROOTCONF bash -c "genext2fs -d $ROOTFS -b 102400 -q $IMAGES/root.ext2"


    
