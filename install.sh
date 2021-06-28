%INCLUDE common.sh

clear
info "Create your partitions (ESP and ROOT, (SWAP optional))"
info "You can use the cfdisk utility"
bash
read -p "ESP: " esp
read -p "ROOT: " rootPart

option "Do you want to use SWAP? " 'read -p "Input the SWAP partition: " swapPart' "swapPart=''"

read -p "New username: " username
read -p "Hostname: " hostname
read -s -p "Password: " password
echo

if [ -z "$username" ] || [ -z "$hostname" ] || [ -z "$password" ] || [ -z "$esp" ] || [ -z "$rootPart" ]
then
    info "At least one of the previous fields is empty, restart installation!"
    exit 1
fi


option "Do you want to format ESP? " 'sudo mkfs.fat -F 32 -n "BOOT" "$esp"' ""

sudo mkfs.ext4 -L "ROOT" "$rootPart"
if [ -n "$swapPart" ]
then
    sudo mkswap "$swapPart"
    sudo swapon "$swapPart"
fi

info "About to start installation!"

sudo mount /dev/disk/by-label/ROOT /mnt
sudo mkdir /mnt/boot
sudo mkdir /mnt/home
sudo mkdir /mnt/tmp

sudo mount /dev/disk/by-label/BOOT /mnt/boot

basestrap /mnt base base-devel openrc elogind-openrc
basestrap /mnt linux linux-firmware

fstabgen -U /mnt | sudo tee /mnt/etc/fstab

info "About to run script inside chroot!"

chrootRun() {
    dir="$1"
    script="$2"
    shift 2
    cat "$script" | sudo tee "$dir/test.sh"
    sudo chmod +x "$dir/test.sh"
    artix-chroot "$dir" "/test.sh" "$@"
    sudo rm "$dir/test.sh"
}

chrootScript=%READCONTENT chrootScript.sh
chrootRun /mnt <(echo "$chrootScript") "$username" "$hostname" "$password"

sudo umount -R /mnt

# sudo reboot