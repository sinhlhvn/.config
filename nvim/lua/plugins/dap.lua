return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      -- free up <leader>ds (LazyVim maps it to dap.session) for the Scopes float below
      { "<leader>ds", false },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    keys = {
      {
        "<leader>ds",
        function()
          require("dapui").float_element(
            "scopes",
            { title = "Scopes", position = "center", width = 120, height = 40, enter = true }
          )
        end,
        desc = "Scopes",
      },
    },
    -- replace LazyVim's config: it registers dap listeners that auto-open/close
    -- dap-ui on session start/end; we open it manually via <leader>ds instead
    config = function(_, opts)
      require("dapui").setup(opts)
    end,
  },
}
