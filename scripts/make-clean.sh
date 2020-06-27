#!/bin/bash

# by default clean the rootfs target file system and images directory

export MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $MYDIR/setenv.sh

echo "-----> cleaning images"
rm -fv  $IMAGES/*

echo "-----> cleaning root file system"
rm -rfv $ROOTFS/*

echo "-----> removing $FAKEROOTCONF"
rm -v $FAKEROOTCONF
