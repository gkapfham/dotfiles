## Ensure that commands use zsh instead of sh {{{

SHELL=zsh

# }}}

## Purge all of the existing dotfiles {{{

# NOTE: This is not updated for all directories
# that may need to be purged. With that said, it
# is likely that this rule is no longer needed
# since the create rules also delete directories.

## Purge all of the existing symlinks
## that were manually created, setting the
## stage for the use of Stow with other rules
purge:
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

## Create the .config/ directory to store sub-directories
create-config:
	mkdir -p ~/.config

## Remove the mimeapps.list file from the .config directory
purge-mime:
	rm -f ~/.config/mimeapps.list

## Remove the Trolltech.conf file from the .config/ directory
purge-trolltech:
	rm -f ~/.config/Trolltech.conf

## Remove the starship.toml file from the .config/ directory
purge-starship:
	rm -f ~/.config/starship.toml

## Create the needed alacritty/ directory in .config/
create-alacritty:
	rm -rf ~/.config/alacritty
	mkdir -p ~/.config/alacritty

## Depends on the creation of the .config directory
create-alacritty: create-config

## Create the needed kitty/ directory in .config/
create-kitty:
	rm -rf ~/.config/kitty
	mkdir -p ~/.config/kitty

## Depends on the creation of the .config directory
create-kitty: create-config

## Create the needed bat/ directory in .config/
create-bat:
	rm -rf ~/.config/bat
	mkdir -p ~/.config/bat

## Depends on the creation of the .config directory
create-bat: create-config

## Create the needed dunst/ directory in .config/
create-dunst:
	rm -rf ~/.config/dunst
	mkdir -p ~/.config/dunst

## Depends on the creation of the .config directory
create-bat: create-config

## Create the needed gtk-2.0/ directory in .config/
create-gtk2:
	rm -rf ~/.config/gtk-2.0
	mkdir -p ~/.config/gtk-2.0

## Depends on the creation of the .config directory
create-gtk2: create-config

## Create the needed gtk-3.0/ directory in .config/
create-gtk3:
	rm -rf ~/.config/gtk-3.0
	mkdir -p ~/.config/gtk-3.0

## Depends on the creation of the .config directory
create-gtk3: create-config

## Create the needed i3/ directory in .config/
create-i3:
	rm -rf ~/.config/i3
	mkdir -p ~/.config/i3

## Depends on the creation of the .config directory
create-i3: create-config

## Create the needed i3wsr/ directory in .config/
create-i3wsr:
	rm -rf ~/.config/i3wsr
	mkdir -p ~/.config/i3wsr

## Depends on the creation of the .config directory
create-i3: create-config

## Create the needed polybar/ directory in .config/
create-polybar:
	rm -rf ~/.config/polybar
	mkdir -p ~/.config/polybar

## Depends on the creation of the .config directory
create-polybar: create-config

## Create the needed .tmux/ directory in home directory
create-tmux:
	rm -rf ~/.tmux
	mkdir -p ~/.tmux
	mkdir -p ~/.tmux/plugins
	mkdir -p ~/.tmux/plugins/tpm

## Depends on the creation of the .config directory
create-tmux: create-config

## Create the needed termite/ directory in .config/
create-termite:
	rm -rf ~/.config/termite
	mkdir -p ~/.config/termite

## Depends on the creation of the .config directory
create-termite: create-config

## Create the needed urlscan/ directory in .config/
create-urlscan:
	rm -rf ~/.config/urlscan
	mkdir -p ~/.config/urlscan

## Depends on the creation of the .config directory
create-urlscan: create-config

## Create the needed wezterm/ directory in .config/
create-wezterm:
	rm -rf ~/.config/wezterm
	mkdir -p ~/.config/wezterm

## Depends on the creation of the .config directory
create-wezterm: create-config

## Create the needed zathura/ directory in .config/
create-zathura:
	rm -rf ~/.config/zathura
	mkdir -p ~/.config/zathura

## Depends on the creation of the .config directory
create-zathura: create-config

## Create the needed directory in ~/.oh-my-zsh for the custom themes
create-zshtheme:
	mkdir -p ~/.oh-my-zsh/custom/themes

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
	# ln -s ~/.vim ~/.config/nvim
	@# Delete the init.vim file as it will later be stowed
	@# rm -rf ~/.config/nvim/init.vim
	@# Delete the init.lua file as it will later be stowed
	rm -rf ~/.config/nvim/init.lua
	mkdir -p ~/.config/nvim
	@# Delete the cache directory for nvim ctags
	mkdir -p ~/.cache/nvim/ctags/

## Create the ~/.vim/rc directory that contains .vim files
## that contain components of the .vimrc file
create-vimrc:
	rm -rf ~/.vim/rc
	mkdir -p ~/.vim/rc

## }}}

## Create all required directories for additional (but non-external) programs {{{

## Create the needed .tmux/ directory in home
create-tpm:
	rm -rf ~/.tmux
	mkdir -p ~/.tmux
	mkdir -p ~/.tmux/plugins
	mkdir -p ~/.tmux/plugins/tpm

