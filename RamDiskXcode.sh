RAMDISK=”ramdisk”
SIZE=4096         #size in MB for ramdisk.
diskutil erasevolume HFS+ $RAMDISK \
`hdiutil attach -nomount ram://$[SIZE*1024]`
