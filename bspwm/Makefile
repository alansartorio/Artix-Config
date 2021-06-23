wallpapers: FORCE
	mkdir -p ~/Pictures
	ln -s "$(shell pwd)/Wallpapers" ~/Pictures/

bspwm: FORCE
	mkdir -p ~/.config/bspwm
	ln -s "$(shell pwd)/bspwmrc" ~/.config/bspwm/

sxhkd: FORCE
	mkdir -p ~/.config/sxhkd
	ln -s "$(shell pwd)/sxhkdrc" ~/.config/sxhkd/

polybar: FORCE
	mkdir -p ~/.config/polybar
	ln -s "$(shell pwd)/config" ~/.config/polybar/
	wget -O ~/.config/polybar/polybar-kdeconnect.sh https://github.com/haideralipunjabi/polybar-kdeconnect/raw/master/polybar-kdeconnect.sh && chmod +x ~/.config/polybar/polybar-kdeconnect.sh

install: FORCE wallpapers bspwm sxhkd polybar

FORCE:

.PHONY: install