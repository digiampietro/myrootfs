#!/bin/bash

# by default clean the rootfs target file system and images directory

export MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $MYDIR/setenv.sh

if [ ! -e $DOWNLOADS ]
then
    mkdir $DOWNLOADS
fi


echo "-----> Downloading packages"
for i in `cat $MYDIR/packages.txt|grep -v '^#'`
do echo
   echo "-----> URL:     $i"
   F=`basename $i`
   echo "-----> Package: $F"
   if [ -e $DOWNLOADS/$F ]
   then
       echo "-----> Package  $F already downloaded"
   else
       cd $DOWNLOADS
       echo "-----> Package  $F downloading"
       wget --no-check-certificate $i
       FTYPE=`file -b $F|awk '{print $1}'`
       cd $BUILD
       if [ "$FTYPE" = "gzip" ]
       then
	   echo "-----> Package $F $FTYPE uncompressing/untarring"
	   tar -zxvf $DOWNLOADS/$F
       elif [ "$FTYPE" = "bzip2" ]
       then
	    echo "-----> Package $F $FTYPE uncompressing/untarring"
	    tar -xvf $DOWNLOADS/$F
       elif [ "$FTYPE" = "POSIX" -o "$FTYPE" = "Bourne" ]
       then
	    echo "-----> Package $F is not a compressed package, skipping uncompressing"
       else
	   echo "-----> ERROR in Package $F unknown compression type: $FTYPE"
	   exit 1
       fi
   fi
done
