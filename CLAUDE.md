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
│   ├── core/                   # Core functionality modules
│   │   └── settings.lua       # Shared plugin settings and configurations
│   ├── utils/                  # Utility functions
│   │   ├── keymaps.lua        # Keymap helper functions
│   │   └── lsp.lua            # Shared LSP configurations
│   ├── lang/                   # Language-specific configurations
│   │   ├── web.lua            # Web development (JS, TS, Svelte, CSS, HTML)
│   │   └── php.lua            # PHP and Laravel development
│   └── plugins/               # Plugin configurations by functionality
│       ├── completion.lua     # Autocompletion and snippets
│       ├── debugging.lua      # Debug and testing tools
│       ├── editor.lua         # Core editing functionality
│       ├── git.lua            # Git integration tools
│       ├── lsp.lua            # LSP configuration and Mason setup
│       ├── navigation.lua     # File and code navigation tools
│       ├── ui.lua             # Interface and visual enhancements
│       ├── database.lua       # Database tools with DDEV integration
│       ├── mi_gusto_es.lua    # Custom snacks.nvim configuration
│       ├── command_palette.lua # Command discovery and help system
│       ├── shortcut_recorder.lua # Shortcut recording functionality
│       ├── usage_tracking.lua # Usage analytics and tracking
│       ├── obsidian_fake.lua  # Note-taking and organization tools
│       └── example.lua        # Example plugin configurations (disabled)
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
- **Core Utilities**: Shared LSP configurations and keymap helpers (`lua/utils/`)
- **Language Support**: Modular language configurations (`lua/lang/`)
- **Navigation Tools**: Enhanced file/code navigation with Telescope and Harpoon (`lua/plugins/navigation.lua`)
- **UI Enhancements**: Improved interface with bufferline, statusline, file tree (`lua/plugins/ui.lua`)
- **Development Tools**: Git integration, debugging, completion, and editing tools
- **Specialized Features**: Database tools, usage tracking, note-taking capabilities

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
1. Determine the appropriate category:
   - **Language-specific**: Add to `lua/lang/` (web.lua, php.lua, etc.)
   - **Functionality-based**: Add to `lua/plugins/` (navigation.lua, ui.lua, etc.)
   - **New category**: Create new file following naming conventions
2. Follow LazyVim plugin specification format with proper file headers
3. Use shared utilities from `lua/utils/` for consistency

### Modifying Existing Plugins
- Language plugins: Modify files in `lua/lang/`
- Core functionality: Modify files in `lua/plugins/`
- Shared settings: Update `lua/core/settings.lua`
- Keymap helpers: Update `lua/utils/keymaps.lua`
- LSP configurations: Update `lua/utils/lsp.lua`

### Configuration Structure Best Practices
- **File Headers**: Include description, dependencies, and key bindings
- **Consistent Organization**: Group related functionality together
- **Shared Settings**: Use `core/settings.lua` for common configurations
- **Utility Functions**: Leverage `utils/` modules for reusable code
- **Modular Design**: Separate concerns by functionality and language

### Configuration Customization
- Vim options: `lua/config/options.lua`
- Keymaps: `lua/config/keymaps.lua`
- Autocommands: `lua/config/autocmds.lua`
- Shared settings: `lua/core/settings.lua`

## Language Support Features

### Web Development (`lua/lang/web.lua`)
- **JavaScript/TypeScript**: Full LSP support with type hints and inlay hints
- **SvelteJS**: Complete Svelte support with TypeScript and Sass integration
- **CSS/HTML**: Enhanced support with Tailwind CSS integration
- **Package Management**: Interactive package.json management with version updates

### PHP Development (`lua/lang/php.lua`)
- **PHP**: Intelephense LSP server with comprehensive PHP support
- **Laravel**: Dedicated Laravel plugin with artisan commands and blade templates
- **Code Quality**: PHP-CS-Fixer formatting and PHPStan static analysis

### Key Bindings for Development
- `<leader>la` - Laravel artisan commands
- `<leader>lr` - Laravel routes  
- `<leader>lm` - Laravel related files
- `<leader>ns` - Show package.json info
- `<leader>nu` - Update npm package
- `<leader>ni` - Install npm package

