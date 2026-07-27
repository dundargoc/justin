-- Unmap ]C [C from vim-unimpaired
vim.cmd[[
  if maparg('[C')
    unmap [C
    unmap [CC
    unmap ]C
    unmap ]CC
  endif
]]
