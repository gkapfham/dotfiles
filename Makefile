## Create needed directories in the .config
create:
	@# Create the dunst directory
	mkdir -p ~/.config/dunst
	@# Since the nvim directory links to .vim
	@# (supporting both Vim and Neovim), then
	@# remove the symbolic link to the nvim directory
	rm ~/.config/nvim
	@# Re-create the symbolic link to the nvim directory,
	@# with no error since it was previously deleted
	ln -s ~/.vim ~/.config/nvim

## Run stow on code
stow-code:
	stow -t ~/ code

## Run stow on dunst
stow-dunst:
	stow -t ~/.config/dunst dunst

## Run stow on email
stow-email:
	stow -t ~/ email

## Run stow on git
stow-git:
	stow -t ~/ git

## Run stow on nvim
stow-nvim:
	stow -t ~/.config/nvim nvim

## Run stow on shell
stow-shell:
	stow -t ~/ shell

## Run stow on system
stow-system:
	stow -t ~/ system

## Run stow for all rules for all subdirectories
stow: stow-code stow-dunst stow-email stow-git stow-nvim stow-shell stow-system

## Create directories and stow all of the dotfiles in correct directories
dotfiles: create stow

## Display a help message listing all tasks
help:
	make -rpn | sed -n -e '/^$$/ { n ; /^[^ .#][^ ]*:/ { s/:.*$$// ; p ; } ; }' | sort -u

## Specify that the default is full installation of the dotfiles
.DEFAULT_GOAL := dotfiles
