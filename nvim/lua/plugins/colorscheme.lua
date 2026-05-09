local function macos_is_dark()
  local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
  if not handle then
    return false
  end
  local result = handle:read("*a") or ""
  handle:close()
  return result:match("Dark") ~= nil
end

local function apply_system_theme()
  if macos_is_dark() then
    vim.o.background = "dark"
    vim.cmd.colorscheme("catppuccin-mocha")
  else
    vim.o.background = "light"
    vim.cmd.colorscheme("catppuccin-latte")
  end
end

vim.api.nvim_create_autocmd("FocusGained", {
  group = vim.api.nvim_create_augroup("auto_macos_theme", { clear = true }),
  callback = apply_system_theme,
})

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "auto",
      background = { light = "latte", dark = "mocha" },
      transparent_background = false,
      styles = {
        sidebars = "normal",
        floats = "normal",
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = apply_system_theme,
    },
  },
}
