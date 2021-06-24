sudo pacman -S --noconfirm artix-archlinux-support

sudo tee -a /etc/pacman.conf <<"EOF"
# ARCHLINUX
[extra]
Include = /etc/pacman.d/mirrorlist-arch

[community]
Include = /etc/pacman.d/mirrorlist-arch

#[multilib]
#Include = /etc/pacman.d/mirrorlist-arch
EOF

sudo pacman-key --populate archlinux