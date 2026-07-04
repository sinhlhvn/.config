# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Folder overview

Configuration for [WezTerm](https://wezterm.org/), a GPU-accelerated terminal emulator. WezTerm reads `~/.config/wezterm/wezterm.lua` (or `~/.wezterm.lua`) at startup and on every save — the running terminal hot-reloads config changes, so edits take effect immediately without restart.

This folder is **tracked by the parent repo** (not in `~/.config/.gitignore`).

## Layout convention

- `wezterm.lua` — the entry point. Must `return` a config table.
- Additional `*.lua` files at this level are pulled in via `require("name")` from `wezterm.lua` (no `.lua` extension in the require path). Group by concern (`keys.lua`, `appearance.lua`, `domains.lua`, etc.) once `wezterm.lua` gets unwieldy.

WezTerm prepends this folder to Lua's `package.path`, so `require("foo")` resolves to `~/.config/wezterm/foo.lua` automatically.

## Config skeleton

A minimal valid `wezterm.lua`:

```lua
local wezterm = require("wezterm")
local config = wezterm.config_builder() -- gives clearer error messages on bad keys
-- mutate config here
return config
```

Always use `wezterm.config_builder()` over a bare table — it validates keys at load time so typos surface as visible errors instead of being silently ignored.

## Editing and debugging

- **Reload:** save the file. WezTerm watches and reloads automatically. If a reload fails, the error appears in a debug overlay; previous config keeps running.
- **Debug overlay:** `Ctrl+Shift+L` (default) opens the log/debug pane — use it to see `wezterm.log_info(...)` output and reload errors.
- **Show all defaults / current values:** `wezterm show-keys --lua` (key tables), `wezterm ls-fonts` (resolved font fallback chain), `wezterm --config-file ./wezterm.lua start` (launch with this exact config for testing).
- **Lint Lua:** the parent repo's `nvim/stylua.toml` (2-space indent, 120 col) is the project-wide style. Run `stylua .` from this folder before committing.

## Gotchas

- `config.keys` (and `config.mouse_bindings`) are **merged with** the defaults — built-ins like copy/paste survive unless you set `disable_default_key_bindings = true`. Avoid `wezterm.gui.default_keys()` for this: `wezterm.gui` is `nil` outside the GUI process (e.g. under `wezterm-mux-server`), which breaks the whole config there.
- `config.launch_menu` is a plain list: assignment is a full replacement, not a merge.
- `wezterm.on("event-name", fn)` registers event handlers (e.g., `format-tab-title`, `update-status`). Re-`require`ing on reload re-registers — WezTerm dedupes by event+function identity, but anonymous closures on every reload will accumulate. Define handlers as named locals if you see duplicate firings.
- Color schemes set via `config.color_scheme = "Name"` must match a built-in scheme exactly; for custom palettes use `config.colors = { ... }` instead.
