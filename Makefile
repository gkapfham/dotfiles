## Ensure that commands use zsh instead of sh {{{

SHELL=zsh

# }}}

## Every target here is a command, not a file. Without .PHONY a stray
## file or directory named e.g. `create`, `stow`, or `help` in the
## repository root would make make treat that target as up to date and
## silently skip it. {{{

.PHONY: check create create-alacritty create-atuin create-bat create-bin \
        create-config create-dunst create-fast-syntax-highlighting \
        create-firefox create-fzf-tab create-ghostty create-git-status \
        create-gtk2 create-gtk3 create-i3 create-i3status create-i3wsr \
        create-kitty create-mutt create-nvim create-opencode create-pi \
        create-picom create-polybar create-rofi create-termite create-tmux \
        create-tpm create-urlscan create-vimrc create-wezterm create-yazi \
        create-zathura create-zellij create-zsh create-zsh-auto-suggestions \
        create-zsh-defer create-zsh-syntax-highlighting create-zsh-vi-mode \
        create-zshdefer create-zshtheme dotfiles help purge \
        purge-libinput-gestures purge-mime purge-starship purge-trippy \
        purge-trolltech stow stow-alacritty stow-applications stow-atuin \
        stow-bat stow-bin stow-dunst stow-email stow-external \
        stow-fast-syntax-highlighting stow-firefox stow-fzf-tab stow-ghostty \
        stow-git stow-git-status stow-gtk2 stow-gtk3 stow-i3 stow-i3status \
        stow-i3wsr stow-kitty stow-libinput-gestures stow-mime stow-mutt \
        stow-nvim stow-opencode stow-pi stow-picom stow-polybar stow-rofi \
        stow-shell stow-starship stow-system stow-termite stow-tmux \
        stow-tool stow-tpm stow-trippy stow-trolltech stow-urlscan stow-vim \
        stow-vimrc stow-wezterm stow-writing stow-yazi stow-zathura \
        stow-zellij stow-zsh-auto-suggestions stow-zsh-autosuggestions \
        stow-zsh-syntax-highlighting stow-zsh-vi-mode stow-zshdefer \
        stow-zshtheme

# }}}

## Static checks {{{

## Hard gates (the target exits non-zero if any of these fail):
##   - bash -n on every tracked *.sh
##   - zsh  -n on the zsh dotfiles (shell/.zshrc, shell/.fasd-init-zsh,
##     and shell/.oh-my-zsh.sh, which is zsh despite carrying a .sh name)
##   - JSON validation of the tracked configuration files
##
## Informational only: shellcheck. The repository has pre-existing
## findings, so it is reported but never fails the target.
check:
	@fail=0; \
	echo "==> shell syntax"; \
	for f in $$(git ls-files '*.sh') shell/.zshrc shell/.fasd-init-zsh; do \
	  [ -f "$$f" ] || continue; \
	  case "$$f" in *.zshrc|*.fasd-init-zsh|*.oh-my-zsh.sh) sh=zsh ;; *) sh=bash ;; esac; \
	  if $$sh -n "$$f" 2>/dev/null; then echo "  ok    $$f  ($$sh -n)"; else echo "  FAIL  $$f  ($$sh -n)"; fail=1; fi; \
	done; \
	echo "==> JSON"; \
	for f in pi/settings.json pi/repos.json pi/extensions/quotas.json pi/themes/ghostty-terminal.json; do \
	  [ -f "$$f" ] || continue; \
	  if python3 -c 'import json,sys; json.load(open(sys.argv[1]))' "$$f" 2>/dev/null; then echo "  ok    $$f"; else echo "  FAIL  $$f"; fail=1; fi; \
	done; \
	echo "==> shellcheck (informational)"; \
	if command -v shellcheck >/dev/null 2>&1; then shellcheck -S warning $$(git ls-files '*.sh') || true; else echo "  shellcheck not installed (skipped)"; fi; \
	exit $$fail

## }}}

