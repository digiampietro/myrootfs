#!/bin/bash

export MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $MYDIR/setenv.sh

# --------------------------------------------------------------------------------------------
# Code Sourcery toolchin installation
# --------------------------------------------------------------------------------------------

TCBIN=arm-2011.09-70-arm-none-linux-gnueabi.bin

echo "-----> Installing the Old Code Sourcery toolchain for kernel compilation"
echo "-----> Toolchain binary: arm-2011.09-70-arm-none-linux-gnueabi.bin"

if [ ! -e $DOWNLOADS/$TCBIN ]
then
    echo "---> ERROR $DOWNLOADS/$TCBIN not found!"
    exit 1
fi

chmod a+x $DOWNLOADS/$TCBIN

OPTOWNER="$(stat --format '%U' "/opt")"
if [ "$OPTOWNER" = "$USER" ]
then
    echo "-----> /opt already owned by current user $USER"
else
    echo "-----> changind /opt ownershit to current user $USER with wuso"
    sudo chown $USER /opt
fi


if [ -d /opt/cs ]
then
    echo "---> WARNING Toolchain CodeSourcery seems already installed"
    echo "-----> To force a reinstallation remove /opt/cs directory"
    echo "-----> Skipping Code Sourcery toolchain installation"
else
    echo "-----> Start installation, don't type anything, it is fully automated"
    $DOWNLOADS/$TCBIN -i console < $MYDIR/codesourcery-reply.txt
    cd /opt
    ln -s cs codesourcery
fi

# --------------------------------------------------------------------------------------------
# Crosstool toolchin installation
# --------------------------------------------------------------------------------------------
    
if [ -d /opt/crosstool ]
    then
	echo "---> WARNING Crosstool toolchain seems already installed"
	echo "-----> to force re-installatione remove /opt/crosstool"
	echo "-----> skipping Crosstool tollchain installation"
    else
	CTDIR=`/bin/ls -d $BUILD/crosstool-*`
	if [ ! -d $CTDIR ]
	then
	    echo "---> ERROR crosstool building dir doesn't exist"
	    exit 1
	fi
	cd $CTDIR
	echo "-----> Installing the cross toolchain in $CTDIR"
	cat demo-arm-xscale.sh | \
	    perl -p -n -e 's/^eval /\#eval /;s/^\#(.*gcc-3.4.5-glibc-2.3.5.dat)/$1/' > mybuild.sh
	chmod a+x mybuild.sh
	./mybuild.sh
fi
