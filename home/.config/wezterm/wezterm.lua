-- Pull in the wezterm API
local wezterm = require("wezterm")
local config = wezterm.config_builder()
local font, font_size

if string.find(wezterm.target_triple, "windows") then
	-- font = "FiraCode NF"
	-- font_size = 9.0
	-- font = "SauceCodePro NF"
	-- font_size = 9
	-- font = "CaskaydiaCove NFM"
	-- font_size = 9
	font = "Monaspace Neon"
	font_size = 8

	-- windows specific options
	config.default_prog = { "pwsh.exe", "-NoLogo" }
	config.window_decorations = "RESIZE"

elseif string.find(wezterm.target_triple, "linux") then
	font = "FiraCode Nerd Font"
	font_size = 12.0
else
	font = nil
	font_size = nil
end

config.window_frame = {
	font = wezterm.font(font),
	font_size = font_size,
}

if font ~= nil then
	config.font = wezterm.font(font)
	config.font_size = font_size
end

config.animation_fps = 60
config.max_fps = 120

config.color_scheme = "Catppuccin Macchiato"
config.window_background_opacity = 0.95
config.hide_tab_bar_if_only_one_tab = true
config.command_palette_font_size = 9.0
config.use_fancy_tab_bar = true

config.initial_cols = 120
config.initial_rows = 30
config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.65,
}
config.visual_bell = {
	fade_in_function = "EaseIn",
	fade_in_duration_ms = 50,
	fade_out_function = "EaseOut",
	fade_out_duration_ms = 0,
}
config.colors = {
	visual_bell = "#404040",
}
config.scrollback_lines = 9999

local act = wezterm.action
config.keys = {
	{
		key = "j",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		key = "k",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "h",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "l",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "u",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitVertical({ domain = { DomainName = "WSL:Ubuntu-20.04" } }),
	},
	{ key = "UpArrow", mods = "SHIFT", action = wezterm.action.ScrollToPrompt(-1) },
	{ key = "DownArrow", mods = "SHIFT", action = wezterm.action.ScrollToPrompt(1) },
}

config.mouse_bindings = {
	{
		event = { Down = { streak = 3, button = "Left" } },
		action = wezterm.action.SelectTextAtMouseCursor("SemanticZone"),
		mods = "NONE",
	},
}

return config
