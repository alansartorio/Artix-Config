.PHONY: build

build: FORCE
	./Bash-Bundler/compile.sh -i install.sh -o installer.sh

FORCE:
