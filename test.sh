
sudo tee /mnt/root/chrootScript.sh > /dev/null <<"EOF"
sudo ln -sf /usr/share/zoneinfo/America/Argentina/Buenos_Aires /etc/localtime
hwclock --systohc

sudo sed -i '/^#\s*en_US.UTF-8 UTF-8/s/^#//' /etc/locale.gen
locale-gen

pacman -S --noconfirm grub os-prober efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
grub-mkconfig -o /boot/grub/grub.cfg

echo "Root password:"
passwd

read -p "New username: " username
useradd -m "$username"
echo "User password:"
passwd "$username"

read -p "Hostname: " hostname
echo $hostname | sudo tee /etc/hostname

sudo tee -a /etc/hosts <<HOSTS
127.0.0.1       localhost
::1             localhost
127.0.1.1       $hostname.localdomain $hostname
HOSTS

echo "hostname=\"$hostname\"" | sudo tee /etc/conf.d/hostname

pacman -S --noconfirm dhcpcd
pacman -S --noconfirm connman-openrc
rc-update add connmand

echo "$username ALL=(ALL:ALL) ALL" | sudo EDITOR='tee -a' visudo

cat <<"RICING" | sudo -u alan tee /tmp/userScript.sh > /dev/null
cd
sudo pacman -S --noconfirm git
git clone https://github.com/alansartorio/Artix-Config.git
cd Artix-Config

./autologin.sh
./add-arch-mirrors.sh

sudo pacman -S --noconfirm wget
make install
RICING

sudo -u $username sh /tmp/userScript.sh

EOF

artix-chroot /mnt bash /root/chrootScript.sh
sudo rm /mnt/root/chrootScript.sh
sudo umount -R /mnt