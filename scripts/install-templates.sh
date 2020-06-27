#!/bin/bash

export MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $MYDIR/setenv.sh

if [ ! -e $ROOTFS ]
then
    mkdir $ROOTFS
fi

echo "-----> Installing templates to rootfs"
if [ -e $FAKEROOTCONF ]
then
    fakeroot -i $FAKEROOTCONF -s $FAKEROOTCONF rsync -rav $TEMPLATES/ $ROOTFS/
else
    fakeroot                  -s $FAKEROOTCONF rsync -rav $TEMPLATES/ $ROOTFS/
fi

if [ ! -d $ROOTFS/dev ]
then
    echo "-----> creating $ROOTFS/dev"
    mkdir $ROOTFS/dev
fi

#so we are now required to re-make suitable devnodes                                                                                                
echo "-----> Creating device nodes: "
cd $ROOTFS/dev

fakeroot -i $FAKEROOTCONF -s $FAKEROOTCONF bash -c "mknod null c 1 3"
fakeroot -i $FAKEROOTCONF -s $FAKEROOTCONF bash -c "mknod mem c 1 1"
fakeroot -i $FAKEROOTCONF -s $FAKEROOTCONF bash -c "mknod console c 5 1"
fakeroot -i $FAKEROOTCONF -s $FAKEROOTCONF bash -c "mknod ttyS0 c 4 64"
fakeroot -i $FAKEROOTCONF -s $FAKEROOTCONF bash -c "mknod ttyS1 c 4 65"
fakeroot -i $FAKEROOTCONF -s $FAKEROOTCONF bash -c "mknod ttyS2 c 4 66"
fakeroot -i $FAKEROOTCONF -s $FAKEROOTCONF bash -c "mknod fb0 c 29 0"

# devices required for telnet                                                                                                                       
fakeroot -i $FAKEROOTCONF -s $FAKEROOTCONF bash -c "mknod ttyp0 c 3 0"
fakeroot -i $FAKEROOTCONF -s $FAKEROOTCONF bash -c "mknod ttyp1 c 3 1"
fakeroot -i $FAKEROOTCONF -s $FAKEROOTCONF bash -c "mknod ttyp2 c 3 2"
fakeroot -i $FAKEROOTCONF -s $FAKEROOTCONF bash -c "mknod ttyp3 c 3 3"
fakeroot -i $FAKEROOTCONF -s $FAKEROOTCONF bash -c "mknod ptyp0 c 2 0"
fakeroot -i $FAKEROOTCONF -s $FAKEROOTCONF bash -c "mknod ptyp1 c 2 1"
fakeroot -i $FAKEROOTCONF -s $FAKEROOTCONF bash -c "mknod ptyp2 c 2 2"
fakeroot -i $FAKEROOTCONF -s $FAKEROOTCONF bash -c "mknod ptyp3 c 2 3"

#device required for usb keyboard input to be picked up by Qt                                                                                       
fakeroot -i $FAKEROOTCONF -s $FAKEROOTCONF bash -c "mknod tty0 c 4 0"
