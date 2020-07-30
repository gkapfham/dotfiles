## Purge all of the existing dotfiles {{{

## Purge all of the existing symlinks
## that were manually created, setting the
## stage for the use of Stow with other rules
Furge:
	rm -f ~/.Rprofile
	rm -f ~/.mailcap
	rm -f ~/.msmtprc
	rm -f ~/.muttprintrc
	rm -f ~/.muttrc
	rm -f ~/.signature
	rm -f ~/.gitconfig
	rm -f ~/.gitignore_global
	rm -rf ~/.oh-my-zsh.sh
	rm -rf ~/.zshrc
	rm -rf ~/.compton.conf
	rm -rf ~/.gtkrc-2.0
	rm -rf ~/.inputrc
	rm -rf ~/.profile
	rm -rf ~/.Xresources
	rm -rf ~/.tmux.conf
	rm -rf ~/.ctags
	rm -rf ~/.urlview
	rm -rf ~/.gvimrc
	rm -rf ~/.minivimrc
	rm -rf ~/.vimrc
	rm -rf ~/.bibtoolrsc
	rm -rf ~/.latexmkrc

## }}}

## Create all required directories for dotfiles {{{

## Create the .config/ directory to store subdirectories
create-config:
	mkdir -p ~/.config

## Create the needed dunst/ directory in .config/
create-dunst:
	rm -rf ~/.config/dunst
	mkdir -p ~/.config/dunst

## Create the needed i3/ directory in .config/
create-i3:
	rm -rf ~/.config/i3
	mkdir -p ~/.config/i3

## Create the needed polybar/ directory in .config/
create-polybar:
	rm -rf ~/.config/polybar
	mkdir -p ~/.config/polybar

## Create the needed tmux/ directory in .config/
create-tmux:
	rm -rf ~/.config/tmux
	mkdir -p ~/.config/tmux

## Create the needed nvim directory and link in .config/
create-nvim:
	@# Since the nvim directory links to .vim/
	@# (thereby supporting both Vim and Neovim), then
	@# remove the symbolic link to the nvim/ directory
	rm -rf ~/.config/nvim
	@# Re-create the symbolic link to the nvim/ directory,
	@# now with no error since it was previously deleted
	@# This assumes that the .vim/ directory was already
	@# create by external step not connect to this Makefile
	ln -s ~/.vim ~/.config/nvim
	@# Delete the init.vim file as it will later be stowed
	rm -rf ~/.config/nvim/init.vim

## }}}

## Create all required directories for external dependencies {{{

## Create the needed directories for external zsh plugins
## that are stored in the dotfiles repository as submodules

## Curating these repositories ensures that the dotfiles
## repository is entirely self-contained and installable

## Create the .zsh/ directory for the zsh plugins
create-zsh:
	mkdir -p .zsh/

## Create the needed fast-syntax-highlighting/ directory in .zsh/
create-fast-syntax-highlighting:
	rm -rf ~/.zsh/fast-syntax-highlighting
	mkdir -p ~/.zsh/fast-syntax-highlighting

## Create the needed zsh-syntax-highlighting/ directory in .zsh/
create-zsh-syntax-highlighting:
	rm -rf ~/.zsh/zsh-syntax-highlighting
	mkdir -p ~/.zsh/zsh-syntax-highlighting

## Create the needed fzf-tab/ directory in .zsh/
create-fzf-tab:
	rm -rf ~/.zsh/fzf-tab
	mkdir -p ~/.zsh/fzf-tab

## Create the needed zsh-auto-suggestions/ directory in .zsh/
create-zsh-auto-suggestions:
	rm -rf ~/.zsh/zsh-autosuggestions
	mkdir -p ~/.zsh/zsh-autosuggestions

## Create the needed zsh-git-prompt/ directory in .zsh/
create-zsh-git-prompt:
	rm -rf ~/.zsh/zsh-git-prompt
	mkdir -p ~/.zsh/zsh-git-prompt

## Create the needed gitstatus/ directory in .zsh/
create-git-status:
	rm -rf ~/.zsh/gitstatus
	mkdir -p ~/.zsh/gitstatus

## }}}

## Run stow on internal dotfiles {{{

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

## Running stow on i3 depends on creating i3 directory
stow-i3: create-i3

## Run stow on nvim
stow-nvim:
	stow -t ~/.config/nvim nvim

## Running stow on nvim depends on creating nvim directory
stow-nvim: create-nvim

## Run stow on polybar
stow-polybar:
	stow -t ~/.config/polybar polybar

## Running stow on polybar depends on creating polybar directory
stow-polybar: create-polybar

## Run stow on shell
stow-shell:
	stow -t ~/ shell

## Run stow on system
stow-system:
	stow -t ~/ system

## Run stow on tmux
stow-tmux:
	stow -t ~/.config/tmux tmux

## Run stow on tool
stow-tool:
	stow -t ~/ tool

## Run stow on vim
stow-vim:
	stow -t ~/ vim

## Run stow on writing
stow-writing:
	stow -t ~/ writing

## Run stow on external dependencies {{{

## Run stow on fast-syntax-highlighting
stow-fast-syntax-highlighting:
	stow -t ~/.zsh/fast-syntax-highlighting fastsyntaxhighlighting

## Run stow on zsh-syntax-highlighting
stow-zsh-syntax-highlighting:
	stow -t ~/.zsh/zsh-syntax-highlighting zshsyntaxhighlighting

## Run stow on fzf-tab
stow-fzf-tab:
	stow -t ~/.zsh/fzf-tab fzftab

## Run stow on zsh-git-prompt
stow-zsh-auto-suggestions:
	stow -t ~/.zsh/zsh-autosuggestions zshautosuggestions

## Run stow on zsh-git-prompt
stow-zsh-git-prompt:
	stow -t ~/.zsh/zsh-git-prompt zshgitprompt

## Run stow on gitstatus
stow-git-status:
	stow -t ~/.zsh/gitstatus gitstatus

# }}}

## Composite rules {{{

## Create the needed directories in the .config/ and .zsh/ directories
create: create-config create-dunst create-i3 create-polybar create-tmux create-nvim create-zsh create-fzf-tab create-zsh-git-prompt create-git-status create-fast-syntax-highlighting create-zsh-syntax-highlighting create-zsh-auto-suggestions

## Run stow for all rules for all subdirectories
stow: stow-code stow-dunst stow-i3 stow-email stow-git stow-nvim stow-polybar stow-tmux stow-shell stow-system stow-tmux stow-tool stow-vim stow-writing

## Run stow for all rules for the external dependencies
stow-external: stow-fzf-tab stow-zsh-git-prompt stow-git-status stow-fast-syntax-highlighting stow-zsh-syntax-highlighting stow-zsh-auto-suggestions

## Create directories and stow all of the dotfiles in correct directories
dotfiles: create stow stow-external

# }}}

## Help {{{

## Display a help message listing all tasks
help:
	make -rpn | sed -n -e '/^$$/ { n ; /^[^ .#][^ ]*:/ { s/:.*$$// ; p ; } ; }' | sort -u

## Specify that the default is full installation of the dotfiles
.DEFAULT_GOAL := dotfiles

# }}}