## Create the needed .local/bin directory in home
create-bin:
	rm -rf ~/.local/bin
	mkdir -p ~/.local/bin

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

## Depends on the creation of the .zsh directory
create-fast-syntax-highlighting: create-zsh

## Create the needed zsh-syntax-highlighting/ directory in .zsh/
create-zsh-syntax-highlighting:
	rm -rf ~/.zsh/zsh-syntax-highlighting
	mkdir -p ~/.zsh/zsh-syntax-highlighting

## Depends on the creation of the .zsh directory
create-zsh-syntax-highlighting: create-zsh

## Create the needed fzf-tab/ directory in .zsh/
create-fzf-tab:
	rm -rf ~/.zsh/fzf-tab
	mkdir -p ~/.zsh/fzf-tab

## Depends on the creation of the .zsh directory
create-fzf-tab: create-zsh

## Create the needed zsh-auto-suggestions/ directory in .zsh/
create-zsh-auto-suggestions:
	rm -rf ~/.zsh/zsh-autosuggestions
	mkdir -p ~/.zsh/zsh-autosuggestions

## Depends on the creation of the .zsh directory
create-zsh-auto-suggestions: create-zsh

## Create the needed zsh-defer/ directory in .zsh/
create-zshdefer:
	rm -rf ~/.zsh/zsh-defer
	mkdir -p ~/.zsh/zsh-defer

## Depends on the creation of the .zsh directory
create-zsh-defer: create-zsh

## Create the needed gitstatus/ directory in .zsh/
create-git-status:
	rm -rf ~/.zsh/gitstatus
	mkdir -p ~/.zsh/gitstatus

## Depends on the creation of the .zsh directory
create-git-status: create-zsh

## Create the needed gitstatus/ directory in .zsh/
create-zsh-vi-mode:
	rm -rf ~/.zsh/zsh-vi-mode
	mkdir -p ~/.zsh/zsh-vi-mode

## Depends on the creation of the .zsh directory
create-git-status: create-zsh

## }}}

# NOTE: These rules work because of the way in which the
# composite rules are structured. However, they should all
# have their dependencies explicitly declared like
# the stow-bat rule.

## Run stow on internal dotfiles {{{

## Run stow on alacritty
stow-alacritty:
	stow -t ~/.config/alacritty alacritty

## Running stow depends on the creation of the directory
stow-alacritty: create-alacritty

## Run stow on kitty
stow-kitty:
	stow -t ~/.config/kitty kitty

## Running stow depends on the creation of the directory
stow-kitty: create-kitty

## Run stow on bat
stow-bat:
	stow -t ~/.config/bat bat

## Running stow on bat depends on creating bat directory
stow-bat: create-bat

# ## Run stow on code
# stow-code:
# 	stow -t ~/ code

## Run stow on dunst
stow-dunst:
	stow -t ~/.config/dunst dunst

## Running stow on dunst depends on creating dunst directory
stow-dunst: create-dunst

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

## Run stow on i3wsr
stow-i3wsr:
	stow -t ~/.config/i3wsr i3wsr

## Running stow on i3wsr depends on creating i3wsr directory
stow-i3wsr: create-i3wsr

## Run stow on gtk-2.0
stow-gtk2:
	stow -t ~/.config/gtk-2.0 gtk-2.0

## Running stow on gtk2 depends on creating gtk2 directory
stow-gtk2: create-gtk2

## Run stow on gtk-3.0
stow-gtk3:
	stow -t ~/.config/gtk-3.0 gtk-3.0

## Running stow on gtk3 depends on creating gtk3 directory
stow-gtk3: create-gtk3

## Run stow on mime
stow-mime:
	stow -t ~/.config/ mime

## Running stow on the mime directory depends on the mime file
## not being currently in existence, so purge it first
stow-mime: purge-mime

## Run stow on trolltech
stow-trolltech:
	stow -t ~/.config/ trolltech

## Running stow on the trolltech directory depends on the trolltech file
## not being currently in existence, so purge it first
stow-trolltech: purge-trolltech

## Run stow on starship
stow-starship:
	stow -t ~/.config/ starship

## Running stow on the starship directory depends on the starship file
## not being currently in existence, so purge it first
stow-starship: purge-starship

## Run stow on nvim
stow-nvim:
	stow -t ~/.config/nvim nvim

## Running stow on nvim depends on creating nvim directory
stow-nvim: create-nvim

## Run stow on vimrc
stow-vimrc:
	stow -t ~/.vim/rc vimrc

## Running stow on vimrc depends on creating the ~/.vim/rc directory
stow-vimrc: create-vimrc

## Run stow on polybar
stow-polybar:
	stow -t ~/.config/polybar polybar

## Running stow on polybar depends on creating polybar directory
stow-polybar: create-polybar

## Run stow on termite
stow-termite:
	stow -t ~/.config/termite termite

## Running stow on termite depends on creating termite directory
stow-termite: create-termite

## Run stow on shell
stow-shell:
	stow -t ~/ shell

## Run stow on system
stow-system:
	stow -t ~/ system

## Run stow on tmux
stow-tmux:
	stow -t ~/.tmux tmux

