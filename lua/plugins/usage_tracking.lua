return {
  -- Keystroke logging and heatmaps

  {
    "glottologist/keylog.nvim",
    opts = {},
    keys = {
      { "<leader>tk", "<cmd>Keylog toggle<cr>", desc = "Toggle Keylog" },
      { "<leader>tc", "<cmd>Keylog clear<cr>", desc = "Clear Keylog" },
    },
  },

  -- Usage tracking for time and keystroke counts per file/project
  {
    "gaborvecsei/usage-tracker.nvim",
    lazy = false,
    config = function()
      require("usage-tracker").setup({
        keep_eventlog_days = 14,
        cleanup_freq_days = 7,
        event_wait_period_in_sec = 5,
        inactivity_threshold_in_min = 5,
        inactivity_check_freq_in_sec = 5,
        verbose = 0,
        telemetry_endpoint = "", -- Disable telemetry
      })
    end,
    keys = {
      { "<leader>ut", "<cmd>UsageTrackerShowDailyAggregation<cr>", desc = "Show daily usage stats" },
      { "<leader>uw", "<cmd>UsageTrackerShowAgg filepath<cr>", desc = "Show usage by files" },
      { "<leader>um", "<cmd>UsageTrackerShowFilesLifetime<cr>", desc = "Show lifetime file stats" },
      { "<leader>uf", "<cmd>UsageTrackerShowVisitLog<cr>", desc = "Show visit log" },
    },
  },

  -- Telescope extension for frequently accessed files
  {
    "nvim-telescope/telescope-frecency.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("frecency")
    end,
    keys = {
      { "<leader>fr", "<cmd>Telescope frecency<cr>", desc = "Recent files (frecency)" },
      { "<leader>fF", "<cmd>Telescope frecency workspace=CWD<cr>", desc = "Frequent files (current dir)" },
    },
  },

  -- Enhanced which-key integration for usage tracking
  {
    "folke/which-key.nvim",
    optional = true,
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      vim.list_extend(opts.spec, {
        { "<leader>u", group = "usage tracking" },
        { "<leader>uk", desc = "Toggle keylog" },
        { "<leader>uh", desc = "Show keystroke heatmap" },
        { "<leader>us", desc = "Show keystroke stats" },
        { "<leader>ut", desc = "Show daily usage stats" },
        { "<leader>uw", desc = "Show usage by files" },
        { "<leader>um", desc = "Show lifetime file stats" },
        { "<leader>uf", desc = "Show visit log" },
      })
    end,
  },
}

