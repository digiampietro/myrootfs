#!/bin/bash

# clean the rootfs target file system and images directory and
# relaunch all the build commands

export MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $MYDIR/setenv.sh

for i in make-clean.sh \
         install-templates.sh \
	 install-libs.sh  \
	 build-busybox.sh \
	 build-dropbear.sh  \
	 make-images.sh
do
    echo
    echo "-----> EXECUTING $i"
    $MYDIR/$i
done


