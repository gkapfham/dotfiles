# dotfiles

<p align="center">
<img src="https://raw.githubusercontent.com/gkapfham/dotfiles/master/.github/dotfiles-logo.jpeg" alt="Dotfiles Logo"</img>
<br>
<b>
Carefully Curated Dotfiles for Popular Linux Programs
</b>
</p>

[![Build Status](https://travis-ci.org/gkapfham/dotfiles.svg?branch=master)](https://travis-ci.org/gkapfham/dotfiles)

This repository contains the configuration files (i.e., "dotfiles") used to
configure the programs regularly used by me, [Gregory M.
Kapfhammer](https://www.gregorykapfhammer.com/). Please note that the dotfiles
in this repository are, at least to some extent, "hard-coded" to work for my
development environment and projects. For instance, I created these
configuration files under the assumption that a developer will use Arch Linux.
Even though they are heavily customized, my hope is that they are largely
reusable and, additionally, will give examples of how to configure various
programs such as `i3`, `mutt`, `nvim`, `polybar`, `tmux`, `vim`, and `zsh`.

This is a summary of some of the dotfiles and program configurations that I
created and actively maintain:

- `.Rprofile`: initialization for the R programming language
- `.Xresources`: configuration for the Rofi for displaying menus
- `.bibtoolrsc`: configuration for the `bibtool` program's BibTeX management
- `.ctags`: extensions for `exuberant-ctags` to handle new languages
- `.compton.conf`: configuration for the `compton` compositor used with `i3`
- `.gitconfig`: configuration file for Git, including customized aliases
- `.gitignore_global`: configuration of the files to exclude from Git repositories
- `.gvimrc`: legacy configuration of `gvim` text editor
- `.inputrc`: configuration of all input-enabled tools with `vi`-like mappings
- `.latexmkrc`: configuration for the `latexmk` wrapper for LaTeX compilers
- `.mailcap`: configuration for how MIME-enabled programs load files
- `.minivimrc`: minimal configuration of `vim` and `nvim` for testing purposes
- `.msmtprc`: legacy configuration for the `msmtp` SMTP client
- `.muttprintrc`: configuration of the `muttprint` program for printing emails
- `.muttrc`: configuration of the `mutt` mail user agent
- `.oh-my-zsh.sh`: customized script to load the oh-my-zsh framework
- `.zprofile`: script to run when first starting the shell environment
- `.signature`: footer displayed by `mutt` in all email messages
- `.tmux.conf`: configuration of the `tmux` terminal multiplexing tool
- `.urlview`: configuration for the `urlview` program used with `mutt` and `tmux`
- `.vimrc`: configuration for the `nvim` and `vim` text editors
- `.xinitrc`: configuration for to set environment variables and to start i3
- `.zshrc`: configuration for the `zsh` shell to use oh-my-zsh
- `.config/bat/themes`: theme configuration to ensure that `bat` looks like `nvim`
- `.config/alacritty`: configuration and color scheme for the `alacritty` terminal window
- `.config/dunst`: configuration and scripts for the `dunst` notification manager
- `.config/gtkrc-2.0`: configuration of GTK 2.0 to support legacy GTK programs on Arch Linux
- `.config/gtkrc-3.0`: configuration of GTK 3.0 to support GTK programs on Arch Linux
- `.config/i3`: configuration and scripts for the `i3` window manager
- `.config/polybar`: configuration and scripts for the `polybar` used with `i3`
- `.config/termite`: configuration and color scheme for the `termite` terminal window
- `.config/zathura`: configuration for the `zathura ` PDF viewer
- `.local/bin`: scripts for regular use through the terminal window and `rofi`

Are you looking for some neat configurations to sharpen your own dotfiles? If
so, then I encourage you to review the `.vimrc`, `.zshrc`, and `.tmux.conf`
files that I regularly improve. Interesting in learning how to configuration the
i3 window manager? Then, you are invited to review the `.config/i3` and
`.config/polybar` directories. Please note that many of these files have
groupings with beginning and ending marks that respectively look like `{{{` and
`}}}`, thereby helping to group the regions.

To ensure that my development environment is largely self-contained, this
repository also includes Git submodules of the packages that I actively use in,
for instance, the `zsh` shell. When I needed to heavily customize a specific
plugin or tool I forked a specific GitHub repository and then made my
improvements in that fork. Otherwise, I added the needed repository as a
sub-module to this one. These are the current submodules that I maintain:

- `fastsyntaxhighlighting`
- `fzftab`
- `gitstatus`
- `tpm`
- `zshautosuggestions`
- `zshdefer`
- `zshgitprompt`
- `zshsyntaxhighlighting`

## Installation Instructions

You can type the following command if you want to clone this repository:

```shell
git clone https://github.com/gkapfham/dotfiles.git
```

Now, you can type `cd dotfiles` and start to browse the configuration files that
are available. I suggest that you make symbolic links from your home directory
to this repository if you want to maintain and use these configuration files.
For instance, if you use the `bibtool` program to manage your BibTeX files and
if you were in your home directory and the `dotfiles/` directory was in
`configure/`, then you would type the following command to create the
`.bibtoolrsc` as a symbolic link to the file in the `~/configure/dotfiles/`
directory containing this repository.

```shell
ln -s ~/configure/dotfiles/.bibtoolrsc .bibtoolrsc
```

As an alternative to manually creating all of the symbolic links in the
aforementioned fashion, this repository has a `Makefile` with rules that use
`stow` to create these symbolic links automatically. If a system already
contains dotfiles that you no longer needed and you want to remove them from the
system, then please type the command `make purge`. Next, typing the command
`make dotfiles` will create all the needed directories and subdirectories and
make symbolic links to the dotfiles in this repository from the correct
destination directories. In summary, the main command to type is:

```shell
make dotfiles
```

## Problems or Praise

If you have any problems with downloading or understanding these configuration
files, then please create an issue associated with this Git repository using
the [Issues](https://github.com/gkapfham/dotfiles/issues) link at the top of
this repository. As the sole contributor to the `dotfiles` repository, I will
do everything possible to resolve your issue and ensure that all the
configurations are clear and, potentially, best suited to working in your
development environment. Remember, this repository is being made publicly
available to provide examples of how to write configurations for programs
like `vim` and `nvim`. If you find that these files help you in preparing
your own configurations, then I also encourage you to "star" and "watch" this
project!
