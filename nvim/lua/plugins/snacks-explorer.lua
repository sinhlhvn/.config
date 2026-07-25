-- Paste a screenshot into the explorer's current directory.
--
-- Works with both macOS screenshot styles:
--   * Ctrl+Cmd+Shift+4 -> image on the clipboard, read via `pngpaste`
--   * Cmd+Shift+4      -> image saved as a file, picked up from the screenshot
--                         folder if it is recent enough
--
-- Requires `pngpaste` (brew install pngpaste) for the clipboard path.

-- Recent screenshot files are moved, not copied, so the screenshot folder does
-- not accumulate leftovers. Set to false to copy instead.
local MOVE_FILE = true

-- Only fall back to a screenshot file this many seconds old, so an old image
-- is never grabbed by surprise.
local MAX_AGE = 120

---@return string
local function screenshot_dir()
  local out = vim.system({ "defaults", "read", "com.apple.screencapture", "location" }):wait()
  local dir = out.code == 0 and vim.trim(out.stdout or "") or ""
  if dir == "" then
    dir = "~/Desktop" -- macOS default when no location is set
  end
  return vim.fs.normalize(dir)
end

--- Newest .png in the screenshot folder, if it was written in the last MAX_AGE seconds.
---@return string?
local function recent_screenshot()
  local dir = screenshot_dir()
  local fs = vim.uv.fs_scandir(dir)
  if not fs then
    return nil
  end
  local newest, newest_at
  while true do
    local name = vim.uv.fs_scandir_next(fs)
    if not name then
      break
    end
    if name:lower():match("%.png$") then
      local path = dir .. "/" .. name
      local stat = vim.uv.fs_stat(path)
      if stat and stat.type == "file" and (not newest_at or stat.mtime.sec > newest_at) then
        newest, newest_at = path, stat.mtime.sec
      end
    end
  end
  if newest and os.time() - newest_at <= MAX_AGE then
    return newest
  end
end

--- Write the clipboard image to `path`. Returns true on success.
---@param path string
---@return boolean
local function from_clipboard(path)
  if vim.fn.executable("pngpaste") == 0 then
    return false
  end
  -- pngpaste exits non-zero when the clipboard holds no image
  if vim.system({ "pngpaste", path }):wait().code ~= 0 then
    vim.fn.delete(path)
    return false
  end
  return vim.uv.fs_stat(path) ~= nil
end

local function paste_image(picker)
  local src = recent_screenshot()
  local dir = picker:dir()

  local hint = src and (" (from " .. vim.fs.basename(src) .. ")") or " (from clipboard)"
  Snacks.input({
    prompt = "Paste image as" .. hint,
    default = os.date("screenshot-%Y%m%d-%H%M%S.png"),
  }, function(name)
    if not name or name:find("^%s*$") then
      return
    end
    if not name:lower():match("%.png$") then
      name = name .. ".png"
    end

    local path = vim.fs.normalize(dir .. "/" .. name)
    if vim.uv.fs_stat(path) then
      Snacks.notify.warn("File already exists:\n- `" .. path .. "`")
      return
    end

    -- Prefer the clipboard; fall back to a recent screenshot file.
    if not from_clipboard(path) then
      if not src then
        Snacks.notify.error(
          "No image in clipboard, and no screenshot newer than " .. MAX_AGE .. "s in\n- `" .. screenshot_dir() .. "`"
        )
        return
      end
      local ok, err = vim.uv.fs_copyfile(src, path)
      if not ok then
        Snacks.notify.error("Could not copy screenshot:\n- `" .. tostring(err) .. "`")
        return
      end
      if MOVE_FILE then
        vim.fn.delete(src)
      end
    end

    picker:action("explorer_update")
    Snacks.notify.info("Pasted image:\n- `" .. path .. "`")
  end)
end

-- Make git-ignored entries visually distinct instead of sharing the default
-- NonText dimming with plain hidden files. Ignored files/dirs get their own
-- muted colour + italics, and the git-status column keeps its `!`/ignore
-- icon. Re-applied on colorscheme change so it survives theme switches.
local function set_ignored_hl()
  vim.api.nvim_set_hl(0, "SnacksPickerPathIgnored", { link = "SnacksExplorerIgnored" })
  vim.api.nvim_set_hl(0, "SnacksPickerGitStatusIgnored", { link = "SnacksExplorerIgnored" })
  vim.api.nvim_set_hl(0, "SnacksExplorerIgnored", { fg = "#7a6a3a", italic = true })
end
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_ignored_hl })

return {
  "folke/snacks.nvim",
  init = set_ignored_hl,
  opts = {
    picker = {
      sources = {
        explorer = {
          -- Always show git-ignored files (and dotfiles) in the explorer.
          ignored = true,
          hidden = true,
          actions = { explorer_paste_image = paste_image },
          -- `p` is explorer_paste and `P` is toggle_preview, so use `gp`
          win = { list = { keys = { ["gp"] = "explorer_paste_image" } } },
        },
      },
    },
  },
}
