# tmux-neovim-ide

A VSCode-like terminal IDE built with Ghostty + tmux + Neovim.

Cmd+P to find files, Cmd+Shift+F to search across the project, Cmd+B to toggle the sidebar.
VSCode keybindings work out of the box.

## Screenshot

![IDE Overview](docs/screenshots/ide-overview.png)

## Requirements

-macOS -[Homebrew](https://brew.sh) -[Ghostty](https://ghostty.org) (required for Cmd key passthrough) -[PlemolJP Console NF](https://github.com/yuru7/PlemolJP) (font; any other Nerd Font works too)

## Setup

```bash
git clone https://github.com/s-0-a-r/tmux-neovim-ide.git ~/tmux-neovim-ide
cd ~/tmux-neovim-ide
./setup.sh
```

If the tools are already installed:

```bash
./setup.sh --config-only
```

The setup script will:

1.Install tools via `brew install` (neovim, tmux, fzf, fd, ripgrep, ghostty)
2.Back up existing config files
3.Deploy configs as symlinks
4.Add `~/.local/bin` to PATH

After setup, Neovim will auto-install plugins on first launch. To pin to the exact versions in this repo:

```bash
nvim --headless "+Lazy! restore" +qa
```

## Usage

```bash
ide            # select from ~/projects via fzf
ide .          # open the current directory
ide ~/my-app   # open a specific directory
```

Running without arguments lets you pick a project from `~/projects` via fzf. Passing a directory opens it directly in IDE mode.

## Keybindings

### VSCode-like keybindings (Cmd key)

| Key               | Action                                     |
| ----------------- | ------------------------------------------ |
| `Cmd+P`           | Find file                                  |
| `Cmd+Shift+F`     | Search in project                          |
| `Cmd+Shift+P`     | Command palette                            |
| `Cmd+B`           | Toggle sidebar (Neo-tree)                  |
| `Cmd+/`           | Toggle comment                             |
| `` Cmd+` ``       | Toggle bottom terminal                     |
| `Cmd+J`           | Toggle right terminal                      |
| `Cmd+Shift+J`     | Floating terminal                          |
| `Cmd+Shift+C`     | New terminal at file's directory           |
| `Cmd+D`           | Go to implementation                       |
| `Cmd+M`           | Add selection to next match (multi-cursor) |
| `Shift+Cmd+R`     | Call hierarchy (incoming calls)            |
| `Alt+Cmd+E`       | Focus explorer                             |
| `Shift+Cmd+D`     | Toggle debug UI                            |
| `Shift+Alt+Cmd+R` | File history (diff)                        |
| `Shift+Alt+Cmd+G` | Diff view                                  |

### Neovim keybindings

| Key            | Action                            |
| -------------- | --------------------------------- |
| `Space`        | Leader key                        |
| `Ctrl+h/j/k/l` | Move between windows / tmux panes |
| `Shift+H/L`    | Previous / next tab               |
| `Alt+J/K`      | Move line up / down               |
| `Space+ff`     | Find file                         |
| `Space+fg`     | Live grep                         |

### tmux

| Key           | Action           |
| ------------- | ---------------- |
| `Ctrl+B`      | Prefix           |
| `Prefix + c`  | New window       |
| `Prefix + \|` | Vertical split   |
| `Prefix + -`  | Horizontal split |

## Architecture

```
Ghostty (converts Cmd keys to escape sequences)
  └─ tmux (receives via user-keys, converts to CSI u format)
       └─ Neovim (<D-*> mappings bound to editor features)
```

## Directory structure

```
tmux-neovim-ide/
├── setup.sh                          # setup script
├── config/
│   ├── tmux.conf                     # → ~/.tmux.conf
│   ├── ghostty/
│   │   └── config                    # → ~/Library/Application Support/com.mitchellh.ghostty/config
│   └── nvim/                         # → ~/.config/nvim/
│       ├── init.lua
│       └── lua/plugins/
│           ├── bufferline.lua
│           ├── colorscheme.lua
│           ├── completion.lua
│           ├── conform.lua           # formatting (conform.nvim)
│           ├── dap.lua               # debugging (nvim-dap)
│           ├── flutter-tools.lua     # Flutter/Dart support
│           ├── fzf.lua
│           ├── git.lua
│           ├── indent.lua
│           ├── lsp.lua               # LSP (mason + nvim-lspconfig)
│           ├── lualine.lua
│           ├── navigation.lua
│           ├── neo-tree.lua
│           ├── toggleterm.lua
│           ├── treesitter.lua
│           ├── trouble.lua           # Problems panel
│           └── which-key.lua
└── bin/
    └── ide                           # → ~/.local/bin/ide
```

## Language support (LSP / Format / Debug)

On top of the base editor experience, this setup adds real-time diagnostics, formatting, and debugging for Flutter/Dart, Go, TypeScript, and PHP.

| Layer          | Plugins                                                | Languages covered                                                                                                                                                 |
| -------------- | ------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| LSP            | `mason.nvim`, `mason-lspconfig.nvim`, `nvim-lspconfig` | Go (`gopls`), TypeScript/JS (`vtsls`), PHP (`intelephense`), Lua (`lua_ls`)                                                                                       |
| Flutter/Dart   | `flutter-tools.nvim`                                   | Dart LSP, hot reload, device selection, run/debug                                                                                                                 |
| Formatting     | `conform.nvim` + `mason-tool-installer.nvim`           | Go (`goimports`/`gofumpt`), TS/JS (`prettier`), PHP (`php-cs-fixer`), Dart (`dart format`), Lua (`stylua`)                                                        |
| Problems panel | `trouble.nvim`                                         | All languages (`<leader>xx`)                                                                                                                                      |
| Debugging      | `nvim-dap`, `nvim-dap-ui`, `nvim-dap-go`               | Go and Flutter/Dart (via `flutter-tools.nvim`'s DAP integration), and PHP via Xdebug (`:MasonInstall php-debug-adapter`), used for EC-CUBE projects like kofun-ec |

Install the language servers/formatters listed above via `:Mason` (or let `mason-tool-installer.nvim` auto-install them on startup). Flutter/Dart debugging requires the Flutter SDK to be on `PATH`. PHP/Xdebug debugging requires the target PHP container to have Xdebug installed and listening on port 9003 (see the project's own docs for enabling it in Docker).

## Related articles (Japanese)

-[Build a VSCode-like terminal IDE with tmux + Neovim](https://zenn.dev/s0ar/articles/fd6203970ba0fe) -[Build a lightweight terminal IDE with Zellij + Helix](https://zenn.dev/s0ar/articles/192a58e9177961)

## License

MIT
