return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "black" },
        json = { "prettier" },
        yaml = { "prettier" },
        html = { "prettier" },
        typescript = { "prettier" },
        -- lists are replaced, not merged, so repeat what lazyvim's lang.markdown extra sets
        markdown = { "prettier", "markdownlint-cli2", "markdown-toc" },
        xml = { "xmlformat" },
        http = { "kulala-fmt" },
      },
    },
  },
}
