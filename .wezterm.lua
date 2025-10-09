local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- ==== your look & feel ====
config.colors = {
  foreground = "#CBE0F0",
  background = "#011423",
  cursor_bg = "#47FF9C",
  cursor_border = "#47FF9C",
  cursor_fg = "#011423",
  selection_bg = "#033259",
  selection_fg = "#CBE0F0",
  ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
  brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
}
config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 14
config.enable_tab_bar = true
config.window_decorations = "NONE"
config.window_background_opacity = 0.95

-- macOS blur only (harmless on Windows)
if wezterm.target_triple == "x86_64-apple-darwin" or wezterm.target_triple == "aarch64-apple-darwin" then
  config.macos_window_background_blur = 10
end

-- ==== open WSL:Ubuntu by default (recommended) ====
if wezterm.target_triple:find("windows") then
  config.wsl_domains = wezterm.default_wsl_domains()
  config.default_domain = "WSL:Ubuntu"
end

-- ctrl + shift + f for fullscreen
config.keys = {
  {
    key = 'f',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ToggleFullScreen,
  },
}


return config
