cd

source <(curl -s https://raw.githubusercontent.com/alansartorio/Artix-Config/main/autologin.sh)
source <(curl -s https://raw.githubusercontent.com/alansartorio/Artix-Config/main/add-arch-mirrors.sh)

# Install paru
sudo pacman -S --noconfirm --needed base-devel
git clone https://aur.archlinux.org/paru-bin.git paru
( cd paru && makepkg -si )
rm -rf paru

sudo pacman -S --noconfirm git
git clone https://github.com/alansartorio/dotfiles.git .dotfiles
cd .dotfiles
script/install
script/bootstrap