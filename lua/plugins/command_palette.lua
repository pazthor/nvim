return {
  -- Enhanced which-key for command discovery
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>?", function() require("which-key").show() end, desc = "Show all commands" },
      { "<leader><leader>", function() require("which-key").show() end, desc = "Command palette" },
      { "<F1>", function() require("which-key").show() end, desc = "Help - Show commands" },
    },
    opts = {
      preset = "modern",
      delay = 200,
      expand = 1,
      notify = false,
      triggers = {
        { "<leader>", mode = { "n", "v" } },
        { "<c-w>", mode = { "n" } },
        { "g", mode = { "n", "v" } },
        { "z", mode = { "n", "v" } },
        { "]", mode = { "n", "v" } },
        { "[", mode = { "n", "v" } },
        { "<c-r>", mode = "i" },
        { "<c-x>", mode = "i" },
      },
      spec = {
        -- Main leader groups
        { "<leader>f", group = "Find/Search" },
        { "<leader>g", group = "Git" },
        { "<leader>c", group = "Code" },
        { "<leader>x", group = "Diagnostics/Quickfix" },
        { "<leader>s", group = "Search/Replace" },
        { "<leader>u", group = "Usage Tracking/UI" },
        { "<leader>w", group = "Windows" },
        { "<leader>b", group = "Buffers" },
        { "<leader>t", group = "Terminal" },
        { "<leader>h", group = "Harpoon" },
        { "<leader>n", group = "NPM/Package" },
        { "<leader>l", group = "Laravel" },
        { "<leader>d", group = "Database/Debug" },
        { "<leader>r", group = "Run" },
        { "<leader>q", group = "Quit/Session" },
        { "<leader>p", group = "Project" },
        
        -- File operations
        { "<leader>fp", desc = "Find files" },
        { "<leader>fw", desc = "Live grep (search in files)" },
        { "<leader>fb", desc = "Find buffers" },
        { "<leader>fr", desc = "Recent files" },
        { "<leader>fh", desc = "Help tags" },
        { "<leader>fc", desc = "Commands" },
        { "<leader>fk", desc = "Keymaps" },
        { "<leader>fs", desc = "Grep string under cursor" },
        { "<leader>fS", desc = "Symbols" },
        { "<leader>fm", desc = "Marks" },
        { "<leader>fj", desc = "Jumplist" },
        { "<leader>fl", desc = "Location list" },
        { "<leader>fq", desc = "Quickfix" },
        { "<leader>fe", desc = "File browser" },
        { "<leader>fP", desc = "Projects" },
        
        -- Project operations
        { "<leader>pc", desc = "Close current project" },
        { "<leader>po", desc = "Open project" },
        { "<leader>ps", desc = "Switch project" },
        
        -- Harpoon
        { "<leader>ha", desc = "Add file to harpoon" },
        { "<leader>hh", desc = "Harpoon quick menu" },
        { "<leader>h1", desc = "Harpoon file 1" },
        { "<leader>h2", desc = "Harpoon file 2" },
        { "<leader>h3", desc = "Harpoon file 3" },
        { "<leader>h4", desc = "Harpoon file 4" },
        { "<leader>hp", desc = "Harpoon previous" },
        { "<leader>hn", desc = "Harpoon next" },
        
        -- Terminal
        { "<leader>tt", desc = "Toggle terminal" },
        { "<leader>tf", desc = "Float terminal" },
        { "<leader>th", desc = "Horizontal terminal" },
        { "<leader>tv", desc = "Vertical terminal" },
        
        -- Search and replace
        { "<leader>sr", desc = "Search and replace (Spectre)" },
        { "<leader>sw", desc = "Search current word" },
        { "<leader>sp", desc = "Search in current file" },
        
        -- NPM/Package management
        { "<leader>ns", desc = "Show package info" },
        { "<leader>nc", desc = "Hide package info" },
        { "<leader>nt", desc = "Toggle package info" },
        { "<leader>nu", desc = "Update package" },
        { "<leader>nd", desc = "Delete package" },
        { "<leader>ni", desc = "Install package" },
        { "<leader>np", desc = "Change package version" },
        
        -- Laravel
        { "<leader>la", desc = "Laravel artisan commands" },
        { "<leader>lr", desc = "Laravel routes" },
        { "<leader>lm", desc = "Laravel related files" },
        
        -- Database operations
        { "<leader>db", desc = "Toggle database UI" },
        { "<leader>do", desc = "Open database UI" },
        { "<leader>dc", desc = "Close database UI" },
        { "<leader>de", desc = "Execute database query" },
        { "<leader>dE", desc = "Execute selected query" },
        { "<leader>dr", desc = "Refresh DDEV connections" },
        { "<leader>dR", desc = "DDEV debug test" },
        
        -- Code folding
        { "zR", desc = "Open all folds" },
        { "zM", desc = "Close all folds" },
        { "zr", desc = "Open folds except kinds" },
        { "zm", desc = "Close folds with" },
        { "zK", desc = "Peek folded lines" },
        
        -- Git (from LazyVim)
        { "<leader>gg", desc = "Lazygit" },
        { "<leader>gb", desc = "Git blame" },
        { "<leader>gB", desc = "Git browse" },
        { "<leader>gf", desc = "Git file history" },
        { "<leader>gl", desc = "Git log" },
        { "<leader>gL", desc = "Git log (current file)" },
        
        -- LSP (from LazyVim)
        { "<leader>cd", desc = "Line diagnostics" },
        { "<leader>cl", desc = "Lsp info" },
        { "<leader>cr", desc = "Rename" },
        { "<leader>ca", desc = "Code action" },
        { "<leader>cf", desc = "Format" },
        
        -- Diagnostics
        { "<leader>xx", desc = "Document diagnostics (Trouble)" },
        { "<leader>xX", desc = "Workspace diagnostics (Trouble)" },
        { "<leader>xl", desc = "Location list (Trouble)" },
        { "<leader>xq", desc = "Quickfix list (Trouble)" },
        
        -- Usage tracking
        { "<leader>uk", desc = "Toggle keylog" },
        { "<leader>uh", desc = "Show keystroke heatmap" },
        { "<leader>us", desc = "Show keystroke stats" },
        { "<leader>ut", desc = "Show today's usage" },
        { "<leader>uw", desc = "Show weekly usage" },
        { "<leader>um", desc = "Show monthly usage" },
        { "<leader>uf", desc = "Show current file usage" },
        
        -- UI toggles
        { "<leader>ul", desc = "Toggle line numbers" },
        { "<leader>ur", desc = "Toggle relative numbers" },
        { "<leader>uW", desc = "Toggle wrap" },
        { "<leader>uS", desc = "Toggle spelling" },
        { "<leader>uc", desc = "Toggle conceallevel" },
        { "<leader>uF", desc = "Toggle format on save" },
        { "<leader>uG", desc = "Toggle format on save (global)" },
        
        -- Windows
        { "<leader>w-", desc = "Split below" },
        { "<leader>w|", desc = "Split right" },
        { "<leader>wd", desc = "Delete window" },
        { "<leader>ww", desc = "Other window" },
        { "<leader>wm", desc = "Maximize" },
        
        -- Buffers
        { "<leader>bb", desc = "Switch to other buffer" },
        { "<leader>bd", desc = "Delete buffer" },
        { "<leader>bD", desc = "Delete buffer and window" },
        { "<leader>bo", desc = "Delete other buffers" },
        { "<leader>br", desc = "Revert buffer" },
        { "<leader>bs", desc = "Scratch buffer" },
        { "<leader>bS", desc = "Switch scratch buffer" },
        
        -- Session/Quit
        { "<leader>qq", desc = "Quit all" },
        { "<leader>qQ", desc = "Quit without save" },
        { "<leader>qs", desc = "Save session" },
        { "<leader>ql", desc = "Load session" },
        { "<leader>qr", desc = "Restore session" },
      },
    },
  },

  -- Command palette with telescope
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>:", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>;", "<cmd>Telescope command_history<cr>", desc = "Command history" },
      { "<C-p>", "<cmd>Telescope commands<cr>", desc = "Command palette" },
    },
  },

  -- Enhanced help system
  {
    "folke/which-key.nvim",
    keys = {
      {
        "<leader>hk",
        function()
          vim.cmd("Telescope keymaps")
        end,
        desc = "Show all keymaps",
      },
      {
        "<leader>hc",
        function()
          vim.cmd("Telescope commands")
        end,
        desc = "Show all commands",
      },
      {
        "<leader>hh",
        function()
          vim.cmd("Telescope help_tags")
        end,
        desc = "Help tags",
      },
      {
        "<leader>ho",
        function()
          vim.cmd("Telescope vim_options")
        end,
        desc = "Vim options",
      },
      {
        "<leader>hm",
        function()
          vim.cmd("Telescope man_pages")
        end,
        desc = "Man pages",
      },
    },
  },

  -- Custom cheat sheet
  {
    "folke/which-key.nvim",
    keys = {
      {
        "<leader>?",
        function()
          local cheat_sheet = {
            "NVIM CHEAT SHEET",
            "",
            "ESSENTIAL SHORTCUTS:",
            "<leader>?        Show this help",
            "<leader><leader> Command palette",
            "<F1>            Show commands",
            "<C-p>           Command palette",
            "",
            "FILE NAVIGATION:",
            "<leader>fp      Find files",
            "<leader>fw      Search in files",
            "<leader>fr      Recent files",
            "<leader>fP      Projects",
            "",
            "PROJECT MANAGEMENT:",
            "<leader>pc      Close project",
            "<leader>po      Open project",
            "<leader>ps      Switch project",
            "",
            "HARPOON (Quick Files):",
            "<leader>ha      Add file",
            "<leader>hh      Quick menu",
            "<leader>h1-4    Go to file 1-4",
            "",
            "TERMINAL:",
            "<leader>tt      Toggle terminal",
            "<leader>tf      Float terminal",
            "<C-\\>          Quick terminal",
            "",
            "SEARCH & REPLACE:",
            "<leader>sr      Search/replace",
            "<leader>sw      Search word",
            "",
            "CODE:",
            "<leader>ca      Code actions",
            "<leader>cr      Rename",
            "<leader>cf      Format",
            "gd             Go to definition",
            "gr             Go to references",
            "",
            "LARAVEL:",
            "<leader>la      Artisan commands",
            "<leader>lr      Routes",
            "<leader>lm      Related files",
            "",
            "NPM/PACKAGE:",
            "<leader>ns      Show package info",
            "<leader>nu      Update package",
            "<leader>ni      Install package",
            "",
            "DATABASE:",
            "<leader>db      Toggle database UI",
            "<leader>do      Open database UI",
            "<leader>de      Execute query",
            "<leader>dE      Execute selected",
            "<leader>dr      Refresh DDEV connections",
            "<leader>dR      DDEV debug test",
            "",
            "USAGE TRACKING:",
            "<leader>uk      Toggle keylog",
            "<leader>uh      Keystroke heatmap",
            "<leader>us      Keystroke stats",
            "<leader>ut      Today's usage",
            "<leader>uw      Weekly usage",
            "<leader>uf      File usage",
            "",
            "Press 'q' to close this help",
          }
          
          local buf = vim.api.nvim_create_buf(false, true)
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, cheat_sheet)
          vim.api.nvim_buf_set_option(buf, "modifiable", false)
          vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
          vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
          vim.api.nvim_buf_set_option(buf, "filetype", "help")
          
          local width = 60
          local height = #cheat_sheet
          local row = math.floor((vim.o.lines - height) / 2)
          local col = math.floor((vim.o.columns - width) / 2)
          
          local win = vim.api.nvim_open_win(buf, true, {
            relative = "editor",
            row = row,
            col = col,
            width = width,
            height = height,
            border = "rounded",
            title = " Quick Help ",
            title_pos = "center",
          })
          
          vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<cr>", { noremap = true, silent = true })
          vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<cmd>close<cr>", { noremap = true, silent = true })
        end,
        desc = "Show cheat sheet",
      },
    },
  },

  -- Add help group to which-key
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>h", group = "Help" },
        { "<leader>hk", desc = "Keymaps" },
        { "<leader>hc", desc = "Commands" },
        { "<leader>hh", desc = "Help tags" },
        { "<leader>ho", desc = "Vim options" },
        { "<leader>hm", desc = "Man pages" },
      },
    },
  },
}