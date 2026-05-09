return {
  "ibhagwan/fzf-lua",
  opts = function(_, opts)
    opts.keymap = opts.keymap or {}
    opts.keymap.builtin = vim.tbl_extend("force", opts.keymap.builtin or {}, {
      ["<M-p>"] = "toggle-preview-behavior", -- ALT + p
      ["<M-l>"] = "toggle-preview-layout", -- ALT + l
      ["<M-w>"] = "toggle-preview-wrap", -- ALT + w

      ["<C-d>"] = "preview-page-down",
      ["<C-u>"] = "preview-page-up",
    })
    opts.files = vim.tbl_extend("force", opts.files or {}, {
      hidden = true,
      git_ignore = false,
    })

    return opts
  end,
}
