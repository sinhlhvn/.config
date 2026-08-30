# Repository instructions

This repository is the user's `~/.config` directory. Only a subset is version-controlled; check `.gitignore` before editing a config. Edits to ignored files can still be useful locally, but clearly note that they will not be committed.

## Tracked configuration

- `nvim/` contains the main Neovim configuration. Follow `nvim/AGENTS.md` before changing anything in that tree.
- `wezterm/` contains the WezTerm configuration. Follow `wezterm/AGENTS.md` before changing anything in that tree.
- `karabiner/` contains only `assets/complex_modifications/`; the main `karabiner.json` is not tracked.
- `.gitignore` controls the intentionally machine-specific configuration excluded from version control.

## Ignored local configuration

- `htop/htoprc`, `git/ignore`, and `raycast/` are present locally but ignored.
- `htop/htoprc` is rewritten when htop exits; do not hand-edit it while htop is running.
- `git/ignore` is the user's global gitignore, referenced by `core.excludesfile`.

## Validation

There is no repository-wide build or test command. These are static configuration files consumed by their applications. For Lua under `nvim/`, run `stylua .` from `nvim/` before committing changes.

## Claude compatibility

Treat applicable `CLAUDE.md` files as repository guidance as well. If an `AGENTS.md` and `CLAUDE.md` in the same scope differ, flag the conflict rather than silently choosing one.
