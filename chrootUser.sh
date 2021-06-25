# source <(curl -s https://raw.githubusercontent.com/alansartorio/Artix-Config/main/common.sh)
%INCLUDE common.sh
cd

# Autologin to user on boot
sudo sed -i "/^description=.*/a agetty_options=\"--autologin $USER --noclear\"" /etc/init.d/agetty.tty1

# source <(curl -s https://raw.githubusercontent.com/alansartorio/Artix-Config/main/add-arch-mirrors.sh)
%INCLUDE add-arch-mirrors.sh

# Font Key workaround
keyFile="$HOME/.gnupg/gpg.conf"
mkdir -p $(dirname "$keyFile")
if ! { [ -f "$keyFile" ] && grep -Fq "FONT_WORKAROUND" "$keyFile"; }
then
	cat >> "$keyFile" <<"EOF"
# FONT_WORKAROUND
keyserver hkps://keyserver.ubuntu.com
EOF
fi

# Install paru
sudo pacman -S --noconfirm --needed base-devel git
git clone https://aur.archlinux.org/paru-bin.git paru
( cd paru && makepkg -si --noconfirm --needed )
rm -rf paru


# Install some packages
paru -S --noconfirm --needed pulseaudio pulseaudio-alsa ntfs-3g \
		openssh xorg xorg-xinit wget zsh openrc-zsh-completions \
		rofi alacritty neovim neofetch firefox dolphin cmst

# Install my dotfiles
git clone https://github.com/alansartorio/dotfiles.git .dotfiles
cd .dotfiles
script/install
script/bootstrap
