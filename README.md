# dotfiles

This repository contains the configuration files (i.e., "dotfiles") used to
configure the programs regularly used by [Gregory M.
Kapfhammer](http://www.cs.allegheny.edu/sites/gkapfham). Please note that all of
the dotfiles in this repository are, at least to some extent, "hard-coded" to
work for my development environment and projects. For instance, I created these
configuration files under the assumption that the developer will use Ubuntu
16.04. Even though they are heavily customized, my hope is that they are largely
reusable and, additionally, will give examples of how to configure various
programs such as `nvim`, `vim`, `zsh`, `mutt`, and `tmux`.

This is a summary of the dotfiles that I currently provide and maintain:

- `.Rprofile`: initialization for the R programming language
- `.Xresources`: configuration for the Rofi for displaying menus
- `.bibtoolrsc`: configuration for the `bibtool` program's BibTeX management
- `.ctags`: extensions for `exuberant-ctags` to handle new languages
- `.gitignore_global`: configuration of the files to exclude from Git repositories
- `.gtkrc-2.0`: legacy configuration of GTK 2.0 to support `gvim` on Ubuntu
- `.gvimrc`: legacy configuration of `gvim` text editor
- `.inputrc`: configuration of all input-enabled tools with vi-like mappings
- `.latexmkrc`: configuration for the `latexmk` wrapper for LaTeX compilers
- `.mailcap`: configuration for how MIME-enabled programs load files
- `.minivimrc`: minimal configuration of `vim` and `nvim` for testing purposes
- `.msmtprc`: legacy configuration for the `msmtp` SMTP client
- `.muttprintrc`: configuration of the `muttprint` program for printing emails
- `.muttrc`: configuration of the `mutt` mail user agent
- `.signature`: footer displayed by `mutt` in all email messages
- `.tmux.conf`: configuration of the `tmux` terminal multiplexing tool
- `.vimrc`: configuration for the `nvim` and `vim` text editors
- `.zshrc`: configuration for the `zsh` shell to use oh-my-zsh

Are you looking for some neat configurations to sharpen your own dotfiles? If
so, then I encourage you to review the `.vimrc`, `.zshrc`, and `.tmux.conf`
files that I regularly improve. Please note that all of these files have
groupings with beginning and ending marks that respectively look like `{{{` and
`}}}`.

## Installation Instructions

You can type the following command if you want to clone this repository:

```shell
git clone https://github.com/gkapfham/dotfiles.git
```

Now, you can type `cd dotfiles` and start to browse the configuration files that
are available. I suggest that you make symbolic links from your home directory
to this repository if you want to maintain and use these configuration files.
For instance, if you use the `bibtool` program to manage your BibTeX files, then
if you were in your home directory, you would type the following command to
create the `.bibtoolrsc` as a symbolic link to the file in the
`~/configure/dotfiles/` directory containing this repository.

```shell
ln -s ~/configure/dotfiles/.bibtoolrsc .bibtoolrsc
```

It is worth noting that I use the `.vimrc` file to configure both `vim` and
`nvim`. To do this, I have created the `.nvim` directory to be a symbolic link
to the `.vim` directory. Next, this `.nvim` directory contains a file called
`init.vim` that is a symbolic link to the `~/.vimrc` file that is itself a
symbolic link to the `.vimrc` provided by this repository.

## Problems or Praise

If you have any problems with downloading or understanding these configuration
files, then please create an issue associated with this Git repository using
the "Issues" link at the top of this site. As the sole contributor to the
`dotfiles` repository, I will do everything possible to resolve your issue and
ensure that all of the configurations are clear and, potentially, best suited
to working in your development environment. Remember, this repository is being
made publicly available so as to provide examples of how to write
configurations for programs like `vim` and `nvim`. If you find that these files
help you in preparing your own configurations, then I also encourage you to
"star" and "watch" this project!
