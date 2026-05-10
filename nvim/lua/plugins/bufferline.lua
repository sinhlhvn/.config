return {
  "akinsho/bufferline.nvim",
  opts = {
    highlights = {
      buffer_selected = {
        bold = true,
        italic = false,
      },
    },
    options = {
      mode = "buffers",
      numbers = "ordinal",
      indicator = { style = "icon" },
      separator_style = "slant",
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
      offsets = {
        {
          filetype = "neo-tree",
          text = "File Explorer",
          highlight = "Directory",
          separator = true,
        },
      },
    },
  },
}
