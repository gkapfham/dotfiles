## Create the needed directories in the .config/ directory
create:
	@# Create the dunst/ directory
	mkdir -p ~/.config/dunst
	@# Create the i3/ directory
	mkdir -p ~/.config/i3
	@# Create the polybar/ directory
	mkdir -p ~/.config/polybar
	@# Since the nvim directory links to .vim/
	@# (thereby supporting both Vim and Neovim), then
	@# remove the symbolic link to the nvim/ directory
	rm ~/.config/nvim
	@# Re-create the symbolic link to the nvim/ directory,
	@# now with no error since it was previously deleted
	@# This assumes that the .vim/ directory was already
	@# create by external step not connect to this Makefile
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

## Run stow on i3
stow-i3:
	stow -t ~/.config/i3 i3

## Run stow on nvim
stow-nvim:
	stow -t ~/.config/nvim nvim

## Run stow on polybar
stow-polybar:
	stow -t ~/.config/polybar polybar

## Run stow on shell
stow-shell:
	stow -t ~/ shell

## Run stow on system
stow-system:
	stow -t ~/ system

## Run stow on tmux
stow-tmux:
	stow -t ~/ tmux

## Run stow on tool
stow-tool:
	stow -t ~/ tool

## Run stow on vim
stow-vim:
	stow -t ~/ vim

## Run stow on writing
stow-writing:
	stow -t ~/ writing

## Run stow for all rules for all subdirectories
stow: stow-code stow-dunst stow-i3 stow-email stow-git stow-nvim stow-polybar stow-shell stow-system stow-tmux stow-tool stow-vim stow-writing

## Create directories and stow all of the dotfiles in correct directories
dotfiles: create stow

## Display a help message listing all tasks
help:
	make -rpn | sed -n -e '/^$$/ { n ; /^[^ .#][^ ]*:/ { s/:.*$$// ; p ; } ; }' | sort -u

## Specify that the default is full installation of the dotfiles
.DEFAULT_GOAL := dotfiles
