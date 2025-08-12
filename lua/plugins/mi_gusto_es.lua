return {

  {
    -- show dot files/ hidden files
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            hidden = true,
            show_ignored = true,
          },
        },
      },
    },
  },
}
