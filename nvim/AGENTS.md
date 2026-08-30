# Neovim configuration instructions

This is a personal Neovim configuration based on the LazyVim starter. `init.lua` should only load `config.lazy`; put configuration in the existing `lua/` structure.

## Layout and conventions

- `lua/config/lazy.lua` bootstraps lazy.nvim and imports user specs from `lua/plugins/`. `defaults.lazy = false` is intentional, so user plugins are eager unless a spec explicitly sets `lazy = true`.
- Put options, keymaps, and autocommands in `lua/config/options.lua`, `keymaps.lua`, and `autocmds.lua`; do not add them to `init.lua`.
- Each `lua/plugins/*.lua` file is auto-imported as a lazy.nvim spec. Use these files to add plugins or override/disable LazyVim plugins.
- `lazyvim.json` contains LazyVim extras. Do not hand-edit its migration markers unless necessary.
- Commit `lazy-lock.json` changes alongside plugin updates.
- `.neoconf.json` enables Neovim/plugin API resolution for `lua_ls`.

## Preserve intentional behavior

- Global autoformat is disabled in `options.lua`. Do not re-enable it without asking the user.
- Insert-mode `jk` maps to `<Esc>`.
- `lua/plugins/dap.lua` intentionally prevents dap-ui from opening and closing automatically. Preserve manual opening through `<leader>ds` and keep LazyVim's default Session mapping disabled.
- Formatter mappings live in `lua/plugins/conform.lua`; Mason must provide the configured tools.
- The fzf-lua files picker intentionally shows dotfiles and gitignored files with `hidden = true` and `git_ignore = false`.
- `lua/plugins/example.lua` is inactive sample documentation. Do not remove its early return or treat it as active configuration.

## Adding plugins

Add one plugin or related group per file under `lua/plugins/`. Override an existing LazyVim plugin with the same plugin name and either a deep-merged `opts` table or an `opts = function(_, opts)` callback for list mutation. Use `lua/plugins/example.lua` as the local reference for supported patterns.

## Validation and operations

- Run `stylua .` from this directory after Lua edits. The style is two-space indentation and a 120-column limit.
- Use `:Lazy` / `:Lazy sync` for plugins, `:LazyExtras` for extras, `:Mason` for tools, and `:ConformInfo` for formatter debugging.
- Restart Neovim after changing plugin specs.
