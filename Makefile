git: FORCE
	sudo pacman -S git

paru: FORCE git
	sudo pacman -S --needed base-devel
	git clone https://aur.archlinux.org/paru.git
	cd paru && makepkg -si

packages: FORCE paru
	sudo pacman -S openssh xorg xorg-xinit wget zsh openrc-zsh-completions bspwm sxhkd feh
	paru -S polybar siji-git ttf-unifont xorg-fonts-misc

zsh: FORCE
	$(MAKE) -C zsh install

bspwm: FORCE
	$(MAKE) -C bspwm install

install: FORCE packages zsh bspwm

FORCE:

.PHONY: install