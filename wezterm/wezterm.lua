local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Font: prefer a Nerd Font for icons in shells/editors, fall back gracefully.
config.font = wezterm.font_with_fallback({
	{ family = "JetBrainsMono Nerd Font", weight = "Regular" },
	{ family = "JetBrains Mono", weight = "Regular" },
	{ family = "FiraCode Nerd Font" },
	{ family = "Fira Code" },
	{ family = "Menlo" },
})
config.font_size = 14.0
config.line_height = 1.1
config.cell_width = 1.0
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" } -- ligatures on
config.freetype_load_target = "Light"
config.freetype_render_target = "Normal"

-- Theme: follow macOS appearance
local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Catppuccin Mocha"
	else
		return "Catppuccin Latte"
	end
end
config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())

-- Window
config.initial_cols = 140
config.initial_rows = 40
config.window_decorations = "RESIZE"
config.window_padding = { left = 12, right = 12, top = 8, bottom = 8 }
config.window_background_opacity = 1.0
config.macos_window_background_blur = 20
config.adjust_window_size_when_changing_font_size = false
config.native_macos_fullscreen_mode = true

-- Tab bar
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 32

-- Cursor
config.default_cursor_style = "SteadyBar"
config.cursor_blink_rate = 0
config.cursor_thickness = "2px"

-- Scrollback / performance
config.scrollback_lines = 20000
config.enable_scroll_bar = false
config.max_fps = 120
config.animation_fps = 60
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"

-- Shell behavior
config.audible_bell = "Disabled"
config.visual_bell = {
	fade_in_duration_ms = 75,
	fade_out_duration_ms = 75,
	target = "CursorColor",
}
config.exit_behavior = "Close"

-- Selection / clipboard
config.selection_word_boundary = " \t\n{}[]()\"'`,;:│"

return config
