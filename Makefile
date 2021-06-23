git:
	sudo pacman -S git

paru: git
	sudo pacman -S --needed base-devel
	git clone https://aur.archlinux.org/paru.git
	cd paru && makepkg -si

packages: paru
	sudo pacman -S xorg xorg-xinit zsh openrc-zsh-completions bspwm sxhkd feh
	paru -S polybar siji-git ttf-unifont xorg-fonts-misc

	

zsh:
	$(MAKE) -C zsh install

bspwm:
	$(MAKE) -C bspwm install

install: zsh bspwm