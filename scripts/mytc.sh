#!/bin/bash

# to execute commands in the toolchain environment
# if the command is gcc, readelf etc. and it does exist a toolchain command
# prefixed with the toolchain prefix that command is executed instead

export MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $MYDIR/setenv.sh

export CROSS_COMPILE=$TCPREFIX

if which ${TCPREFIX}-gcc > /dev/null
then
    echo "-----> gcc compiler: ${TCPREFIX}-gcc"
else
    echo "-----> ERROR gcc compiler ${TCPREFIX}-gcc not found"
    exit 1
fi

echo -n "-----> executing: "
if which ${TCPREFIX}-$1
then
    ${TCPREFIX}-$*
else
    which $1
    $*
fi


