#Build 715

#!/bin/bash
DTS=arch/arm/boot/dts

RDIR=$(pwd)

export ARCH=arm

export CROSS_COMPILE=../toolchains/arm-eabi-4.8/bin/arm-eabi-

make clean

make mrproper

rm -rf dt.img

make gts28lte_03_defconfig

make exynos5433-gts28_eur_open_03.dtb

make exynos5433-gts28_eur_open_04.dtb

make exynos5433-gts28_eur_open_05.dtb

make exynos5433-gts28_eur_open_06.dtb

make exynos5433-gts28_eur_open_09.dtb

make ARCH=arm -j6

echo -n "Build dt.img......................................."

./tools/dtbtool -o ./dt.img -v -s 2048 -p ./scripts/dtc/ $DTS/
# get rid of the temps in dts directory
rm -rf $DTS/.*.tmp
rm -rf $DTS/.*.cmd
rm -rf $DTS/*.dtb

# Calculate DTS size for all images and display on terminal output
du -k "./dt.img" | cut -f1 >sizT
sizT=$(head -n 1 sizT)
echo "Combined DT Size = $sizT Kb"
rm -rf sizT

echo "Cleanup AIK"

cd /home/matt/android/N4N/Ramdisks/AIK-Linux

sudo ./cleanup.sh

echo "Copy zImage"

sudo cp -a /home/matt/android/N4N/arch/arm/boot/zImage /home/matt/android/N4N/Ramdisks/715/split_img/boot.img-zImage

echo "Copy dt.img"

sudo cp -a /home/matt/android/N4N/dt.img /home/matt/android/N4N/Ramdisks/715/split_img/boot.img-dtb

echo "Copy Ramdisk"

sudo cp -a /home/matt/android/N4N/Ramdisks/715/ramdisk/. /home/matt/android/N4N/Ramdisks/AIK-Linux/ramdisk

echo "Copy split_img"

sudo cp -a /home/matt/android/N4N/Ramdisks/715/split_img/. /home/matt/android/N4N/Ramdisks/AIK-Linux/split_img

echo "pack boot.img"

sudo ./repackimg.sh

echo "Copy boot.img"

cp /home/matt/android/N4N/Ramdisks/AIK-Linux/image-new.img /home/matt/android/N4N/Ramdisks/715boot.img

echo -n "SEANDROIDENFORCE" >> /home/matt/android/N4N/Ramdisks/715boot.img

echo "Cleanup AIK"

sudo ./cleanup.sh

rm /home/matt/android/N4N/Ramdisks/715/split_img/boot.img-zImage

echo "boot.img at /home/matt/android/N4N/Ramdisks/715boot.img"

echo "Finished"