# NOTE: Not all of the rules in this Makefile are, within
# their specific region, group according to the type of
# program that they manage or in alphabetical order. This
# is due to the fact that I quickly added a new rule
# after one for a program that configured similarly.

## Purge all of the existing dotfiles {{{

# NOTE: This is not updated for all files
# that may need to be purged. With that said, it
# is likely that this rule is no longer needed
# since the create rules also delete files.
#
# The "dotfiles" rule does not run this purge
# command, suggesting that it is not needed

## Purge the symlinks that `make stow` created in the root
## of the user's home directory, setting the stage for the
## use of Stow with other rules.
##
## Safety: ONLY symlinks are removed. A real file (for
## example ~/.gtkrc-2.0, which this repository does not
## manage) is reported and left untouched, so purge can
## never destroy user data. Pass YES=1 to skip the prompt
## (for example `make purge YES=1`).
purge:
	@if [ "$${YES:-0}" = "1" ]; then \
	  echo "==> purge: removing stow symlinks from $$HOME (YES=1, no prompt)"; \
	else \
	  printf 'Remove the stow-created symlinks from %s? (y/N) ' "$$HOME"; \
	  read ans; \
	  [ "$$ans" = y ] || [ "$$ans" = Y ] || { echo "Aborted."; exit 1; }; \
	fi
	@for f in \
	  .Rprofile .mailcap .msmtprc .mbsyncrc .muttprintrc .muttrc .signature \
	  .gitconfig .gitignore_global .oh-my-zsh.sh .zshrc .compton.conf \
	  .gtkrc-2.0 .inputrc .profile .Xresources .tmux.conf .ctags .urlview \
	  .gvimrc .minivimrc .vimrc .bibtoolrsc .latexmkrc; do \
	  p="$$HOME/$$f"; \
	  if [ -L "$$p" ]; then \
	    rm -f "$$p" && echo "  removed  ~/$$f"; \
	  elif [ -e "$$p" ]; then \
	    echo "  SKIPPED  ~/$$f (real file, not a stow symlink)"; \
	  fi; \
	done
	@echo "==> purge complete"

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

## Remove the trippy.toml file from the .config/ directory
purge-trippy:
	rm -f ~/.config/trippy.toml

## Remove the libinput-gestures.conf file from the .config/ directory
purge-libinput-gestures:
	rm -f ~/.config/libinput-gestures.conf

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

## Create the needed ghostty/ directory in .config/
create-ghostty:
	rm -rf ~/.config/ghostty
	mkdir -p ~/.config/ghostty

## Depends on the creation of the .config directory
create-ghostty: create-config

## Create the needed rofi/ directory in .config/
create-rofi:
	rm -rf ~/.config/rofi
	mkdir -p ~/.config/rofi

## Depends on the creation of the .config directory
create-rofi: create-config

## Create the needed mutt/ directory in .config/
create-mutt:
	rm -rf ~/.config/mutt
	mkdir -p ~/.config/mutt

## Depends on the creation of the .config directory
create-mutt: create-config

## Create the needed atuin/ directory in .config/
create-atuin:
	rm -rf ~/.config/atuin
	mkdir -p ~/.config/atuin

## Depends on the creation of the .config directory
create-atuin: create-config

## Create the needed yazi/ directory in .config/
create-yazi:
	rm -rf ~/.config/yazi
	mkdir -p ~/.config/yazi

## Depends on the creation of the .config directory
create-yazi: create-config

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

