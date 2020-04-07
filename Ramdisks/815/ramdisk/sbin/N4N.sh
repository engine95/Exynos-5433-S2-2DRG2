#!/system/bin/sh

BB=/sbin/busybox;

mount -o remount,rw /
mount -o remount,rw /system /system


#
# Stop Google Service and restart it on boot (dorimanx)
# This removes high CPU load and ram leak!
#
if [ "$($BB pidof com.google.android.gms | wc -l)" -eq "1" ]; then
	$BB kill $($BB pidof com.google.android.gms);
fi;
if [ "$($BB pidof com.google.android.gms.unstable | wc -l)" -eq "1" ]; then
	$BB kill $($BB pidof com.google.android.gms.unstable);
fi;
if [ "$($BB pidof com.google.android.gms.persistent | wc -l)" -eq "1" ]; then
	$BB kill $($BB pidof com.google.android.gms.persistent);
fi;
if [ "$($BB pidof com.google.android.gms.wearable | wc -l)" -eq "1" ]; then
	$BB kill $($BB pidof com.google.android.gms.wearable);
fi;


#
# We need faster I/O so do not try to force moving to other CPU cores (dorimanx)
#
for i in /sys/block/*/queue; do
        echo "2" > $i/rq_affinity
done


#
# Synapse
#
if [ "$($BB mount | grep rootfs | cut -c 26-27 | grep -c ro)" -eq "1" ]; then
	$BB mount -o remount,rw /;
fi;
if [ "$($BB mount | grep system | grep -c ro)" -eq "1" ]; then
	$BB mount -o remount,rw /system;
fi;

$BB chmod -R 755 /res/*
ln -s /res/synapse/uci /sbin/uci
/sbin/uci


#
# NTFS r/o from /mnt/ntfs
#
mkdir -p /mnt/ntfs
chmod 777 /mnt/ntfs
mount -o mode=0777,gid=1000 -t tmpfs tmpfs /mnt/ntfs


#
# Kernel custom test
#
if [ -e /data/.N4N_test.log ]; then
rm /data/.N4N_test.log
fi

echo  Kernel script is working !!! >> /data/.N4N_test.log
echo "excecuted on $(date +"%m-%d-%Y %r" )" >> /data/.N4N_test.log


if [ "$($BB mount | grep rootfs | cut -c 26-27 | grep -c ro)" -eq "1" ]; then
	$BB mount -o remount,rw /;
fi;
if [ "$($BB mount | grep system | grep -c ro)" -eq "1" ]; then
	$BB mount -o remount,rw /system;
fi;

$BB mount -t rootfs -o remount,ro rootfs
$BB mount -o remount,ro /system /system
$BB mount -o remount,rw /data

