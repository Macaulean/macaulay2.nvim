-- User command definitions for macaulay2.nvim
local M = {}

local repl = require("macaulay2.repl")

-- Subcommand handlers
local subcommands = {
  start = {
    fn = repl.start,
    desc = "Start the Macaulay2 REPL",
  },
  stop = {
    fn = repl.stop,
    desc = "Stop the Macaulay2 REPL",
  },
  toggle = {
    fn = repl.toggle,
    desc = "Toggle REPL visibility",
  },
  show = {
    fn = repl.show,
    desc = "Show the REPL window",
  },
  hide = {
    fn = repl.hide,
    desc = "Hide the REPL window",
  },
  focus = {
    fn = repl.focus,
    desc = "Focus the REPL window",
  },
  send = {
    fn = function(args)
      if args and args ~= "" then
        repl.send(args)
      else
        vim.notify("Usage: :M2 send {code}", vim.log.levels.WARN)
      end
    end,
    desc = "Send code to the REPL",
    nargs = true,
  },
  help = {
    fn = function(args)
      if args and args ~= "" then
        repl.send("viewHelp " .. args)
      else
        repl.help_cursor()
      end
    end,
    desc = "Show Macaulay2 help for a topic",
    nargs = true,
  },
}

-- Complete subcommands
local function complete_subcommands(arg_lead)
  local matches = {}
  for name, _ in pairs(subcommands) do
    if name:find("^" .. arg_lead) then
      table.insert(matches, name)
    end
  end
  table.sort(matches)
  return matches
end

-- Main command handler
local function handle_command(opts)
  local args = opts.fargs
  local subcmd = args[1]

  if not subcmd then
    -- Default action: toggle REPL
    repl.toggle()
    return
  end

  local handler = subcommands[subcmd]
  if not handler then
    vim.notify("Unknown subcommand: " .. subcmd, vim.log.levels.ERROR)
    vim.notify("Available: " .. table.concat(vim.tbl_keys(subcommands), ", "), vim.log.levels.INFO)
    return
  end

  if handler.nargs then
    -- Pass remaining arguments as a single string
    local remaining = table.concat(vim.list_slice(args, 2), " ")
    handler.fn(remaining)
  else
    handler.fn()
  end
end

-- Setup user commands
function M.setup()
  vim.api.nvim_create_user_command("M2", handle_command, {
    nargs = "*",
    complete = function(arg_lead, cmd_line, cursor_pos)
      local args = vim.split(cmd_line, "%s+")
      -- Remove "M2" from args
      table.remove(args, 1)

      if #args <= 1 then
        return complete_subcommands(arg_lead)
      end
      return {}
    end,
    desc = "Macaulay2 commands",
  })
end

return M
