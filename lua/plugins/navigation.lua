-- Description: File and code navigation tools (Telescope, Harpoon, file browsers)
-- Dependencies: telescope.nvim, harpoon, plenary.nvim
-- Keybindings: <leader>f* for file operations, <leader>h* for harpoon

local keymaps = require("utils.keymaps")
local settings = require("core.settings")

return {
  -- Enhanced file search and navigation
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-project.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
    keys = {
      { "<leader>fp", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fw", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>fs", "<cmd>Telescope grep_string<cr>", desc = "Grep string" },
      { "<leader>fS", "<cmd>Telescope symbols<cr>", desc = "Symbols" },
      { "<leader>fm", "<cmd>Telescope marks<cr>", desc = "Marks" },
      { "<leader>fj", "<cmd>Telescope jumplist<cr>", desc = "Jumplist" },
      { "<leader>fl", "<cmd>Telescope loclist<cr>", desc = "Location list" },
      { "<leader>fq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix" },
      { "<leader>fe", "<cmd>Telescope file_browser<cr>", desc = "File browser" },
      { "<leader>fP", "<cmd>Telescope project<cr>", desc = "Projects" },
      { "<leader>pc", function() require("project_manager").close_project() end, desc = "Close project" },
      { "<leader>po", function() require("project_manager").open_project() end, desc = "Open project" },
      { "<leader>ps", function() require("project_manager").switch_project() end, desc = "Switch project" },
    },
    opts = {
      defaults = settings.telescope.defaults,
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        file_browser = {
          hijack_netrw = true,
          hidden = false,
        },
        project = {
          base_dirs = settings.project.base_dirs,
          hidden_files = false,
          on_project_selected = function(prompt_bufnr)
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")
            
            local selection = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            
            if selection then
              -- Change to project directory
              vim.cmd("cd " .. selection.value)
              
              -- Try to load session
              local session_path = vim.fn.stdpath("data") .. "/sessions/" .. 
                                 selection.value:gsub("/", "_"):gsub("^_", "") .. ".vim"
              if vim.fn.filereadable(session_path) == 1 then
                vim.cmd("source " .. session_path)
                vim.notify("Session loaded: " .. vim.fn.fnamemodify(session_path, ":t"))
              else
                -- If no session, open file explorer
                vim.defer_fn(function()
                  vim.cmd("Telescope find_files")
                end, 100)
              end
            end
          end,
        },
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({}),
        },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("fzf")
      telescope.load_extension("file_browser")
      telescope.load_extension("project")
      telescope.load_extension("ui-select")
    end,
  },

  -- Enhanced fuzzy finder
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },

  -- File browser
  {
    "nvim-telescope/telescope-file-browser.nvim",
  },

  -- Project management
  {
    "nvim-telescope/telescope-project.nvim",
  },

  -- UI select replacement
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },

  -- Enhanced navigation with Harpoon
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>ha",
        function()
          require("harpoon"):list():add()
        end,
        desc = "Harpoon add file",
      },
      {
        "<leader>hh",
        function()
          require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
        end,
        desc = "Harpoon quick menu",
      },
      {
        "<leader>h1",
        function()
          require("harpoon"):list():select(1)
        end,
        desc = "Harpoon file 1",
      },
      {
        "<leader>h2",
        function()
          require("harpoon"):list():select(2)
        end,
        desc = "Harpoon file 2",
      },
      {
        "<leader>h3",
        function()
          require("harpoon"):list():select(3)
        end,
        desc = "Harpoon file 3",
      },
      {
        "<leader>h4",
        function()
          require("harpoon"):list():select(4)
        end,
        desc = "Harpoon file 4",
      },
      {
        "<leader>hp",
        function()
          require("harpoon"):list():prev()
        end,
        desc = "Harpoon prev",
      },
      {
        "<leader>hn",
        function()
          require("harpoon"):list():next()
        end,
        desc = "Harpoon next",
      },
    },
    config = function()
      require("harpoon"):setup()
    end,
  },

  -- Better quickfix
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = function()
      require("bqf").setup({
        auto_enable = true,
        auto_resize_height = true,
        preview = {
          win_height = 12,
          win_vheight = 12,
          delay_syntax = 80,
          border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
        },
        func_map = {
          vsplit = "",
          ptogglemode = "z,",
          stoggleup = "",
        },
        filter = {
          fzf = {
            action_for = { ["ctrl-s"] = "split" },
            extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
          },
        },
      })
    end,
  },

  -- Enhanced search and replace
  {
    "nvim-pack/nvim-spectre",
    build = false,
    cmd = "Spectre",
    keys = {
      {
        "<leader>sr",
        function()
          require("spectre").open()
        end,
        desc = "Replace in files (Spectre)",
      },
      {
        "<leader>sw",
        function()
          require("spectre").open_visual({ select_word = true })
        end,
        desc = "Search current word",
      },
      {
        "<leader>sp",
        function()
          require("spectre").open_file_search({ select_word = true })
        end,
        desc = "Search in current file",
      },
    },
    config = function()
      require("spectre").setup()
    end,
  },
}