## Create the chrome/ directory inside every Firefox profile so that
## stow-firefox has somewhere to link userChrome.css into.
## NOTE: unlike the other create-* rules above, this must NEVER delete
## anything (no `rm -rf`). Firefox profiles hold history, open tabs, and
## logins, so this only creates missing directories with `mkdir -p` and
## leaves all existing data untouched.
## Two profile locations are covered: Firefox uses ~/.mozilla/firefox by
## default, while this machine keeps profiles in ~/.config/mozilla/firefox.
## No dependency on create-config: the mozilla/ tree is created by Firefox
## itself, and if no profiles exist yet the find below simply prints nothing.
## `find` (rather than a shell glob) is used because this Makefile runs
## recipes with zsh (see SHELL at the top), where a glob matching nothing
## is a fatal error; errors such as a missing base directory are hidden
## with 2>/dev/null. `$$HOME` is make-escaping: make collapses `$$` to
## `$` before the shell sees it, so the shell gets a normal `$HOME`.
create-firefox:
	find $$HOME/.config/mozilla/firefox $$HOME/.mozilla/firefox -maxdepth 1 -type d -name '*.default*' 2>/dev/null | while read -r p; do \
		mkdir -p "$$p/chrome"; \
	done

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

## Create the needed picom/ directory in .config/
create-picom:
	rm -rf ~/.config/picom
	mkdir -p ~/.config/picom

## Depends on the creation of the .config directory
create-picom: create-config

## Create the needed i3status/ directory in .config/
create-i3status:
	rm -rf ~/.config/i3status
	mkdir -p ~/.config/i3status

## Depends on the creation of the .config directory
create-i3status: create-config

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

## Create the needed opencode/ directory in .config/
create-opencode:
	rm -rf ~/.config/opencode
	mkdir -p ~/.config/opencode

## Depends on the creation of the .config directory
create-opencode: create-config

## Create the needed zathura/ directory in .config/
create-zathura:
	rm -rf ~/.config/zathura
	mkdir -p ~/.config/zathura

## Depends on the creation of the .config directory
create-zathura: create-config

## Create the needed zellij/ directory in .config/
create-zellij:
	rm -rf ~/.config/zellij
	mkdir -p ~/.config/zellij

## Depends on the creation of the .config directory
create-zellij: create-config

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

## Create the needed pi directory in .config/
## NOTE: no `rm -rf` here as plugins keep state in ~/.config/pi
## (e.g., pi-web-access writes ~/.config/pi/web-search-cache) and
## that state must never be destroyed by running a make command
create-pi:
	mkdir -p ~/.config/pi

## Depends on the creation of the .config directory
create-pi: create-config

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

## Run stow on ghostty
stow-ghostty:
	stow -t ~/.config/ghostty ghostty

## Running stow depends on the creation of the directory
stow-ghostty: create-ghostty

## Run stow on rofi
stow-rofi:
	stow -t ~/.config/rofi rofi

## Running stow depends on the creation of the directory
stow-rofi: create-rofi

## Run stow on mutt
stow-mutt:
	stow -t ~/.config/mutt mutt

## Running stow depends on the creation of the directory
stow-mutt: create-mutt

## Run stow on atuin
stow-atuin:
	stow -t ~/.config/atuin atuin

## Running stow depends on the creation of the directory
stow-atuin: create-atuin

## Run stow on yazi
stow-yazi:
	stow -t ~/.config/yazi yazi

## Running stow depends on the creation of the directory
stow-yazi: create-yazi

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

## Link userChrome.css into the chrome/ directory of every Firefox profile.
## NOTE: plain `stow` cannot do this job. stow links one package directory
## to one fixed target directory, but Firefox names each profile directory
## randomly (e.g., gfa0n85z.default) and one machine can hold several
## profiles at once. This shell loop finds every profile and points its
## chrome/userChrome.css at the single copy controlled by this repository:
## firefox/chrome/userChrome.css. The canonical file lives in the repo;
## each profile just holds a symbolic link to it.
## Line-by-line guide for the curious:
## - The `find ... | while read -r p` pipeline discovers every profile in
##   both known Firefox locations, then links the file into each one.
##   `find` is used instead of a shell glob because recipes run under zsh
##   here, where an unmatched glob is fatal (see create-firefox above).
## - `$(CURDIR)` is an automatic make variable holding the repository root
##   that make was run from, so each symlink target is absolute and valid
##   no matter which profile directory the link lives in.
## - `ln -sf` makes this idempotent: re-running `make stow-firefox` after
##   a new profile appears (or on a brand-new machine) links everything
##   up again without harming existing links.
## After linking, fully restart Firefox (open tabs restore automatically)
## so that it reloads userChrome.css.
stow-firefox:
	find $$HOME/.config/mozilla/firefox $$HOME/.mozilla/firefox -maxdepth 1 -type d -name '*.default*' 2>/dev/null | while read -r p; do \
		ln -sf $(CURDIR)/firefox/chrome/userChrome.css "$$p/chrome/userChrome.css"; \
	done

