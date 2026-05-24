-- Keymap setup for macaulay2.nvim
local M = {}

local repl = require("macaulay2.repl")
local config = require("macaulay2.config")

-- Setup Plug mappings (always available)
function M.setup_plug_mappings()
  -- REPL control
  vim.keymap.set("n", "<Plug>(macaulay2-start)", repl.start, { desc = "Start M2 REPL" })
  vim.keymap.set("n", "<Plug>(macaulay2-stop)", repl.stop, { desc = "Stop M2 REPL" })
  vim.keymap.set("n", "<Plug>(macaulay2-toggle)", repl.toggle, { desc = "Toggle M2 REPL" })
  vim.keymap.set("n", "<Plug>(macaulay2-focus)", repl.focus, { desc = "Focus M2 REPL" })

  -- Send commands
  vim.keymap.set("n", "<Plug>(macaulay2-send-line)", repl.send_line, { desc = "Send line to M2" })
  vim.keymap.set("x", "<Plug>(macaulay2-send-selection)", function()
    -- Exit visual mode first to set '< and '> marks
    vim.cmd("normal! " .. vim.api.nvim_replace_termcodes("<Esc>", true, false, true))
    repl.send_selection()
  end, { desc = "Send selection to M2" })
  vim.keymap.set("n", "<Plug>(macaulay2-send-buffer)", repl.send_buffer, { desc = "Send buffer to M2" })

  -- Help (also bound to <localleader>h as LSP-safe alternative)
  vim.keymap.set("n", "<Plug>(macaulay2-help-cursor)", repl.help_cursor, { desc = "M2 help for word under cursor" })
end

-- Setup buffer-local keymaps for M2 files
function M.setup_buffer_keymaps(bufnr)
  local opts = config.get()

  if not opts.keymaps.enabled then
    return
  end

  local prefix = opts.keymaps.prefix
  local map_opts = { buffer = bufnr, silent = true }

  -- Send current line with Enter in normal mode
  vim.keymap.set("n", "<CR>", repl.send_line, vim.tbl_extend("force", map_opts, { desc = "Send line to M2" }))

  -- Send selection with Enter in visual mode
  vim.keymap.set("x", "<CR>", function()
    vim.cmd("normal! " .. vim.api.nvim_replace_termcodes("<Esc>", true, false, true))
    repl.send_selection()
  end, vim.tbl_extend("force", map_opts, { desc = "Send selection to M2" }))

  -- Toggle REPL
  vim.keymap.set("n", prefix .. "s", repl.toggle, vim.tbl_extend("force", map_opts, { desc = "Toggle M2 REPL" }))

  -- Send buffer
  vim.keymap.set("n", prefix .. "r", repl.send_buffer, vim.tbl_extend("force", map_opts, { desc = "Send buffer to M2" }))

  -- Help for word under cursor: K (may be overridden by LSP hover on attach)
  vim.keymap.set("n", "K", repl.help_cursor, vim.tbl_extend("force", map_opts, { desc = "M2 help for word under cursor" }))
  vim.keymap.set("n", prefix .. "h", repl.help_cursor, vim.tbl_extend("force", map_opts, { desc = "M2 help for word under cursor" }))

  -- Focus REPL
  vim.keymap.set("n", prefix .. "f", repl.focus, vim.tbl_extend("force", map_opts, { desc = "Focus M2 REPL" }))

  -- Start REPL
  vim.keymap.set("n", prefix .. "o", repl.start, vim.tbl_extend("force", map_opts, { desc = "Start M2 REPL" }))

  -- Stop REPL
  vim.keymap.set("n", prefix .. "c", repl.stop, vim.tbl_extend("force", map_opts, { desc = "Stop M2 REPL" }))
end

return M
