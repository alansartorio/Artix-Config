sudo pacman -S --noconfirm artix-archlinux-support

cat archRepos.txt | sudo tee -a /etc/pacman.conf

sudo pacman-key --populate archlinux