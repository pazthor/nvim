return {
  {
    "otavioschwanck/recorder.nvim",
    opts = {},
  },
  {
    "folke/which-key.nvim",
    optional = true,
    config = function()
      require("shortcut_usage").setup()
    end,
    keys = {
      {
        "<leader>ur",
        function()
          require("shortcut_usage").show_recommendations()
        end,
        desc = "Show recommended shortcuts",
      },
    },
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      vim.list_extend(opts.spec, {
        { "<leader>ur", desc = "Show recommended shortcuts" },
      })
    end,
  },
}
