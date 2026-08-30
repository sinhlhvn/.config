local wezterm = require("wezterm")
local config = wezterm.config_builder()
local theme_controller = wezterm.home_dir .. "/.config/theme/apply-theme"
local theme_state_dir = (os.getenv("XDG_STATE_HOME") or (wezterm.home_dir .. "/.local/state")) .. "/terminal-theme"

-- Font: prefer a Nerd Font for icons in shells/editors, fall back gracefully.
config.font = wezterm.font_with_fallback({
  { family = "JetBrains Mono", weight = "Regular" },
  { family = "Symbols Nerd Font Mono", weight = "Regular" },
  "Apple Color Emoji",
})
config.font_size = 14.0
config.line_height = 1.1
config.cell_width = 1.0
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" } -- ligatures on
config.freetype_load_target = "Light"
config.freetype_render_target = "Normal"

-- Keep the palette exact: without this, bold text is remapped to the bright
-- ANSI colours and washes out Dracula's carefully-tuned contrast.
config.bold_brightens_ansi_colors = "No"

-- Undercurls/underlines from LSP diagnostics: thicker and pushed off the
-- baseline so they stay readable at 14pt with line_height 1.1.
config.underline_thickness = "1.5pt"
config.underline_position = "-3pt"

-- Keyboard: Option trái = Meta (cho Herdr prefix+alt+..., Option+Enter trong
-- Claude Code/Codex). Option phải giữ mặc định compose để còn gõ được ø π ´ ˆ ˜.
config.send_composed_key_when_left_alt_is_pressed = false

-- ---------------------------------------------------------------------------
-- Theme
--
-- One table per appearance so the tab bar, window frame, cursor, selection and
-- command palette all move together. Anything not listed here comes from the
-- Dracula scheme itself.
-- ---------------------------------------------------------------------------
local themes = {
  dark = {
    scheme = "Dracula (Official)",
    palette = {
      base = "#282a36",
      mantle = "#21222c",
      crust = "#191a21",
      surface0 = "#343746",
      surface1 = "#44475a",
      surface2 = "#6272a4",
      overlay0 = "#6272a4",
      subtext0 = "#bfbfbf",
      text = "#f8f8f2",
      accent = "#bd93f9",
      cursor = "#f8f8f2",
      cursor_fg = "#282a36",
      compose = "#ff79c6",
    },
  },
  light = {
    scheme = "Dracula (Official)",
    palette = {
      base = "#282a36",
      mantle = "#21222c",
      crust = "#191a21",
      surface0 = "#343746",
      surface1 = "#44475a",
      surface2 = "#6272a4",
      overlay0 = "#6272a4",
      subtext0 = "#bfbfbf",
      text = "#f8f8f2",
      accent = "#bd93f9",
      cursor = "#f8f8f2",
      cursor_fg = "#282a36",
      compose = "#ff79c6",
    },
  },
}

local function read_file(path)
  local file = io.open(path, "r")
  if not file then
    return nil
  end
  local value = file:read("*l")
  file:close()
  return value
end

local function system_mode()
  local ok, appearance = pcall(function()
    return wezterm.gui.get_appearance()
  end)
  return ok and appearance:find("Light") and "light" or "dark"
end

local function saved_override()
  local mode = read_file(theme_state_dir .. "/mode")
  local override = read_file(theme_state_dir .. "/override")
  if override == "manual" and themes[mode] then
    return mode
  end
end

