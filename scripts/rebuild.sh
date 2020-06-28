#!/bin/bash

# clean the rootfs target file system and images directory and
# relaunch all the build commands

export MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $MYDIR/setenv.sh

for i in make-clean.sh \
	 pkgs-download.sh \
	 install-toolchains.sh \
	 build-kernel.sh \
         install-templates.sh \
	 install-libs.sh  \
	 build-busybox.sh \
	 build-dropbear.sh  \
	 make-images.sh
do
    echo
    echo "-----> EXECUTING $i"
    if $MYDIR/$i
    then
	echo "------> EXECUTED $i"
    else
	echo "---> ERROR executing $i exiting"
	exit 1
    fi
done


