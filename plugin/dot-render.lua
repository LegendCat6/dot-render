vim.api.nvim_create_user_command('DotOpen', function()
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
