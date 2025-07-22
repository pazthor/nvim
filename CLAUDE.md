# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim configuration using LazyVim as the starter template. The configuration is structured around the LazyVim plugin manager system with custom plugins and configurations.

## Repository Structure

```
.
├── init.lua                    # Main entry point, bootstraps lazy.nvim
├── lua/
│   ├── config/                 # LazyVim configuration overrides
│   │   ├── lazy.lua           # Lazy.nvim setup and plugin loading
│   │   ├── options.lua        # Custom vim options
│   │   ├── keymaps.lua        # Custom keymaps
│   │   └── autocmds.lua       # Custom autocommands
│   └── plugins/               # Custom plugin configurations
│       ├── example.lua        # Example plugin configurations (disabled)
│       ├── mi_gusto_es.lua    # Custom snacks.nvim configuration
│       ├── fullstack.lua      # Fullstack development plugins
│       ├── developer_tools.lua # Enhanced developer tools and navigation
│       └── command_palette.lua # Command discovery and help system
├── lazy-lock.json             # Locked plugin versions
├── lazyvim.json               # LazyVim configuration
└── stylua.toml                # Lua formatting configuration
```

## Key Architecture

### Plugin System
- Uses **lazy.nvim** as the plugin manager
- LazyVim provides the base configuration and plugins
- Custom plugins are defined in `lua/plugins/` directory
- Each `.lua` file in `lua/plugins/` is automatically loaded

### Configuration Structure
- `init.lua`: Entry point that requires `config.lazy`
- `lua/config/lazy.lua`: Sets up lazy.nvim and loads LazyVim + custom plugins
- Configuration files in `lua/config/` override LazyVim defaults
- Plugin specifications in `lua/plugins/` extend or modify LazyVim plugins

### Current Customizations
- **snacks.nvim**: Configured to show hidden files in explorer (`lua/plugins/mi_gusto_es.lua:10`)
- **stylua**: Configured for 2-space indentation, 120 column width
- **Fullstack Development**: Complete setup for SvelteJS, PHP, Laravel, JavaScript, and TypeScript (`lua/plugins/fullstack.lua`)
- **Developer Tools**: Enhanced search, navigation, and productivity tools (`lua/plugins/developer_tools.lua`)
- **Command Palette**: Comprehensive command discovery and help system (`lua/plugins/command_palette.lua`)

## Common Development Commands

### Formatting
```bash
# Format Lua files using stylua
stylua .
```

### Plugin Management
- Plugins are automatically installed on first launch
- Plugin updates are checked automatically (configured in `lua/config/lazy.lua:34-37`)
- Locked versions are stored in `lazy-lock.json`

## Working with This Configuration

### Adding New Plugins
1. Create a new file in `lua/plugins/` or add to existing files
2. Follow LazyVim plugin specification format
3. Plugins are automatically loaded by lazy.nvim

### Modifying Existing Plugins
- Override plugin configurations in `lua/plugins/` files
- Use LazyVim's plugin extension pattern (see `example.lua` for examples)

### Configuration Customization
- Vim options: `lua/config/options.lua`
- Keymaps: `lua/config/keymaps.lua`
- Autocommands: `lua/config/autocmds.lua`

## Fullstack Development Features

### Language Support
- **SvelteJS**: Full Svelte support with TypeScript and Sass integration
- **PHP**: Intelephense and PHPActor LSP servers with Laravel support
- **Laravel**: Dedicated Laravel plugin with artisan commands and blade templates
- **JavaScript/TypeScript**: Enhanced support with ESLint, Prettier, and type hints
- **General**: HTML, CSS, JSON, YAML, SQL support

### Key Bindings for Development
- `<leader>la` - Laravel artisan commands
- `<leader>lr` - Laravel routes
- `<leader>lm` - Laravel related files
- `<leader>ns` - Show package.json info
- `<leader>nu` - Update npm package
- `<leader>ni` - Install npm package

### Developer Tools Features

#### Enhanced Search & Navigation
- **Telescope**: Comprehensive fuzzy finder with project management
- **Harpoon**: Quick file navigation and bookmarking
- **Spectre**: Advanced search and replace across files
- **Neo-tree**: Enhanced file explorer with Git integration

#### Key Bindings for Navigation
- `<leader>fp` - Find files
- `<leader>fw` - Live grep
- `<leader>fb` - Buffer search
- `<leader>fr` - Recent files
- `<leader>fP` - Projects
- `<leader>ha` - Harpoon add file
- `<leader>hh` - Harpoon quick menu
- `<leader>sr` - Search and replace (Spectre)
- `<leader>tt` - Toggle terminal
- `<leader>tf` - Float terminal

## Command Discovery & Help System

### Quick Help Access
- **`<leader>?`** - Show comprehensive cheat sheet (main help)
- **`<leader><leader>`** - Command palette (which-key)
- **`<F1>`** - Show all available commands
- **`<C-p>`** - Command palette (Telescope)

### Detailed Help Commands
- `<leader>hk` - Show all keymaps
- `<leader>hc` - Show all commands
- `<leader>hh` - Help tags
- `<leader>ho` - Vim options
- `<leader>hm` - Man pages
- `<leader>:` - Commands (Telescope)
- `<leader>;` - Command history

### Which-Key Integration
- Enhanced which-key shows organized command groups
- Categorized by function (Find, Git, Code, etc.)
- Comprehensive descriptions for all shortcuts
- Auto-triggered on partial key sequences

#### Productivity Features
- **ToggleTerm**: Enhanced terminal integration
- **BufferLine**: Improved buffer navigation with LSP diagnostics
- **UFO**: Better code folding with Tree-sitter
- **Comment.nvim**: Smart commenting for all languages
- **BQF**: Better quickfix window experience

## Important Notes

- The `example.lua` plugin file is disabled by default (line 3: `if true then return {} end`)
- LazyVim provides extensive defaults - check LazyVim documentation before adding custom configurations
- Plugin loading is lazy by default for LazyVim plugins, but custom plugins load at startup unless configured otherwise
- Mason will automatically install required LSP servers, formatters, and linters on first launch
- All file patterns ignore common directories like `node_modules`, `vendor`, `storage`, etc.

## Development Memories

- Always update pallete commands when a new command was added