source <(curl -s https://raw.githubusercontent.com/alansartorio/Artix-Config/main/common.sh)
cd

# Autologin to user on boot
sudo sed -i "/^description=.*/a agetty_options=\"--autologin $USER --noclear\"" /etc/init.d/agetty.tty1

source <(curl -s https://raw.githubusercontent.com/alansartorio/Artix-Config/main/add-arch-mirrors.sh)

# Install paru
sudo pacman -S --noconfirm --needed base-devel
sudo pacman -S --noconfirm git
git clone https://aur.archlinux.org/paru-bin.git paru
( cd paru && makepkg -si --noconfirm )
rm -rf paru


sudo pacman -S --noconfirm ntfs-3g openssh xorg xorg-xinit wget zsh openrc-zsh-completions bspwm sxhkd feh rofi alacritty # kdeconnect connman-gtk
paru -S --noconfirm polybar siji-git xorg-fonts-misc neovim
sudo pacman -S --noconfirm neofetch # firefox chromium blender gimp

sudo pacman -S --noconfirm git
git clone https://github.com/alansartorio/dotfiles.git .dotfiles
cd .dotfiles
script/install
script/bootstrap
