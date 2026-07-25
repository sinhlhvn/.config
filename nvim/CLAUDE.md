# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository overview

A personal Neovim config built on the [LazyVim](https://github.com/LazyVim/LazyVim) starter template. `init.lua` does only one thing: `require("config.lazy")`. Everything else is loaded by lazy.nvim from the `lua/` tree.

## Layout and conventions

- `lua/config/lazy.lua` — bootstraps `lazy.nvim`, imports `LazyVim/LazyVim` first, then imports user plugins from the `plugins` directory. `defaults.lazy = false` is intentional: **user plugins under `lua/plugins/` are eager by default**, only LazyVim's own plugins are lazy. Set `lazy = true` per-spec if you want a user plugin to defer.
- `lua/config/options.lua`, `keymaps.lua`, `autocmds.lua` — loaded automatically by LazyVim (options before lazy startup; keymaps/autocmds on `VeryLazy`). Add overrides here, not in `init.lua`.
- `lua/plugins/*.lua` — every file is auto-imported as a lazy.nvim spec. Each returns a table (a single spec or list of specs). Use this directory to add plugins, override LazyVim plugin opts, or `enabled = false` to disable them.
- `lazyvim.json` — declarative list of LazyVim "extras" (`:LazyExtras` manages this). Editing the file directly is fine; restart and run `:Lazy sync`. `install_version` / `version` are LazyVim migration markers — don't hand-edit unless you know what you're doing.
- `lazy-lock.json` — pinned plugin commits. Commit changes to this file alongside plugin updates.
- `.neoconf.json` — enables `neodev` library so `lua_ls` knows about Neovim and plugin APIs when editing this config.

## Important non-default behaviors

- **Autoformat is OFF globally** (`vim.g.autoformat = false` in `options.lua`). Format-on-save will not run; use `<leader>cf` (or `:lua require("conform").format()`) to format manually. Don't re-enable without checking with the user.
- **`jk` is mapped to `<Esc>`** in insert mode (`keymaps.lua`).
- **`lua/plugins/dap.lua` replaces LazyVim's dap-ui `config`** so the listeners that auto-open/close dap-ui on session start/end are never registered. This is intentional — dap-ui is opened manually via `<leader>ds` (floating Scopes window; LazyVim's default `<leader>ds` Session mapping is disabled). Preserve this if you touch the dap config.
- **Conform formatter map** lives in `lua/plugins/conform.lua` (python→black, json/yaml/html/typescript/markdown→prettier, xml→xmlformat, http→kulala-fmt). Mason must have these tools installed; check with `:Mason`.
- **fzf-lua `files` picker** is configured with `hidden = true, git_ignore = false` — it shows dotfiles and gitignored files. Useful here, surprising elsewhere.
- **`lua/plugins/example.lua`** is the LazyVim sample file and short-circuits with `if true then return {} end`. It is documentation, not active config — don't "fix" it.

## Common tasks

- Plugin management: `:Lazy` (UI), `:Lazy sync`, `:Lazy update`, `:Lazy clean`. Restart Neovim after editing plugin specs.
- Extras: `:LazyExtras` to toggle entries in `lazyvim.json`.
- Tools/LSPs/formatters: `:Mason` (managed by `mason.nvim`).
- Formatter debugging: `:ConformInfo`.
- Lint Lua locally: `stylua .` (config in `stylua.toml`: 2-space indent, 120 col). Run before committing Lua changes.

## When adding a new plugin

Create a new file under `lua/plugins/` (one plugin or related group per file is the project convention) returning a lazy.nvim spec. To override an existing LazyVim plugin, return a spec with the same name and either an `opts` table (deep-merged) or an `opts = function(_, opts)` (mutate-and-return for lists like `ensure_installed`). See `lua/plugins/example.lua` for the full set of override patterns LazyVim supports.
