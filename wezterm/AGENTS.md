# WezTerm configuration instructions

This tracked folder configures WezTerm. Saving the configuration hot-reloads the running terminal.

## Layout and conventions

- `wezterm.lua` is the entry point and must return a config table.
- Always build it with `wezterm.config_builder()` so invalid keys surface as errors.
- Split larger concerns into named sibling Lua modules and load them with `require("name")`.
- Use the parent repository's Lua style: two-space indentation and a 120-column limit.

## Behavior and gotchas

- `config.keys` and `config.mouse_bindings` merge with defaults unless `disable_default_key_bindings = true`.
- Do not use `wezterm.gui.default_keys()` because `wezterm.gui` is unavailable outside the GUI process.
- Assigning `config.launch_menu` replaces the complete list.
- Prefer named event-handler functions; repeatedly registering new anonymous closures during reloads can accumulate handlers.
- Built-in `config.color_scheme` names must match exactly. Use `config.colors` for custom palettes.

## Validation and debugging

- Run `stylua .` from this directory before committing Lua changes.
- Saving reloads the config; on failure, WezTerm keeps the prior configuration active.
- Use `Ctrl+Shift+L` for reload errors and logs.
- Useful checks include `wezterm show-keys --lua`, `wezterm ls-fonts`, and `wezterm --config-file ./wezterm.lua start`.
