return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
  require("which-key").setup({})
    end,
  },
  {
    "chrisgrieser/nvim-recorder",
    dependencies = "rcarriga/nvim-notify", -- For nice notifications (optional)
    opts = {},
  },
}

