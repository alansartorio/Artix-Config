
cd "$(dirname "$0")"

# source <(curl -s https://raw.githubusercontent.com/alansartorio/Artix-Config/main/common.sh)
source common.sh

clear
info "Create your partitions (ESP and ROOT)"
info "You can use the cfdisk utility"
bash
read -p "ESP: " esp
read -p "ROOT: " rootPart

read -p "New username: " username
read -p "Hostname: " hostname
read -s -p "Password: " password
echo

if [ -z "$username" ] || [ -z "$hostname" ] || [ -z "$password" ] || [ -z "$esp" ] || [ -z "$rootPart" ]
then
    info "At least one of the previous fields is empty, restart installation!"
    exit 1
fi

read -p "Do you want to format ESP? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    sudo mkfs.fat -F 32 -n "BOOT" "$esp"
fi

sudo mkfs.ext4 -L "ROOT" "$rootPart"

pauseInfo "About to start installation!"

sudo mount /dev/disk/by-label/ROOT /mnt
sudo mkdir /mnt/boot
sudo mkdir /mnt/home
sudo mkdir /mnt/tmp

sudo mount /dev/disk/by-label/BOOT /mnt/boot


basestrap /mnt base base-devel openrc elogind-openrc
basestrap /mnt linux linux-firmware

fstabgen -U /mnt | sudo tee -a /mnt/etc/fstab

pauseInfo "About to run script inside chroot!"
# curl -s https://raw.githubusercontent.com/alansartorio/Artix-Config/main/chrootScript.sh | sudo tee /mnt/root/chrootScript.sh > /dev/null
cat chrootScript.sh | sudo tee /mnt/root/chrootScript.sh > /dev/null

artix-chroot /mnt bash /root/chrootScript.sh "$username" "$hostname" "$password"
sudo rm /mnt/root/chrootScript.sh
sudo umount -R /mnt

# sudo reboot