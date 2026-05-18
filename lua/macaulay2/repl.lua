-- REPL/terminal integration for Macaulay2
local M = {}

local config = require("macaulay2.config")

-- REPL state
local state = {
  bufnr = nil,
  winid = nil,
  chan = nil,
}

-- Check if REPL buffer exists and is valid
local function is_buf_valid()
  return state.bufnr and vim.api.nvim_buf_is_valid(state.bufnr)
end

-- Check if REPL window exists and is valid
local function is_win_valid()
  return state.winid and vim.api.nvim_win_is_valid(state.winid)
end

-- Check if REPL process is running
function M.is_running()
  return state.chan ~= nil and is_buf_valid()
end

-- Calculate window size based on configuration
local function calc_size(direction, size)
  if direction == "vertical" then
    return math.floor(vim.o.columns * size)
  elseif direction == "horizontal" then
    return math.floor(vim.o.lines * size)
  end
  return nil
end

-- Open window based on direction configuration
local function open_window(direction, size)
  local opts = config.get()
  local win_size = calc_size(direction, size)

  if direction == "vertical" then
    vim.cmd("rightbelow vsplit")
    vim.cmd("enew") -- Create new buffer so we don't share with original window
    if win_size then
      vim.cmd("vertical resize " .. win_size)
    end
  elseif direction == "horizontal" then
    vim.cmd("rightbelow split")
    vim.cmd("enew") -- Create new buffer so we don't share with original window
    if win_size then
      vim.cmd("resize " .. win_size)
    end
  elseif direction == "tab" then
    vim.cmd("tabnew")
  elseif direction == "float" then
    local float_opts = opts.repl.float_opts
    local width = math.floor(vim.o.columns * float_opts.width)
    local height = math.floor(vim.o.lines * float_opts.height)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, true, {
      relative = "editor",
      width = width,
      height = height,
      row = row,
      col = col,
      style = "minimal",
      border = float_opts.border,
    })
    return win, buf
  end

  return vim.api.nvim_get_current_win(), nil
end

-- Start the M2 REPL
function M.start()
  if M.is_running() then
    -- If already running, just show the window
    M.show()
    return
  end

  local opts = config.get()
  local direction = opts.repl.direction
  local size = opts.repl.size

  -- Save current window to return to it
  local current_win = vim.api.nvim_get_current_win()

  -- Open window
  local win, buf = open_window(direction, size)
  state.winid = win

  -- Create terminal buffer if not provided by float
  if buf then
    state.bufnr = buf
    vim.api.nvim_set_current_buf(buf)
  end

  -- Build command
  local cmd = opts.repl.cmd
  if #opts.repl.args > 0 then
    cmd = cmd .. " " .. table.concat(opts.repl.args, " ")
  end

  -- Start terminal
  state.chan = vim.fn.termopen(cmd, {
    on_exit = function()
      state.chan = nil
      state.bufnr = nil
      state.winid = nil
    end,
  })

  -- Store buffer number
  state.bufnr = vim.api.nvim_get_current_buf()

  -- Set buffer options
  vim.api.nvim_buf_set_name(state.bufnr, "Macaulay2 REPL")
  vim.bo[state.bufnr].buflisted = false

  -- Return to original window
  vim.api.nvim_set_current_win(current_win)
end

-- Show REPL window (if hidden)
function M.show()
  if not is_buf_valid() then
    M.start()
    return
  end

  if is_win_valid() then
    -- Already visible
    return
  end

  local opts = config.get()
  local current_win = vim.api.nvim_get_current_win()

  -- Open new window and set buffer
  local win, _ = open_window(opts.repl.direction, opts.repl.size)
  state.winid = win
  vim.api.nvim_win_set_buf(win, state.bufnr)

  -- Return to original window
  vim.api.nvim_set_current_win(current_win)
end

-- Hide REPL window (keep process running)
function M.hide()
  if is_win_valid() then
    vim.api.nvim_win_close(state.winid, false)
    state.winid = nil
  end
end

-- Toggle REPL visibility
function M.toggle()
  if is_win_valid() then
    M.hide()
  else
    M.show()
  end
end

-- Stop the M2 process
function M.stop()
  if state.chan then
    vim.fn.jobstop(state.chan)
  end
  if is_win_valid() then
    vim.api.nvim_win_close(state.winid, true)
  end
  if is_buf_valid() then
    vim.api.nvim_buf_delete(state.bufnr, { force = true })
  end
  state.bufnr = nil
  state.winid = nil
  state.chan = nil
end

-- Send text to the REPL
function M.send(text)
  if not M.is_running() then
    M.start()
    -- Small delay to let M2 start
    vim.defer_fn(function()
      M.send(text)
    end, 100)
    return
  end

  -- Ensure text ends with newline
  if not text:match("\n$") then
    text = text .. "\n"
  end

  vim.api.nvim_chan_send(state.chan, text)
  
  -- Auto-scroll REPL window to bottom if visible
  if is_win_valid() then
    local current_win = vim.api.nvim_get_current_win()
    vim.api.nvim_set_current_win(state.winid)
    vim.cmd("normal! G")
    vim.api.nvim_set_current_win(current_win)
  end
end

-- Send current line to REPL
function M.send_line()
  local line = vim.api.nvim_get_current_line()
  M.send(line)
  
  -- Move to next line
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_win_set_cursor(0, {row + 1, 0})
end

-- Send visual selection to REPL
function M.send_selection()
  -- Get visual selection
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local start_line = start_pos[2]
  local end_line = end_pos[2]

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

  -- Handle character-wise selection
  local mode = vim.fn.visualmode()
  if mode == "v" then
    local start_col = start_pos[3]
    local end_col = end_pos[3]
    if #lines == 1 then
      lines[1] = lines[1]:sub(start_col, end_col)
    else
      lines[1] = lines[1]:sub(start_col)
      lines[#lines] = lines[#lines]:sub(1, end_col)
    end
  end

  local text = table.concat(lines, "\n")
  M.send(text)
end

-- Send entire buffer to REPL
function M.send_buffer()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local text = table.concat(lines, "\n")
  M.send(text)
end

-- Send viewHelp command for word under cursor
function M.help_cursor()
  local word = vim.fn.expand("<cword>")
  if word and word ~= "" then
    M.send("viewHelp " .. word)
  end
end

-- Focus the REPL window
function M.focus()
  if is_win_valid() then
    vim.api.nvim_set_current_win(state.winid)
  elseif M.is_running() then
    M.show()
    if is_win_valid() then
      vim.api.nvim_set_current_win(state.winid)
    end
  else
    M.start()
  end
end

-- Get REPL state (for debugging/testing)
function M.get_state()
  return {
    bufnr = state.bufnr,
    winid = state.winid,
    chan = state.chan,
    is_running = M.is_running(),
  }
end

return M
