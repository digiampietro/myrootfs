#!/bin/bash

export MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $MYDIR/setenv.sh

function qemurun {
    QRUN=(\
    qemu-system-arm -kernel  $KERNEL \
		    -append  'console=ttyS0 ignore_loglevel root=/dev/mmcblk0 video=pxafb:mode:320x240-16,passive mem=64M' \
		    -machine mainstone \
		    -m       64M \
		    -nodefaults \
		    -serial  mon:stdio \
		    -drive   file=$FLASH0,format=raw,if=pflash \
		    -drive   file=$FLASH1,format=raw,if=pflash \
		    -device  usb-net,netdev=n1 \
		    -netdev  user,id=n1 \
		    -usb     \
		    -device  usb-tablet \
		    -device  pxa2xx-i2c-slave \
		    -vnc     :0 \
		    -drive   file=$FS,format=raw,if=sd)

    echo "Running: --------------------------------------------------------------------------------------------"
    echo "${QRUN[@]}" | sed 's/ -/\n               -/g'
    echo "-----------------------------------------------------------------------------------------------------"
    echo
    "${QRUN[@]}"
}

#		    -net     nic \
#		    -net     user \

# --- flash kernel images, unused
FLASH0=$BUILD/mainstone-flash0.img
FLASH1=$BUILD/mainstone-flash1.img

for f in $FLASH0 $FLASH1
do if [ ! -e "$f" ]
   then
       echo "-----> Creating flash image $f"
       dd if=/dev/zero of=$f bs=1M count=64
   fi
done

# --- available kernels
# KERNAME[0]="zImage cross-compile with Cross-ng"
# KERFILE[0]="/home/valerio/temp/b/linux/linux-4.7.5/linux/linux-4.7.5/linux/build/arch/arm/boot/zImage"

# KERNAME[1]="MUG_zImage unmodified from Firmware"
# KERFILE[1]="/home/valerio/temp/pr/MUG_zImage"

# KERNAME[2]="repack/MUG_zImage firmware version, with modified initramfs"
# KERFILE[2]="/home/valerio/temp/pr/kernels/repack/zImage"

# KERNAME[3]="vmlinux, Buildroot kernel"
# KERFILE[3]="/home/valerio/emu/hht/old-buildroot-2014.02/output/images/vmlinux"

# KERNAME[4]="zImage, kernel 2.6.21 by CodeSourcery"
# KERFILE[4]="/home/valerio/temp/c/linux/build/arch/arm/boot/zImage"

# KERNAME[5]="zImage, kernel da Buildroot 2011.05"
# KERFILE[5]="/home/valerio/emu/hht/old-buildroot-2011.05/output/images/zImage"

# KERNAME[6]="vmlinux, kernel da Buildroot 2014.02 piu nuovo"
# KERFILE[6]="/home/valerio/emu/hht/old-buildroot-2014.02/output/images/vmlinux"

# KERNAME[7]="zImage, kernel 2.6.10 da crosstool"
# KERFILE[7]="/home/valerio/temp/d/linux/build/arch/arm/boot/zImage"

KERNAME[8]="zImage, kernel 2.6.21 compiled with CodeSourcery"
KERFILE[8]=$BUILD/linux/build/arch/arm/boot/zImage

# --- available root file systems
# FSNAME[0]="rootfs.ext2,  Device modified root fs"
# FSFILE[0]="/home/valerio/temp/pr/kernels/rootfs.ext2"

# FSNAME[1]="newrootfs.partitioned, Device modified root fs in a partition"
# FSFILE[1]="/home/valerio/temp/pr/kernels/newrootfs.partioned"

# FSNAME[2]="rootfs.ext2, Build by Buildroot 2014.02"
# FSFILE[2]="/home/valerio/emu/hht/old-buildroot-2014.02/output/images/rootfs.ext2"

# FSNAME[3]="rootfs.ext2, da Buildroot 2011.05"
# FSFILE[3]="/home/valerio/emu/hht/old-buildroot-2011.05/output/images/rootfs.ext2"

# FSNAME[4]="rootfs.ext2, da Buildroot 2013.11"
# FSFILE[4]="/home/valerio/emu/hht/buildroot-2013.11/output/images/rootfs.ext2"

