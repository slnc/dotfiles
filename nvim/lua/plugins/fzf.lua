return {
  'junegunn/fzf',
  run = function()
    vim.fn['fzf#install']()
  end
}
