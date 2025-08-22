-- cspell:disable
local M = {}

local function do_translate(text)
  local handle = io.popen('argos-translate --from en --to zh ' .. vim.fn.shellescape(text))
  local result = handle:read("*a")
  handle:close()
  result = result:gsub("%s+$", "")
  return vim.split(result, "\n")
end

local function get_visual_selection()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.fn.getline(start_pos[2], end_pos[2])
  if #lines then
    lines[1] = string.sub(lines[1], start_pos[3])
    lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
  end
  return table.concat(lines, "\n"), start_pos, end_pos
end

local function translate_selection()  -- TODO: test
  local text, _, end_pos = get_visual_selection()
  if text == "" then return end
  local result_lines = do_translate(text)
  local last_line = vim.fn.getline(end_pos[2])
  local indent = last_line:match("^%s*") or ""
  local cs = vim.bo.commentstring
  if cs == "" or not cs:find("%%s") then
    for i, line in ipairs(result_lines) do
      result_lines[i] = indent .. line
    end
  else
    for i, line in ipairs(result_lines) do
      result_lines[i] = indent .. cs:gsub("%%s", line)
    end
  end
  vim.fn.append(end_pos[2], result_lines)
  -- translate test
  -- 翻译测试
end

local function translate_selection2()  -- TODO: test
  local text, _, _ = get_visual_selection()
  if text == "" then return end
  local result_lines = do_translate(text)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, result_lines)
  local width = math.floor(vim.o.columns * 0.6)
  local height = math.min(#result_lines, math.floor(vim.o.lines * 0.3))
  local win = vim.api.nvim_open_win(buf, true, { relative = "cursor", width = width, height = height, row = 1, col = 0, style = "minimal", border = "rounded" })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '', { nowait = true, noremap = true, silent = true, callback = function() vim.api.nvim_win_close(win, true) end })
end

function M.setup(_)
  vim.api.nvim_create_user_command("TransArgosInsert", function() translate_selection() end, { range = true })
  vim.api.nvim_create_user_command("TransArgosShow", function() translate_selection2() end, { range = true })
end

return M
