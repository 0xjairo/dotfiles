-- Pull in the wezterm API
local wezterm = require("wezterm")

config = wezterm.config_builder()
if string.find(wezterm.target_triple, "windows") then
	config.default_prog = { "pwsh.exe", "-NoLogo" }
end

config.color_scheme = "Catppuccin Macchiato"
config.window_frame = {
	font = wezterm.font("FiraCode NF"),
	font_size = 9.0,
}
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.95
config.hide_tab_bar_if_only_one_tab = true
config.command_palette_font_size = 9.0

config.font = wezterm.font("FiraCode NF")
config.font_size = 9

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