### Core Plugin Categories

#### Navigation Tools (`lua/plugins/navigation.lua`)
- **Telescope**: Comprehensive fuzzy finder with project management and file browser
- **Harpoon**: Quick file navigation and bookmarking system
- **Spectre**: Advanced search and replace across files
- **BQF**: Enhanced quickfix window with better filtering

#### UI Enhancements (`lua/plugins/ui.lua`)
- **Neo-tree**: Enhanced file explorer with Git integration
- **BufferLine**: Improved buffer navigation with LSP diagnostics
- **Lualine**: Enhanced statusline with LSP status display
- **ToggleTerm**: Multi-mode terminal integration (float, horizontal, vertical)

#### Editor Features (`lua/plugins/editor.lua`)
- **Comment.nvim**: Smart commenting for all languages
- **UFO**: Advanced code folding with Tree-sitter support

#### Development Tools
- **LSP**: Centralized language server configuration (`lua/plugins/lsp.lua`)
- **Completion**: Intelligent autocompletion with snippets (`lua/plugins/completion.lua`)
- **Git**: Comprehensive Git integration with Gitsigns and LazyGit (`lua/plugins/git.lua`)
- **Debugging**: Full debugging support with DAP and Neotest (`lua/plugins/debugging.lua`)

### Key Bindings by Category

#### Navigation (`<leader>f*`, `<leader>h*`)
- `<leader>fp` - Find files
- `<leader>fw` - Live grep
- `<leader>fb` - Buffer search
- `<leader>fr` - Recent files
- `<leader>fP` - Projects
- `<leader>ha` - Harpoon add file
- `<leader>hh` - Harpoon quick menu
- `<leader>sr` - Search and replace (Spectre)

#### Terminal (`<leader>t*`)
- `<leader>tt` - Toggle terminal
- `<leader>tf` - Float terminal
- `<leader>th` - Horizontal terminal
- `<leader>tv` - Vertical terminal

#### Git Operations (`<leader>h*`, `<leader>g*`)
- `<leader>hs` - Stage hunk
- `<leader>hr` - Reset hunk
- `<leader>hp` - Preview hunk
- `<leader>gg` - LazyGit

#### Debugging (`<leader>d*`)
- `<leader>db` - Toggle breakpoint
- `<leader>dc` - Continue
- `<leader>di` - Step into
- `<leader>do` - Step out
- `<leader>du` - Toggle DAP UI

## Command Discovery & Help System

### Quick Help Access
- **`<leader>?`** - Show comprehensive cheat sheet (main help)
- **`<leader><leader>`** - Command palette (which-key)
- **`<F1>`** - Show all available commands

### Enhanced Command Discovery
- **Which-Key Integration**: Organized command groups with descriptions
- **Telescope Commands**: Searchable command palette
- **Context-Aware Help**: Auto-triggered on partial key sequences

## Important Notes

### Configuration Structure
- **Modular Design**: Configuration is organized by functionality and language
- **Shared Utilities**: Common settings and functions are centralized in `lua/core/` and `lua/utils/`
- **Consistent Headers**: All plugin files include description, dependencies, and key bindings
- **LazyVim Integration**: Built on top of LazyVim for extensive defaults and plugin ecosystem

### Plugin Management
- **Automatic Installation**: Mason automatically installs LSP servers, formatters, and linters
- **Lazy Loading**: LazyVim plugins are lazy-loaded by default for optimal startup performance
- **Version Locking**: Plugin versions are locked in `lazy-lock.json` for reproducible setups
- **Ignore Patterns**: File operations ignore common directories like `node_modules`, `vendor`, etc.

### Maintenance Guidelines
- **File Organization**: Add new language support to `lua/lang/`, functionality to `lua/plugins/`
- **Shared Settings**: Update `lua/core/settings.lua` for common configurations
- **Utility Functions**: Leverage `lua/utils/` modules for reusable code
- **Documentation**: Always update CLAUDE.md when adding significant new features