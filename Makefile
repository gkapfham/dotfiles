## Create needed directories in the .config
createdirs:
	mkdir -p .config/dunst

## Run stow on code
stow-code:
	stow -t ~/ code

## Run stow on dunst
stow-dunst:
	stow -t ~/.config dunst

## Run stow on email
stow-email:
	stow -t ~/ email

## Run stow for all rules for all subdirectories
stow: stow-code stow-dunst stow-email

## Create directories and stow all of the dotfiles in correct directories
dotfiles: createdirs stow

## Display a help message listing all tasks
help:
	make -rpn | sed -n -e '/^$$/ { n ; /^[^ .#][^ ]*:/ { s/:.*$$// ; p ; } ; }' | sort -u

.DEFAULT_GOAL := dotfiles
