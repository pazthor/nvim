-- Description: Note-taking and organization tools (Org-mode alternative to Obsidian)
-- Dependencies: orgmode, telescope.nvim
-- Purpose: Provides structured note-taking and task management capabilities

return {
  -- Org-mode support for Neovim
  {
    "nvim-orgmode/orgmode",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
      "nvim-orgmode/org-bullets.nvim",
    },
    event = "VeryLazy",
    ft = { "org" },
    keys = {
      { "<leader>oa", "<cmd>Org agenda<cr>", desc = "Org agenda" },
      { "<leader>oc", "<cmd>Org capture<cr>", desc = "Org capture" },
      { "<leader>oh", "<cmd>Org help<cr>", desc = "Org help" },
      { "<leader>oi", "<cmd>Org install_treesitter_grammar<cr>", desc = "Install org treesitter" },
      {
        "<leader>or",
        function()
          vim.cmd("Org refile")
        end,
      },

      -- Optional: Telescope integration for Org-mode (enable if you want advanced telescope features)
      {
        "nvim-orgmode/telescope-orgmode.nvim",
        enabled = false, -- Set to true if you want telescope-orgmode features
        dependencies = {
          "nvim-orgmode/orgmode",
          "nvim-telescope/telescope.nvim",
        },
        config = function()
          require("telescope").load_extension("orgmode")
        end,
        keys = {
          {
            "<leader>or",
            function()
              require("telescope").extensions.orgmode.refile_heading()
            end,
            desc = "Org refile heading",
          },
          {
            "<leader>of",
            function()
              require("telescope").extensions.orgmode.search_headings()
            end,
            desc = "Org search headings",
          },
          {
            "<leader>ol",
            function()
              require("telescope").extensions.orgmode.insert_link()
            end,
            desc = "Org insert link",
          },
        },
        desc = "Org refile heading",
      },
      {
        "<leader>of",
        function()
          require("telescope.builtin").live_grep({
            search_dirs = { vim.fn.expand("~/notes/org") },
            prompt_title = "Search Org Files",
          })
        end,
        desc = "Org find headings",
      },
      {
        "<leader>ol",
        function()
          vim.cmd("normal! i[[")
        end,
        desc = "Org insert link",
      },
    },
    config = function()
      -- Setup orgmode
      require("orgmode").setup({
        org_agenda_files = "~/notes/org/**/*",
        org_default_notes_file = "~/notes/org/refile.org",
        org_todo_keywords = { "TODO", "DOING", "|", "DONE", "DELEGATED" },
        org_agenda_templates = {
          t = {
            description = "Task",
            template = "* TODO %?\n  SCHEDULED: %t",
            target = "~/notes/org/todo.org",
          },
          n = {
            description = "Note",
            template = "* %? :NOTE:\n  %u",
            target = "~/notes/org/notes.org",
          },
          j = {
            description = "Journal",
            template = "* %U - %?\n",
            target = "~/notes/org/journal.org",
          },
        },
        win_split_mode = "horizontal",
        org_startup_indented = true,
        org_adapt_indentation = true,
        org_hide_emphasis_markers = true,
        org_pretty_entities = true,
        mappings = {
          agenda = {
            org_agenda_later = "f",
            org_agenda_earlier = "b",
            org_agenda_goto_today = ".",
          },
        },
      })

      -- Setup org-bullets for prettier org files
      require("org-bullets").setup({
        concealcursor = false,
        symbols = {
          list = "•",
          headlines = { "◉", "○", "✸", "✿" },
          checkboxes = {
            half = { "", "OrgTSCheckboxHalfChecked" },
            done = { "✓", "OrgDone" },
            todo = { "˟", "OrgTODO" },
          },
        },
      })

      -- Create notes directory if it doesn't exist
      vim.fn.mkdir(vim.fn.expand("~/notes/org"), "p")
    end,
  },

  -- Zettelkasten support with Telekasten
  {
    "nvim-telekasten/telekasten.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    keys = {
      -- Zettelkasten operations
      { "<leader>zz", "<cmd>Telekasten panel<CR>", desc = "Telekasten panel" },
      { "<leader>zf", "<cmd>Telekasten find_notes<CR>", desc = "Find notes" },
      { "<leader>zg", "<cmd>Telekasten search_notes<CR>", desc = "Search notes" },
      { "<leader>zd", "<cmd>Telekasten goto_today<CR>", desc = "Today's note" },
      { "<leader>zn", "<cmd>Telekasten new_note<CR>", desc = "New note" },
      { "<leader>zt", "<cmd>Telekasten goto_thisweek<CR>", desc = "This week's note" },
      { "<leader>zw", "<cmd>Telekasten find_weekly_notes<CR>", desc = "Find weekly notes" },
      { "<leader>zl", "<cmd>Telekasten follow_link<CR>", desc = "Follow link" },
      { "<leader>zb", "<cmd>Telekasten show_backlinks<CR>", desc = "Show backlinks" },
      { "<leader>zi", "<cmd>Telekasten insert_img_link<CR>", desc = "Insert image link" },
      { "<leader>zp", "<cmd>Telekasten preview_img<CR>", desc = "Preview image" },
      { "<leader>zm", "<cmd>Telekasten browse_media<CR>", desc = "Browse media" },
      { "<leader>zc", "<cmd>Telekasten show_calendar<CR>", desc = "Show calendar" },
      { "<leader>zy", "<cmd>Telekasten yank_notelink<CR>", desc = "Yank note link" },
      { "<leader>zr", "<cmd>Telekasten rename_note<CR>", desc = "Rename note" },
      -- Link creation (in insert mode)
      { "[[", "<cmd>Telekasten insert_link<CR>", mode = "i", desc = "Insert link" },
    },
    config = function()
      require("telekasten").setup({
        home = vim.fn.expand("~/notes/zettelkasten"),
        dailies = vim.fn.expand("~/notes/zettelkasten/daily"),
        weeklies = vim.fn.expand("~/notes/zettelkasten/weekly"),
        templates = vim.fn.expand("~/notes/zettelkasten/templates"),
        image_subdir = "img",
        extension = ".md",
        new_note_filename = "uuid-title", -- uuid, uuid-title, title, title-uuid
        uuid_type = "%Y%m%d%H%M", -- timestamp-based UUID
        uuid_sep = "-",
        follow_creates_nonexisting = true,
        dailies_create_nonexisting = true,
        weeklies_create_nonexisting = true,
        journal_auto_open = false,

        -- Templates
        template_new_note = vim.fn.expand("~/notes/zettelkasten/templates/new_note.md"),
        template_new_daily = vim.fn.expand("~/notes/zettelkasten/templates/daily.md"),
        template_new_weekly = vim.fn.expand("~/notes/zettelkasten/templates/weekly.md"),

        -- Calendar settings
        plug_into_calendar = true,
        calendar_opts = {
          weeknm = 4,
          calendar_monday = 1,
          calendar_mark = "left-fit",
        },

        -- Subdirs
        subdirs_in_links = true,

        -- Preview and media
        image_link_style = "markdown",
        sort = "filename",

        -- File recognition
        recognize_subdir = true,
        vaults = {},

        -- Auto set filetype
        auto_set_filetype = true,
        auto_set_syntax = true,

        -- Command palette
        command_palette_theme = "dropdown",
        show_tags_theme = "dropdown",

        -- Preview settings
        preview_opts = {
          markdownPreviewOptions = {
            use_fenced_code_blocks = true,
            use_tables = true,
          },
        },
      })

      -- Create directory structure if it doesn't exist
      local dirs = {
        "~/notes/zettelkasten",
        "~/notes/zettelkasten/daily",
        "~/notes/zettelkasten/weekly",
        "~/notes/zettelkasten/templates",
        "~/notes/zettelkasten/img",
      }

      for _, dir in ipairs(dirs) do
        vim.fn.mkdir(vim.fn.expand(dir), "p")
      end

      -- Create template files if they don't exist
      local templates = {
        ["~/notes/zettelkasten/templates/new_note.md"] = [[# {{ title }}

Tags: #{{ tags }}
Created: {{ date }}

## Content

{{ cursor }}

## References

]],
        ["~/notes/zettelkasten/templates/daily.md"] = [[# {{ title }}

Date: {{ date }}

## Today's Focus

- [ ] 

## Notes

{{ cursor }}

## Reflections

### What went well?

### What could be improved?

### Tomorrow's priorities

]],
        ["~/notes/zettelkasten/templates/weekly.md"] = [[# Week {{ title }}

Week of: {{ date }}

## Week Overview

{{ cursor }}

## Goals for this week

- [ ] 

## Weekly Review

### Accomplishments

### Challenges

### Lessons Learned

### Next Week's Focus

]],
      }

      for filepath, content in pairs(templates) do
        local expanded_path = vim.fn.expand(filepath)
        if vim.fn.filereadable(expanded_path) == 0 then
          local file = io.open(expanded_path, "w")
          if file then
            file:write(content)
            file:close()
          end
        end
      end
    end,
  },

  -- Alternative Zettelkasten plugin (simpler, vim-philosophy focused)
  {
    "Furkanzmc/zettelkasten.nvim",
    enabled = false, -- Disable by default since we're using telekasten
    ft = "markdown",
    keys = {
      { "<leader>zn", "<cmd>ZkNew<cr>", desc = "New Zettel" },
      { "<leader>zo", "<cmd>ZkOpen<cr>", desc = "Open Zettel" },
      { "<leader>zi", "<cmd>ZkInsertLink<cr>", desc = "Insert Link" },
    },
    config = function()
      require("zettelkasten").setup({
        zettel_path = vim.fn.expand("~/notes/zettelkasten"),
        notes_extension = ".md",
      })
    end,
  },

  -- Modern note-taking with Neorg (alternative to org-mode)
  {
    "nvim-neorg/neorg",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neorg/neorg-telescope", -- Optional telescope integration
    },
    enabled = false, -- Disable by default to avoid conflicts with orgmode
    ft = "norg",
    cmd = "Neorg",
    keys = {
      { "<leader>no", "<cmd>Neorg<cr>", desc = "Neorg" },
      { "<leader>ni", "<cmd>Neorg index<cr>", desc = "Neorg index" },
      { "<leader>nr", "<cmd>Neorg return<cr>", desc = "Neorg return" },
      { "<leader>nj", "<cmd>Neorg journal<cr>", desc = "Neorg journal" },
      { "<leader>nt", "<cmd>Neorg journal today<cr>", desc = "Today's journal" },
      { "<leader>ny", "<cmd>Neorg journal yesterday<cr>", desc = "Yesterday's journal" },
      { "<leader>nm", "<cmd>Neorg journal tomorrow<cr>", desc = "Tomorrow's journal" },
    },
    config = function()
      require("neorg").setup({
        load = {
          ["core.defaults"] = {},
          ["core.concealer"] = {},
          ["core.dirman"] = {
            config = {
              workspaces = {
                notes = "~/notes/neorg",
                work = "~/notes/neorg/work",
                personal = "~/notes/neorg/personal",
              },
              default_workspace = "notes",
              autodetect = true,
              autochdir = true,
            },
          },
          ["core.completion"] = {
            config = {
              engine = "nvim-cmp",
            },
          },
          ["core.integrations.nvim-cmp"] = {},
          ["core.journal"] = {
            config = {
              workspace = "notes",
              journal_folder = "journal",
              use_template = true,
            },
          },
          ["core.keybinds"] = {
            config = {
              default_keybinds = true,
              neorg_leader = "<Leader>n",
            },
          },
          ["core.export"] = {},
          ["core.export.markdown"] = {},
          ["core.summary"] = {},
          ["core.tangle"] = {},
          ["core.ui.calendar"] = {},
        },
      })

      -- Create neorg directories
      vim.fn.mkdir(vim.fn.expand("~/notes/neorg"), "p")
      vim.fn.mkdir(vim.fn.expand("~/notes/neorg/work"), "p")
      vim.fn.mkdir(vim.fn.expand("~/notes/neorg/personal"), "p")
    end,
  },

  -- Enhanced markdown support for note-taking
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown preview" },
    },
  },

  -- Obsidian integration (for those who use Obsidian)
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    enabled = false, -- Set to true if you use Obsidian
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      { "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = "Open in Obsidian" },
      { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New Obsidian note" },
      { "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick switch" },
      { "<leader>of", "<cmd>ObsidianFollowLink<cr>", desc = "Follow link" },
      { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Show backlinks" },
      { "<leader>ot", "<cmd>ObsidianTags<cr>", desc = "Show tags" },
      { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search notes" },
      { "<leader>ol", "<cmd>ObsidianLink<cr>", desc = "Link selection" },
      { "<leader>oL", "<cmd>ObsidianLinkNew<cr>", desc = "Link to new note" },
      { "<leader>op", "<cmd>ObsidianPasteImg<cr>", desc = "Paste image" },
      { "<leader>or", "<cmd>ObsidianRename<cr>", desc = "Rename note" },
    },
    config = function()
      require("obsidian").setup({
        workspaces = {
          {
            name = "personal",
            path = "~/obsidian/personal",
          },
          {
            name = "work",
            path = "~/obsidian/work",
          },
        },

        -- Disable completion (since we're using blink.cmp, not nvim-cmp)
        completion = {
          nvim_cmp = false,
          min_chars = 2,
        },

        -- Note settings
        new_notes_location = "notes_subdir",
        note_id_func = function(title)
          -- Create note IDs from title if provided, otherwise use timestamp
          local suffix = ""
          if title ~= nil then
            suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
          else
            suffix = tostring(os.time())
          end
          return suffix
        end,

        -- Note frontmatter
        note_frontmatter_func = function(note)
          local out = { id = note.id, aliases = note.aliases, tags = note.tags }
          if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
            for k, v in pairs(note.metadata) do
              out[k] = v
            end
          end
          return out
        end,

        -- Templates
        templates = {
          subdir = "templates",
          date_format = "%Y-%m-%d",
          time_format = "%H:%M",
          substitutions = {},
        },

        -- Daily notes
        daily_notes = {
          folder = "daily",
          date_format = "%Y-%m-%d",
          alias_format = "%B %-d, %Y",
          template = nil,
        },

        -- Follow link behavior
        follow_url_func = function(url)
          vim.fn.jobstart({ "open", url })
        end,

        -- Image pasting
        attachments = {
          img_folder = "assets/imgs",
        },

        -- Key mappings
        mappings = {
          ["gf"] = {
            action = function()
              return require("obsidian").util.gf_passthrough()
            end,
            opts = { noremap = false, expr = true, buffer = true },
          },
          ["<leader>ch"] = {
            action = function()
              return require("obsidian").util.toggle_checkbox()
            end,
            opts = { buffer = true },
          },
        },

        -- UI settings
        ui = {
          enable = true,
          update_debounce = 200,
          checkboxes = {
            [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
            ["x"] = { char = "", hl_group = "ObsidianDone" },
            [">"] = { char = "", hl_group = "ObsidianRightArrow" },
            ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
          },
          external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
          reference_text = { hl_group = "ObsidianRefText" },
          highlight_text = { hl_group = "ObsidianHighlightText" },
          tags = { hl_group = "ObsidianTag" },
        },
      })
    end,
  },

  -- Enhanced which-key integration for note-taking
  {
    "folke/which-key.nvim",
    optional = true,
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      vim.list_extend(opts.spec, {
        { "<leader>o", group = "Org-mode" },
        { "<leader>oa", desc = "Org agenda" },
        { "<leader>oc", desc = "Org capture" },
        { "<leader>oh", desc = "Org help" },
        { "<leader>oi", desc = "Install org treesitter" },
        { "<leader>or", desc = "Org refile heading" },
        { "<leader>of", desc = "Org find headings" },
        { "<leader>ol", desc = "Org insert link" },

        { "<leader>z", group = "Zettelkasten" },
        { "<leader>zz", desc = "Telekasten panel" },
        { "<leader>zf", desc = "Find notes" },
        { "<leader>zg", desc = "Search notes" },
        { "<leader>zd", desc = "Today's note" },
        { "<leader>zn", desc = "New note" },
        { "<leader>zt", desc = "This week's note" },
        { "<leader>zw", desc = "Find weekly notes" },
        { "<leader>zl", desc = "Follow link" },
        { "<leader>zb", desc = "Show backlinks" },
        { "<leader>zi", desc = "Insert image link" },
        { "<leader>zp", desc = "Preview image" },
        { "<leader>zm", desc = "Browse media" },
        { "<leader>zc", desc = "Show calendar" },
        { "<leader>zy", desc = "Yank note link" },
        { "<leader>zr", desc = "Rename note" },

        { "<leader>n", group = "Neorg" },
        { "<leader>no", desc = "Neorg" },
        { "<leader>ni", desc = "Neorg index" },
        { "<leader>nr", desc = "Neorg return" },
        { "<leader>nj", desc = "Neorg journal" },
        { "<leader>nt", desc = "Today's journal" },
        { "<leader>ny", desc = "Yesterday's journal" },
        { "<leader>nm", desc = "Tomorrow's journal" },

        { "<leader>m", group = "Markdown" },
        { "<leader>mp", desc = "Markdown preview" },

        -- Only show Obsidian commands if plugin is enabled
        -- { "<leader>o", group = "Obsidian" }, -- Uncomment if you enable obsidian.nvim
      })
    end,
  },
}
