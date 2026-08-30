-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
vim.g.autoformat = false

vim.opt.title = true
vim.opt.titlestring = '%t%( %M%)%( (%{expand("%:~:.:h")})%) - nvim'

-- Give floating windows rounded corners by default. Plugins that request
-- their own border explicitly can still override this per window.
vim.opt.winborder = "rounded"

vim.opt.guicursor = {
  "n-v-c:block",
  "i-ci-ve:ver25",
  "r-cr:hor20",
  "o:hor50",
  "a:blinkon0",
}
