return {
  {
    "Mofiqul/dracula.nvim",
    priority = 1000,
    opts = {
      -- Let WezTerm control the actual opacity for the editor and Snacks.
      transparent_bg = true,
      show_end_of_buffer = false,
      italic_comment = true,
      lualine_bg_color = "#21222c",
      overrides = {
        -- Snacks links its window backgrounds to NormalFloat. Keeping these
        -- backgrounds unset lets WezTerm's opacity show through consistently.
        WinSeparator = { fg = "#44475a" },
        NormalFloat = { bg = "NONE" },
        FloatBorder = { fg = "#6272a4", bg = "NONE" },
        FloatTitle = { fg = "#bd93f9", bg = "NONE", bold = true },

        Pmenu = { bg = "#21222c", fg = "#f8f8f2" },
        PmenuSel = { bg = "#44475a", bold = true },

        CursorLine = { bg = "#44475a" },
        CursorLineNr = { fg = "#bd93f9", bold = true },
        LineNr = { fg = "#6272a4" },

        DiagnosticUnderlineError = { undercurl = true, sp = "#ff5555" },
        DiagnosticUnderlineWarn = { undercurl = true, sp = "#f1fa8c" },
        DiagnosticUnderlineInfo = { undercurl = true, sp = "#8be9fd" },
        DiagnosticUnderlineHint = { undercurl = true, sp = "#50fa7b" },
        DiagnosticUnderlineOk = { undercurl = true, sp = "#50fa7b" },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "dracula",
    },
  },
}