--- Full set of appearance settings for one theme. Returned as a table so the
--- same values can seed the base config and the Ctrl+Shift+D overrides.
---@param mode "dark"|"light"
local function theme_settings(mode)
  local t = themes[mode]
  local p = t.palette

  return {
    color_scheme = t.scheme,

    colors = {
      -- Keep terminal defaults explicit. Full-screen TUIs inherit/query these
      -- colours independently from WezTerm's tab and window chrome.
      background = p.base,
      foreground = p.text,
      cursor_bg = p.cursor,
      cursor_fg = p.cursor_fg,
      cursor_border = p.cursor,
      compose_cursor = p.compose,

      selection_bg = p.surface1,
      selection_fg = p.text,

      -- Divider between wezterm's own splits (herdr draws its own borders).
      split = p.surface0,
      scrollbar_thumb = p.surface1,
      visual_bell = p.surface0,

      tab_bar = {
        background = p.crust,
        active_tab = {
          bg_color = p.base,
          fg_color = p.text,
          intensity = "Bold",
        },
        inactive_tab = {
          bg_color = p.mantle,
          fg_color = p.overlay0,
        },
        inactive_tab_hover = {
          bg_color = p.surface0,
          fg_color = p.subtext0,
          italic = false,
        },
        new_tab = {
          bg_color = p.crust,
          fg_color = p.overlay0,
        },
        new_tab_hover = {
          bg_color = p.surface0,
          fg_color = p.text,
        },
        inactive_tab_edge = p.crust,
      },
    },

    -- The fancy tab bar is a native window frame: without these it renders in
    -- macOS' own grey and visibly clashes with the dark terminal body.
    window_frame = {
      font = wezterm.font_with_fallback({
        { family = "SF Pro Text", weight = "Medium" }, -- not exposed by name on every macOS
        { family = "Helvetica Neue", weight = "Medium" },
        { family = "JetBrains Mono", weight = "Medium" },
      }),
      font_size = 12.0,
      active_titlebar_bg = p.crust,
      inactive_titlebar_bg = p.crust,
      active_titlebar_fg = p.text,
      inactive_titlebar_fg = p.overlay0,
      active_titlebar_border_bottom = p.crust,
      inactive_titlebar_border_bottom = p.crust,
      button_fg = p.subtext0,
      button_bg = p.crust,
      button_hover_fg = p.text,
      button_hover_bg = p.surface0,
    },

    command_palette_bg_color = p.mantle,
    command_palette_fg_color = p.text,
  }
end

-- A persisted manual mode wins so terminal chrome cannot flip independently
-- from dark-first TUIs such as Codex; Ctrl+Shift+A returns to macOS control.
local initial_mode = saved_override() or system_mode()
for k, v in pairs(theme_settings(initial_mode)) do
  config[k] = v
end

local function apply_window_theme(window, mode)
  local overrides = window:get_config_overrides() or {}
  for k, v in pairs(theme_settings(mode)) do
    overrides[k] = v
  end
  window:set_config_overrides(overrides)
end

-- Manual toggle. The controller propagates the semantic mode to Herdr and to
-- Neovim instances that belong to this Herdr server.
local function toggle_theme(window)
  local overrides = window:get_config_overrides() or {}
  local current = overrides.color_scheme or themes[initial_mode].scheme
  local next_mode = current == themes.dark.scheme and "light" or "dark"
  apply_window_theme(window, next_mode)
  wezterm.background_child_process({ theme_controller, next_mode, "--manual" })
end
wezterm.on("toggle-theme", toggle_theme)

-- Return to macOS-controlled appearance and clear the persisted override.
local function use_system_theme(window)
  local mode = system_mode()
  window:set_config_overrides({})
  wezterm.background_child_process({ theme_controller, mode, "--auto" })
end
wezterm.on("use-system-theme", use_system_theme)

-- WezTerm reloads its GUI config when macOS appearance changes. Reconcile the
-- downstream applications after the new base theme has been selected. A saved
-- manual override wins until Ctrl+Shift+A clears it.
local function reconcile_theme()
  wezterm.background_child_process({ theme_controller, initial_mode, saved_override() and "--manual" or "--auto" })
end
wezterm.on("window-config-reloaded", reconcile_theme)

-- Window
config.initial_cols = 140
config.initial_rows = 40
config.window_decorations = "RESIZE"
config.window_padding = { left = 12, right = 12, top = 8, bottom = 8 }
-- Keep enough opacity for text-heavy TUIs while letting macOS blur add a
-- restrained sense of depth behind the terminal canvas.
config.window_background_opacity = 0.96
config.macos_window_background_blur = 20
config.adjust_window_size_when_changing_font_size = false
config.native_macos_fullscreen_mode = true

-- Dim wezterm's own unfocused splits. Harmless when herdr owns the layout.
config.inactive_pane_hsb = { saturation = 0.9, brightness = 0.7 }

-- A flat tab strip matches Herdr's terminal-native chrome and avoids stacking
-- a macOS-style title bar above another workspace/tab hierarchy.
config.use_fancy_tab_bar = false
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

-- Key bindings (merged with defaults, so built-ins like copy/paste are preserved)
config.keys = {
  { key = "d", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("toggle-theme") },
  { key = "a", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("use-system-theme") },
}

return config