# FSNAME[5]="rootfs.ext2, da Buildroot 2014.02 piu nuovo"
# FSFILE[5]=/home/valerio/emu/hht/old-buildroot-2014.02/output/images/rootfs.ext2

# FSNAME[6]="root.ext2 ptx root file system"
# FSFILE[6]=/home/valerio/temp/ptx/images/root.ext2

# FSNAME[7]="root-1G.ext2 ptx extended root file system"
# FSFILE[7]=/home/valerio/temp/ptx/images/root-1G.ext2

# FSNAME[8]="root.ext2 minimal custom image"
# FSFILE[8]=/home/valerio/temp/myrootfs/build/images/root.ext2

FSNAME[9]="root.ext2 minimal root fs compiled with crosstool"
FSFILE[9]=$IMAGES/root.ext2

# choose kernel
INVALID=true
while [ "$INVALID" = "true" ] ; do
    INVALID=false;
    echo "Choose you kernel"
    echo "======================================================================="
    
    for i in ${!KERNAME[@]}
    do
	if [ -e ${KRFILE[$i]} ]
	then
	    UNAV=""
	else
	    UNAV="NOT FOUND "
	fi
	echo "$i: $UNAV ${KERNAME[$i]}"
	max=$i
    done

    echo -n "--> "
    read n
    echo "your choice: $n"
    if [ $n -ge 0   -a  $n -le $max -a -e "${KERFILE[$n]}" ]
    then
	KERNEL=${KERFILE[$n]}
	KERNDESC=${KERNAME[$n]}
    else
        INVALID=true
        echo "ERROR: Invalid choice"
    fi
done
echo
echo "Youu choice: $n:"
ls -l $KERNEL
echo "    $KERNEL"
echo "    $KERNDESC"


echo
echo


# choose file system
INVALID=true
while [ "$INVALID" = "true" ] ; do
    INVALID=false;
    echo "Choose your Root File System"
    echo "======================================================================="
    
    for i in ${!FSNAME[@]}
    do
	if [ -e ${FSFILE[$i]} ]
	then
	    UNAV=""
	else
	    UNAV="NOT FOUND "
	fi
	echo "$i: $UNAV ${FSNAME[$i]}"
	max=$i
    done

    echo -n "--> "
    read n
    echo "your choice: $n"
    if [ $n -ge 0 -a $n -le $max -a -e ${FSFILE[$n]} ]
    then
	FS=${FSFILE[$n]}
	FSDESC=${FSNAME[$n]}
    else
        INVALID=true
        echo "ERROR: Invalid choice"
    fi
done
echo
echo "Youu choice: $n:"
ls -l $FS
echo "    $FS"
echo "    $FSDESC"

qemurun


# qemu-system-arm -M mini2440 \
# 		-drive file=./mini2440/mini2440_snapshots.img,snapshot=on \
# 		-serial stdio \
# 		-kernel /home/iot/qemu-mini2440/qemu/mini2440/kernel-uImage \
# 		-mtdblock ./mini2440/mini2440_nand.bin \
# 		-usb \
# 		-usbdevice mouse \
# 		-usbdevice keyboard \
# 		-show-cursor \
# 		-net nic,vlan=0 \
# 		-net tap,vlan=0,ifname=tap0,script=no





#		-net    nic,model=smc91x \
#		-net    user,hostfwd=tcp::2222-:22,hostfwd=tcp::9000-:9000 \

#		-vnc    :0 \
#                -sd     $FS

#		-initrd initramfs.cpio
#		-serial mon:stdio \

# qemu-system-arm -m 1024 \
# 		-cpu cortex-a57 \
# 		-M virt \
# 		-nographic \
# 		-drive file=flash0.img,format=raw,if=pflash \
# 		-drive file=flash1.img,format=raw,if=pflash \
# 		-drive if=none,file=xenial-server-cloudimg-arm64-uefi1.img,id=hd0 \
# 		-device virtio-blk-device,drive=hd0 \
# 		-device virtio-net-device,netdev=net0,mac=$randmac \
# 		-netdev type=tap,id=net0
