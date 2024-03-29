#!/bin/bash
%INCLUDE common.sh

username=$1
hostname=$2
password=$3
esp=$4
rootPart=$5
swapPart=$6

sudo ln -sf /usr/share/zoneinfo/America/Argentina/Buenos_Aires /etc/localtime
hwclock --systohc

sudo sed -i '/^#\s*en_US.UTF-8 UTF-8/s/^#//' /etc/locale.gen
locale-gen

pacman -S --noconfirm --needed zsh efibootmgr

getPARTUUID() {
    part=$1
    sudo blkid | grep "$part" | sed -r 's/.*PARTUUID="([[:xdigit:]-]+)".*/\1/'
}

espnodev=${esp##/dev/}
if [[ "$espnodev" == sd* ]]; then
    read -r partName partNumber << EOF
$(sed -r 's|(sd[a-z])([[:digit:]]+)|\1\t\2|' <<< "$espnodev")
EOF
elif [[ "$espnodev" == nvme* ]]; then
    read -r partName partNumber << EOF
$(sed -r 's|(nvme[0-9]n[0-9])p([[:digit:]]+)|\1\t\2|' <<< "$espnodev")
EOF
fi

argument="root=PARTUUID=$(getPARTUUID $rootPart) "
if [ -n "$swapPart" ]
then
    argument="${argument}resume=PARTUUID=$(getPARTUUID $swapPart) "
fi
argument="${argument}rw initrd=\initramfs-linux.img"

efibootmgr \
    --disk "$partName" \
    --part "$partNumber" \
    --create \
    --label "Alan Artix" \
    --loader /vmlinuz-linux \
    --unicode "$argument" \
    --verbose

# pacman -S --noconfirm --needed grub os-prober
# grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
# grub-mkconfig -o /boot/grub/grub.cfg


echo "root:$password" | chpasswd

useradd -s /bin/zsh -m "$username"
echo "$username:$password" | chpasswd

echo $hostname | sudo tee /etc/hostname

sudo tee -a /etc/hosts <<HOSTS
127.0.0.1       localhost
::1             localhost
127.0.1.1       $hostname.localdomain $hostname
HOSTS

echo "hostname=\"$hostname\"" | sudo tee /etc/conf.d/hostname

#pacman -S --noconfirm dhcpcd
#pacman -S --noconfirm connman-openrc
#rc-update add connmand
pacman -S --noconfirm --needed networkmanager

sudo tee "/etc/sudoers.d/tmpPerm" > /dev/null <<EOF
$username ALL=(ALL) NOPASSWD: ALL
EOF
sudo chmod 0440 "/etc/sudoers.d/tmpPerm"

userScript=%READCONTENT chrootUser.sh
sudo -u $username sh -c "$userScript"

rm "/etc/sudoers.d/tmpPerm"

# Add wanted permissions for installation
sudo tee "/etc/sudoers.d/user" > /dev/null <<EOF
$username ALL=(ALL) ALL
$username ALL=NOPASSWD: /usr/bin/shutdown, /usr/bin/poweroff, /usr/bin/reboot, /usr/bin/halt
EOF
sudo chmod 0440 "/etc/sudoers.d/user"

info "Install the graphics driver!"
su $username
