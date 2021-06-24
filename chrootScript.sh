source <(curl -s https://raw.githubusercontent.com/alansartorio/Artix-Config/main/common.sh)

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

useradd -s /bin/zsh -m "$username"
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

sudo tee "/etc/sudoers.d/user" > /dev/null <<EOF
$username ALL=(ALL:ALL) ALL
$username ALL=NOPASSWD: /usr/bin/shutdown, /usr/bin/reboot, /usr/bin/halt
EOF
sudo chmod 0440 "/etc/sudoers.d/user"

pauseInfo "About to run user script!"
curl -s https://raw.githubusercontent.com/alansartorio/Artix-Config/main/chrootUser.sh | sudo -u $username tee /tmp/userScript.sh > /dev/null

sudo -u $username sh /tmp/userScript.sh
echo "Install the graphics driver!"
su $username