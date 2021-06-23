git: FORCE
	sudo pacman -S --noconfirm git

paru: FORCE git
	sudo pacman -S --noconfirm --needed base-devel
	git clone https://aur.archlinux.org/paru.git
	cd paru && makepkg -si

packages: FORCE paru
	sudo pacman -S --noconfirm openssh xorg xorg-xinit wget zsh openrc-zsh-completions bspwm sxhkd feh connmand-gtk rofi alacritty kde-connect
	paru -S --noconfirm polybar siji-git ttf-unifont xorg-fonts-misc neovim

zsh: FORCE
	$(MAKE) -C zsh install

bspwm: FORCE
	$(MAKE) -C bspwm install

install: FORCE packages zsh bspwm

FORCE:

.PHONY: install