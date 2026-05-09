# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository overview

This is the user's `~/.config` directory tracked as a git repo. It holds settings for several macOS tools (Neovim, Karabiner, htop, Raycast, git), but **only a subset is version-controlled** — see `.gitignore`: `htop/*`, `git/*`, and `raycast/*` are excluded because those tools rewrite their own files and the contents are machine-specific. In practice the tracked surface is `nvim/`, `karabiner/`, and `.gitignore`.

When asked to "edit a config", first check whether the target path is gitignored. If it is, edits are still useful to the user locally but won't be committed — call this out.

## Where the real content lives

Almost all non-trivial configuration is the Neovim setup under `nvim/`. **Read `nvim/CLAUDE.md` before touching anything in that tree** — it documents the LazyVim layout, the deliberate non-default behaviors (autoformat off, `jk`→`<Esc>`, dap-ui auto-open disabled, fzf-lua showing dotfiles), and the conventions for adding/overriding plugins. Don't duplicate or restate that file here; defer to it.

## Linting

- Lua (everything under `nvim/lua/`): `stylua .` from `nvim/` (config in `nvim/stylua.toml` — 2-space indent, 120 col). Run before committing Lua changes.

There is no project-wide build, test, or run step — these are static config files consumed by their respective applications at startup.

## Other tracked configs

- `karabiner/` — Karabiner-Elements. Only the `assets/complex_modifications/` subtree is present; the main `karabiner.json` is not tracked here.
- `nvim/.neoconf.json` — enables `neodev` so `lua_ls` resolves Neovim and plugin APIs while editing this config in Neovim itself.

## Untracked but present

`htop/htoprc`, `git/ignore`, and `raycast/` exist on disk but are gitignored. `htoprc` is rewritten by htop on exit — don't hand-edit while htop is running. `git/ignore` is the user's global gitignore (referenced by `core.excludesfile`).
