sudo pacman-key --init
sudo pacman-key --populate artix
sudo pacman -Sy

# Add arch mirrors

if ! sudo cat /etc/pacman.conf | grep -Fq "ARCHLINUX"
then
	sudo pacman -S --noconfirm artix-archlinux-support
	sudo pacman-key --populate archlinux
	sudo tee -a /etc/pacman.conf <<"EOF"
# ARCHLINUX
[extra]
Include = /etc/pacman.d/mirrorlist-arch

[community]
Include = /etc/pacman.d/mirrorlist-arch

#[multilib]
#Include = /etc/pacman.d/mirrorlist-arch

ParallelDownloads = 6
EOF
	sudo pacman -Sy
fi