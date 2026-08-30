-- `opts` is a function rather than a table because `offsets` is a list:
-- lazy.nvim would merge into LazyVim's entries by index instead of replacing
-- them, and LazyVim ships a neo-tree offset (neo-tree is not installed here)
-- plus a bare snacks one. Using a function also keeps LazyVim's own `config`,
-- which carries the session-restore fix.
return {
  "akinsho/bufferline.nvim",
  opts = function(_, opts)
    -- Preserve any theme-provided highlights and layer local choices on top.
    local base = opts.highlights
    opts.highlights = function(...)
      local hl = type(base) == "function" and base(...) or base or {}
      return vim.tbl_deep_extend("force", hl, {
        buffer_selected = {
          bold = true,
          italic = false,
        },
      })
    end

    opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
      mode = "buffers",
      numbers = "ordinal",
      indicator = { style = "icon" },
      -- "slope" keeps the tab shapes readable without the heavy filled wedge
      -- "slant" draws between every buffer.
      separator_style = "slope",
      show_buffer_icons = true,
      show_buffer_close_icons = false,
      show_close_icon = false,
      color_icons = true,
      always_show_bufferline = true,
      max_name_length = 18,
      max_prefix_length = 15,
      truncate_names = true,
      tab_size = 18,
      sort_by = "insert_after_current",
      persist_buffer_sort = true,
      diagnostics = "nvim_lsp",
      diagnostics_update_in_insert = false,
      diagnostics_indicator = function(count, level)
        local icon = level:match("error") and " " or " "
        return " " .. icon .. count
      end,
      hover = { enabled = true, delay = 200, reveal = { "close" } },
    })

    -- Single labelled offset for the snacks explorer.
    opts.options.offsets = {
      {
        filetype = "snacks_layout_box",
        text = "Explorer",
        highlight = "Directory",
        text_align = "left",
        separator = true,
      },
    }
  end,
}
