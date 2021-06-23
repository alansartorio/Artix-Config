sudo cfdisk
read -p "New username: " username
read -p "Hostname: " hostname
read -s -p "Password: " password
echo

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
sudo mkdir /mnt/tmp

sudo mount /dev/disk/by-label/BOOT /mnt/boot


basestrap /mnt base base-devel openrc elogind-openrc
basestrap /mnt linux linux-firmware

fstabgen -U /mnt | sudo tee -a /mnt/etc/fstab


sudo tee /mnt/root/chrootScript.sh > /dev/null <<"EOF"
username=$1
hostname=$2
password=$3

sudo ln -sf /usr/share/zoneinfo/America/Argentina/Buenos_Aires /etc/localtime
hwclock --systohc

sudo sed -i '/^#\s*en_US.UTF-8 UTF-8/s/^#//' /etc/locale.gen
locale-gen

pacman -S --noconfirm grub os-prober efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
grub-mkconfig -o /boot/grub/grub.cfg
echo "root:$password" | chpasswd

useradd -m "$username"
echo "$username:$password" | chpasswd

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

cat <<"RICING" | sudo -u $username tee /tmp/userScript.sh > /dev/null
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
echo "Install the graphics driver!"
su $username

EOF

artix-chroot /mnt bash /root/chrootScript.sh "$username" "$hostname" "$password"
sudo rm /mnt/root/chrootScript.sh
sudo umount -R /mnt

# sudo reboot