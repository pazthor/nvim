-- Description: User interface enhancements (bufferline, statusline, file tree, terminal)
-- Dependencies: bufferline.nvim, lualine.nvim, neo-tree.nvim, toggleterm.nvim
-- Keybindings: <leader>t* for terminal operations

local settings = require("core.settings")

return {
  -- Enhanced file tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    keys = {
      { "<leader>fe", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
      { "<leader>fE", function() require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() }) end, desc = "Explorer NeoTree (cwd)" },
      { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (root dir)", remap = true },
      { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
    },
    opts = {
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = settings.ignore_patterns,
          never_show = {
            ".DS_Store",
            "thumbs.db",
          },
        },
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        use_libuv_file_watcher = true,
      },
      buffers = {
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
      },
      git_status = {
        symbols = settings.ui.icons.git,
      },
    },
  },

  -- Enhanced buffer navigation
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete other buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete buffers to the right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete buffers to the left" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
    },
    opts = {
      options = vim.tbl_extend("force", settings.ui.buffer, {
        mode = "buffers",
        numbers = "ordinal",
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left",
          },
        },
        persist_buffer_sort = true,
        enforce_regular_tabs = false,
        sort_by = "id",
      }),
    },
  },

  -- Enhanced statusline with more info
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.sections = opts.sections or {}
      opts.sections.lualine_x = opts.sections.lualine_x or {}

      table.insert(opts.sections.lualine_x, {
        function()
          local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
          local clients = vim.lsp.get_active_clients()
          if next(clients) == nil then
            return "No LSP"
          end
          local client_names = {}
          for _, client in ipairs(clients) do
            if client.attached_buffers[vim.api.nvim_get_current_buf()] then
              table.insert(client_names, client.name)
            end
          end
          return table.concat(client_names, ", ")
        end,
        icon = " LSP:",
        color = { fg = "#ffffff", gui = "bold" },
      })
    end,
  },

  -- Enhanced terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Float terminal" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Horizontal terminal" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical size=80<cr>", desc = "Vertical terminal" },
    },
    config = function()
      require("toggleterm").setup(vim.tbl_extend("force", settings.terminal, {
        open_mapping = [[<c-\>]],
        shade_filetypes = {},
        shell = vim.o.shell,
      }))
    end,
  },
}

