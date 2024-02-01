#!/bin/bash

# copy data from the mounted media to /root
cp -r /.modloop /root
cp -r /media/sda /root

# unmount the media
umount /.modloop /media/sda

# move the data to directories that were the mountpoints
rm -rf /lib/modules
mv /root/.modloop/modules /lib
mv /root/sda /media
