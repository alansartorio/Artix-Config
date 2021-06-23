sudo cfdisk
read -p "ESP: " esp
read -p "ROOT: " rootPart

read -p "Do you want to format ESP? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    sudo mkfs.fat -F 32 -n "BOOT" "$esp"
fi

sudo mkfs.ext4 -L "ROOT" "$rootPart"

sudo mount /dev/disk/by-label/ROOT /mnt
sudo mkdir /mnt/boot
sudo mkdir /mnt/home

sudo mount /dev/disk/by-label/BOOT /mnt/boot


basestrap /mnt base base-devel openrc elogind-openrc
basestrap /mnt linux linux-firmware

fstabgen -U /mnt | sudo tee -a /mnt/etc/fstab

