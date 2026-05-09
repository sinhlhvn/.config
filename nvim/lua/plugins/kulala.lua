return {
  {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },
    opts = {
      global_keymaps = false,
      default_view = "body",
      ui = {
        max_response_size = 1024 * 1024,
      },
      kulala_keymaps = {
        ["Show headers"]            = { "<leader>kh", function() require("kulala.ui").show_headers() end },
        ["Show body"]               = { "<leader>kb", function() require("kulala.ui").show_body() end },
        ["Show headers and body"]   = { "<leader>ka", function() require("kulala.ui").show_headers_body() end },
        ["Show verbose"]            = { "<leader>kv", function() require("kulala.ui").show_verbose() end },
        ["Show script output"]      = { "<leader>ko", function() require("kulala.ui").show_script_output() end },
        ["Show stats"]              = { "<leader>ks", function() require("kulala.ui").show_stats() end },
        ["Show report"]             = { "<leader>kr", function() require("kulala.ui").show_report() end },
        ["Show filter"]             = { "<leader>kf", function() require("kulala.ui").toggle_filter() end },
        ["Clear responses history"] = { "<leader>kx", function() require("kulala.ui").clear_responses_history() end },
      },
    },
    keys = {
      { "<leader>R", "", desc = "+Rest (kulala)", ft = { "http", "rest" } },
      { "<leader>Rs", function() require("kulala").run() end, desc = "Send request", ft = { "http", "rest" } },
      { "<leader>Ra", function() require("kulala").run_all() end, desc = "Send all requests", ft = { "http", "rest" } },
      { "<leader>Rr", function() require("kulala").replay() end, desc = "Replay last request", ft = { "http", "rest" } },
      { "<leader>Rt", function() require("kulala").toggle_view() end, desc = "Toggle headers/body", ft = { "http", "rest" } },
      { "<leader>Ri", function() require("kulala").inspect() end, desc = "Inspect request", ft = { "http", "rest" } },
      { "<leader>Rc", function() require("kulala").copy() end, desc = "Copy as cURL", ft = { "http", "rest" } },
      { "<leader>RC", function() require("kulala").from_curl() end, desc = "Paste from cURL", ft = { "http", "rest" } },
      { "<leader>Rn", function() require("kulala").jump_next() end, desc = "Jump to next request", ft = { "http", "rest" } },
      { "<leader>Rp", function() require("kulala").jump_prev() end, desc = "Jump to previous request", ft = { "http", "rest" } },
      { "<leader>Rq", function() require("kulala").close() end, desc = "Close window", ft = { "http", "rest" } },
      { "<leader>RS", function() require("kulala").scratchpad() end, desc = "Open scratchpad", ft = { "http", "rest" } },
      { "<leader>Re", function() require("kulala").set_selected_env() end, desc = "Select environment", ft = { "http", "rest" } },
    },
  },
}
