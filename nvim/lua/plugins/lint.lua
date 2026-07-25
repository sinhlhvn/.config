return {
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      -- deep merge keeps lazyvim's lang.markdown entry, so clear it explicitly
      opts.linters_by_ft.markdown = {}
      return opts
    end,
  },
}
