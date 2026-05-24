# macaulay2.nvim

A Neovim plugin for [Macaulay2](https://macaulay2.com), providing REPL integration, syntax support, and completion for `.m2` files.

## Features

- Integrated REPL with multiple layout options (vertical, horizontal, float, tab)
- Send code to REPL (line, selection, or buffer)
- Inline help lookup with `viewHelp`
- Keyword completion
- Filetype detection for `.m2` files
- LSP integration via M2-language-server (hover, completion, and go-to-definition)

## Requirements

- Neovim >= 0.8 (>= 0.9 for LSP support)
- [Macaulay2](https://macaulay2.com) installed and available in your PATH
- M2-language-server (optional, for LSP features; bundled with Macaulay2)

## Installation

Using nvim's [pack.add](https://neovim.io/doc/user/pack/):

In your `init.lua`, add

```lua
vim.pack.add({'https://github.com/Macaulean/macaulay2.nvim'})
```

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "Macaulean/macaulay2.nvim",
  ft = "macaulay2",
  opts = {},
}
```

## Configuration

Default configuration with all options:

```lua
{
  "mattrobball/macaulay2.nvim",
  ft = "macaulay2",
  opts = {
    repl = {
      cmd = "M2",              -- Macaulay2 executable
      args = {},               -- Additional arguments to pass to M2
      direction = "vertical",  -- "vertical", "horizontal", "float", or "tab"
      size = 0.4,              -- Size of the REPL window (0.0 to 1.0)
      float_opts = {
        border = "rounded",    -- Border style for floating window
        width = 0.8,
        height = 0.8,
      },
    },
    completion = {
      enabled = true,          -- Enable keyword completion
    },
    lsp = {
      enabled = true,          -- Auto-start LSP when M2-language-server is found
      cmd = { "M2-language-server" }, -- Command to launch the server
      settings = {},           -- Server-specific settings passed via LSP
    },
    keymaps = {
      enabled = true,          -- Enable default keymaps
      prefix = "<localleader>",
    },
  },
}
```

## Keymaps

Default keymaps are enabled in `.m2` files:

| Key | Mode | Description |
|-----|------|-------------|
| `<CR>` | n | Send current line to REPL |
| `<CR>` | x | Send selection to REPL |
| `K` | n | Show help for word under cursor (overridden by LSP hover when server is active) |
| `<localleader>h` | n | Show M2 help for word under cursor (always uses REPL) |
| `<localleader>s` | n | Toggle REPL |
| `<localleader>o` | n | Start REPL |
| `<localleader>c` | n | Stop REPL |
| `<localleader>f` | n | Focus REPL window |
| `<localleader>r` | n | Send entire buffer to REPL |

When the LSP server is active, the following additional keymaps are set on attach:

| Key | Mode | Description |
|-----|------|-------------|
| `K` | n | LSP hover documentation |
| `gd` | n | Go to definition |

### Plug Mappings

For custom keymap configurations, the following `<Plug>` mappings are available:

- `<Plug>(macaulay2-start)` - Start REPL
- `<Plug>(macaulay2-stop)` - Stop REPL
- `<Plug>(macaulay2-toggle)` - Toggle REPL
- `<Plug>(macaulay2-focus)` - Focus REPL
- `<Plug>(macaulay2-send-line)` - Send current line
- `<Plug>(macaulay2-send-selection)` - Send visual selection
- `<Plug>(macaulay2-send-buffer)` - Send buffer
- `<Plug>(macaulay2-help-cursor)` - Help for word under cursor

## Commands

All commands are available under the `:M2` prefix:

| Command | Description |
|---------|-------------|
| `:M2` | Toggle REPL (default action) |
| `:M2 start` | Start the REPL |
| `:M2 stop` | Stop the REPL |
| `:M2 toggle` | Toggle REPL visibility |
| `:M2 show` | Show REPL window |
| `:M2 hide` | Hide REPL window (keeps process running) |
| `:M2 focus` | Focus the REPL window |
| `:M2 send {code}` | Send code to the REPL |
| `:M2 help {topic}` | Show Macaulay2 help for a topic |

## License

MIT
