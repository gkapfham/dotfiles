-- create a new wezterm for configuration
local wezterm = require 'wezterm';
-- set all of the configuration values for wezterm
return {
  -- Use Hack Nerd Font as the main font and specify
  -- the Noto Color Emoji font as the fallback in the
  -- case in which Hack Nerd Font does not define
  font = wezterm.font_with_fallback({
    "Hack Nerd Font",
    "Noto Color Emoji"
  }),
  -- Set the font size which works consistently across
  -- all monitors and displays tested to date
  font_size = 16,
  -- Do not enable a scroll bar
  enable_tab_bar = false,
  -- Support scrolling back for 10,000 lines
  scrollback_lines = 10000,
  -- Define the color scheme to match Vitamin-Onec
  colors = {
      foreground = "#8a8a8a",
      background = "#1c1c1c",
      -- Overrides the cell background color when the current cell is occupied by the
      -- cursor and the cursor style is set to Block
      cursor_bg = "#8a8a8a",
      -- Specifies the border color of the cursor when the cursor style is set to Block,
      -- or the color of the vertical or horizontal bar when the cursor style is set to
      -- Bar or Underline.
      cursor_border = "#8a8a8a",
      -- Foreground color of selected text
      selection_fg = "black",
      -- Background color of selected text
      selection_bg = "#767676",
      -- Color of the scrollbar "thumb"; the portion that represents the current viewport
      scrollbar_thumb = "#222222",
      -- Color of the split lines between panes
      split = "#5f8700",
      -- Configure the non-bright and bright colors to be the same
      -- Standard eight colors at the non-bright level
      ansi = {"#767676", "#d78700", "#5f8700", "#afaf5f", "#87afd7", "#875f87", "#d75f5f", "#b2b2b2"},
      -- Standard eight colors at the bright level
      brights = {"#767676", "#d78700", "#5f8700", "#afaf5f", "#87afd7", "#875f87", "#d75f5f", "#b2b2b2"},
    },
  -- Do not have any window padding for the terminal window
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
    }
}
