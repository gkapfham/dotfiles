# PLAN

## New Tasks

## Finished Tasks

## Use the ck command-line program to implement a custom snacks picker for nvim

I currently using snacks.nvim pickers.

I would like to build a new add-on to a picker.

The purpose of this add-on would be to allow me to either:

- Visually select a region of code
- Type in words into the snacks picker prompt

And, then use a very simple algorithm for text classification
with compression to find the other files in the current
directory structure that are similar to the provided text.

You can think of this as a simple "semantic search" that
works for Neovim buffers and files with Snacks.nvim.

I am not an expert lua programmer.

I want you to add the required functions and mappings to
the following file:

nvim/lua/plugins/snacking.lua:1-10

-- File: plugins/snacking.lua
-- Purpose: load and configure the snacks.nvim plugin

return {

-- snacks.nvim
-- small improvements to the user interface,
-- including pickers for numerous elements,
-- a terminal window, and a file explorer
{

This is only a small excerpt of the file.

You need to add all the needed code and mappings.

You must follow all the rules and regulations in the
AGENTS.md file.

Here is an online web article that talks about how
this works inside of Python:

https://maxhalford.github.io/blog/text-classification-zstd/

This is the research project and GitHub repository that
started all of the work in this area:

https://github.com/bazingagin/npc_gzip

You need to:

- Get it to work with only lua and as a neovim extension/plugin
  as a snacks picker.
- Confirm that it is fast enough at least for this repository.
- Consider ways to build the lua code as a stand-alone program
  so that you can test it and then integrate it as a snacks picker.

I am available to run the commands as long as you tell me how
to use this new picker inside of Neovim.
