return {
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    lazy = false,
    cmd = "ConformInfo",
    opts = {
      formatters_by_ft = {
        python = { "black" },
        json = { "prettier" },
        yaml = { "prettier" },
        html = { "prettier" },
        typescript = { "prettier" },
        markdown = { "prettier" },
        xml = { "xmlformat" },
        http = { "kulala-fmt" }
      },
    },
  },
}
