-- DotOpen Function
vim.api.nvim_create_user_command('DotOpen', function()
  -- Create a temp file for the output
  local output = vim.fn.tempname() .. '.svg'

  -- Read the entire current buffer into a Lua table
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local input_data = table.concat(lines, "\n")

  -- Start the dot job
  local job_id = vim.fn.jobstart({ 'dot', '-Tsvg', '-o', output }, {
    stdin = 'pipe',
    on_exit = function(_, code)
      if code == 0 then
        vim.notify('Rendered → ' .. output, vim.log.levels.INFO)
        vim.fn.jobstart({ 'xdg-open', output }, { detach = true })
      else
        vim.notify('Graphviz render failed', vim.log.levels.ERROR)
      end
    end,
  })

  -- Write buffer contents to the process’s stdin
  vim.fn.chansend(job_id, input_data)
  vim.fn.chanclose(job_id, 'stdin')
end, {})

-- DotSave Function
vim.api.nvim_create_user_command('DotSave', function()
  local input = vim.fn.expand('%')
  local output = vim.fn.expand('%:r') .. '.svg'

  vim.fn.jobstart({ 'dot', '-Tsvg', input, '-o', output }, {
    on_exit = function(_, code)
      if code == 0 then
        vim.notify('Rendered → ' .. output, vim.log.levels.INFO)
        vim.fn.jobstart({ 'xdg-open', output }, { detach = true })
      else
        vim.notify('Graphviz render failed', vim.log.levels.ERROR)
      end
    end
  })
end, {})
