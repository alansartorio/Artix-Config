
bspwm: FORCE
	mkdir -p ~/.config/bspwm
	ln -s "$(pwd)/bspwmrc" ~/.config/bspwm/

sxhkd: FORCE
	mkdir -p ~/.config/sxhkd
	ln -s "$(pwd)/sxhkdrc" ~/.config/sxhkd/

polybar: FORCE
	mkdir -p ~/.config/polybar
	ln -s "$(pwd)/config" ~/.config/polybar/
	wget -O ~/.config/polybar/polybar-kdeconnect.sh https://github.com/haideralipunjabi/polybar-kdeconnect/raw/master/polybar-kdeconnect.sh

install: FORCE bspwm sxhkd polybar

FORCE:

.PHONY: install