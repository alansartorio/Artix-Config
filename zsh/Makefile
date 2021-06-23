link:
	ln -s "$(shell pwd)/.p10k.zsh" ~/
	ln -s "$(shell pwd)/.zshrc" ~/
	ln -s "$(shell pwd)/.myshell" ~/


install: FORCE link
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${HOME}/.oh-my-zsh/custom/themes/powerlevel10k
	sed -i 's@ZSH_THEME=".*"@ZSH_THEME="powerlevel10k/powerlevel10k"@' ~/.zshrc
FORCE:

.PHONY: install
