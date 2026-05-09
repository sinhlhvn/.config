-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
vim.g.autoformat = false

vim.opt.title = true
vim.opt.titlestring = '%t%( %M%)%( (%{expand("%:~:.:h")})%) - nvim'

vim.opt.guicursor = {
  "n-v-c:block",
  "i-ci-ve:ver25",
  "r-cr:hor20",
  "o:hor50",
  "a:blinkon0",
}