## Running stow on firefox depends on creating the profile chrome/ directories
stow-firefox: create-firefox

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

## Run stow on picom
stow-picom:
	stow -t ~/.config/picom picom

## Running stow on picom depends on creating picom directory
stow-picom: create-picom

## Run stow on i3status
stow-i3status:
	stow -t ~/.config/i3status i3status

## Running stow on i3status depends on creating i3status directory
stow-i3status: create-i3status

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

## Run stow on opencode
stow-opencode:
	stow -t ~/.config/opencode opencode

## Running stow depends on the creation of the directory
stow-opencode: create-opencode

## Run stow on starship
stow-starship:
	stow -t ~/.config/ starship

## Running stow on the starship directory depends on the starship file
## not being currently in existence, so purge it first
stow-starship: purge-starship

## Run stow on trippy
stow-trippy:
	stow -t ~/.config/ trippy

## Running stow on the trippy directory depends on the trippy file
## not being currently in existence, so purge it first
stow-trippy: purge-trippy

## Run stow on libinput-gestures
stow-libinput-gestures:
	stow -t ~/.config/ libinput-gestures

## Running stow on the libinput-gestures directory depends on the libinput-gestures file
## not being currently in existence, so purge it first
stow-libinput-gestures: purge-libinput-gestures

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

## Run stow on zellij
stow-zellij:
	stow -t ~/.config/zellij zellij

## Running stow on zellij depends on creating zellij directory
stow-zellij: create-zellij

## Run stow on pi (repos.json only)
## The rest of pi/ (settings.json, extensions/, skills/, pi-msg/)
## is guarded by pi/.stow-local-ignore: those files are synced into
## the repo deliberately (see pi/sync-config.sh) and belong to
## ~/.pi/agent, not ~/.config/pi.
##
## ~/.config/pi-msg (the XMPP bridge runtime) is deliberately NOT stowed:
## it holds secrets (passwords, API keys, private keys) and files the
## bridge rewrites at runtime (default.session, default.lastout). It is
## generated by the pi-msg setup scripts from templates in pi/pi-msg/.
stow-pi:
	stow -t ~/.config/pi pi

## Running stow on pi depends on creating pi directory
stow-pi: create-pi

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

## Run stow on bin (which are saved in the directory 
## called programs in the dotfiles directory)
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
create: create-config create-alacritty create-kitty create-ghostty create-rofi create-mutt create-atuin create-yazi create-bat create-dunst create-firefox create-gtk2 create-gtk3 create-i3 create-i3status create-picom create-i3wsr create-polybar create-termite create-tmux create-urlscan create-wezterm create-zathura create-zellij create-opencode create-pi create-tpm create-bin create-nvim create-zsh create-fzf-tab create-zshtheme create-git-status create-zsh-defer create-fast-syntax-highlighting create-zsh-syntax-highlighting create-zsh-auto-suggestions

## Run stow for all rules for all subdirectories
stow: stow-alacritty stow-kitty stow-ghostty stow-rofi stow-mutt stow-atuin stow-yazi stow-bat stow-dunst stow-firefox stow-gtk2 stow-gtk3 stow-mime stow-trolltech stow-starship stow-trippy stow-libinput-gestures stow-i3 stow-i3status stow-i3wsr stow-picom stow-email stow-git stow-nvim stow-polybar stow-termite stow-urlscan stow-wezterm stow-zathura stow-zellij stow-opencode stow-pi stow-tpm stow-bin stow-shell stow-system stow-tool stow-writing stow-zshtheme stow-applications

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
