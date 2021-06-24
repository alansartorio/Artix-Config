cd

source <(curl -s https://raw.githubusercontent.com/alansartorio/Artix-Config/main/autologin.sh)
source <(curl -s https://raw.githubusercontent.com/alansartorio/Artix-Config/main/add-arch-mirrors.sh)

# Install paru
sudo pacman -S --noconfirm --needed base-devel
sudo pacman -S --noconfirm git
git clone https://aur.archlinux.org/paru-bin.git paru
( cd paru && makepkg -si )
rm -rf paru


sudo pacman -S --noconfirm openssh xorg xorg-xinit wget zsh openrc-zsh-completions bspwm sxhkd feh rofi alacritty # kdeconnect connman-gtk
paru -S --noconfirm polybar siji-git xorg-fonts-misc neovim
sudo pacman -S neofetch # firefox chromium blender gimp

sudo pacman -S --noconfirm git
git clone https://github.com/alansartorio/dotfiles.git .dotfiles
cd .dotfiles
script/install
script/bootstrap