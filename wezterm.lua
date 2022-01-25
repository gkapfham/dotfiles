local wezterm = require 'wezterm';
return {
  font = wezterm.font_with_fallback({
    "Hack Nerd Font",
    "Noto Color Emoji"
  }),
  font_size = 16,
  enable_tab_bar = false,
  scrollback_lines = 10000,
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
      split = "#444444",
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