## Running stow on tmux depends on creating tmux directory
stow-tmux: create-tmux

## Run stow on tool
stow-tool:
	stow -t ~/ tool

## Run stow on vim
stow-vim:
	stow -t ~/ vim

## Run stow on writing
stow-writing:
	stow -t ~/ writing

## Run stow on urlscan
stow-urlscan:
	stow -t ~/.config/urlscan urlscan

## Running stow on urlscan depends on creating urlscan directory
stow-urlscan: create-urlscan

## Run stow on wezterm
stow-wezterm:
	stow -t ~/.config/wezterm wezterm

## Running stow depends on the creation of the directory
stow-wezterm: create-wezterm

## Run stow on zathura
stow-zathura:
	stow -t ~/.config/zathura zathura

## Running stow on zathura depends on creating zathura directory
stow-zathura: create-zathura

## Run stow on zshtheme
stow-zshtheme:
	stow -t ~/.oh-my-zsh/custom/themes zshtheme

# Running stow on zshtheme depends on creating the theme's directory
stow-zshtheme: create-zshtheme

# }}}

## Run stow on external dependencies and other programs {{{

## Run stow on fast-syntax-highlighting
stow-fast-syntax-highlighting:
	stow -t ~/.zsh/fast-syntax-highlighting fastsyntaxhighlighting

## Running stow depends on the creation of associated directory
stow-fast-syntax-highlighting: create-fast-syntax-highlighting

## Run stow on zsh-syntax-highlighting
stow-zsh-syntax-highlighting:
	stow -t ~/.zsh/zsh-syntax-highlighting zshsyntaxhighlighting

## Running stow depends on the creation of associated directory
stow-zsh-syntax-highlighting: create-zsh-syntax-highlighting

## Run stow on fzf-tab
stow-fzf-tab:
	stow -t ~/.zsh/fzf-tab fzftab

## Running stow depends on the creation of associated directory
stow-fzf-tab: create-fzf-tab

## Run stow on zsh-auto-suggestions
stow-zsh-auto-suggestions:
	stow -t ~/.zsh/zsh-autosuggestions zshautosuggestions

## Running stow depends on the creation of associated directory
stow-zsh-autosuggestions: create-zsh-autosuggestions

## Running stow depends on the creation of associated directory
stow-zsh-autosuggestions: create-zsh-autosuggestions

## Run stow on zsh-defer
stow-zshdefer:
	stow -t ~/.zsh/zsh-defer zshdefer

## Running stow depends on the creation of associated directory
stow-zshdefer: create-zshdefer

## Run stow on gitstatus
stow-git-status:
	stow -t ~/.zsh/gitstatus gitstatus

## Running stow depends on the creation of associated directory
stow-git-status: create-git-status

## Run stow on zshvimode
stow-zsh-vi-mode:
	stow -t ~/.zsh/zsh-vi-mode zshvimode

## Running stow depends on the creation of associated directory
stow-zsh-vi-mode: create-zsh-vi-mode

## Run stow on tpm
stow-tpm:
	stow -t ~/.tmux/plugins/tpm tpm

## Running stow on tpm depends on creating tpm directory
stow-tpm: create-tpm

## Run stow on bin
stow-bin:
	stow -t ~/.local/bin programs

## Running stow on bin depends on creating bin directory
stow-bin: create-bin

## Run stow on applications
stow-applications:
	stow -t ~/.local/share/applications applications

# }}}

## Composite rules {{{

## Create the needed directories in the .config/ and .zsh/ directories
create: create-config create-alacritty create-kitty create-bat create-dunst create-gtk2 create-gtk3 create-i3 create-i3wsr create-polybar create-termite create-tmux create-urlscan create-wezterm create-zathura create-tpm create-bin create-nvim create-zsh create-fzf-tab create-zshtheme create-git-status create-zsh-defer create-fast-syntax-highlighting create-zsh-syntax-highlighting create-zsh-auto-suggestions

## Run stow for all rules for all subdirectories
stow: stow-alacritty stow-kitty stow-bat stow-dunst stow-gtk2 stow-gtk3 stow-mime stow-trolltech stow-starship stow-i3 stow-i3wsr stow-email stow-git stow-nvim stow-polybar stow-termite stow-urlscan stow-wezterm stow-zathura stow-tpm stow-bin stow-shell stow-system stow-tool stow-writing stow-zshtheme stow-applications

## Run stow for all rules for the external dependencies
stow-external: stow-fzf-tab stow-zshdefer stow-git-status stow-zsh-vi-mode stow-fast-syntax-highlighting stow-zsh-syntax-highlighting stow-zsh-auto-suggestions

## Create directories and stow all of the dotfiles in correct directories
dotfiles: create stow stow-external

# }}}

## Help {{{

## Display a help message listing all tasks
help:
	make -rpn | sed -n -e '/^$$/ { n ; /^[^ .#][^ ]*:/ { s/:.*$$// ; p ; } ; }' | sort -u

# }}}

## Default {{{

## Specify that the default is full installation of the dotfiles
.DEFAULT_GOAL := dotfiles

# }}}
