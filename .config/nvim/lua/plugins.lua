return require('packer').startup(function(use)
  -- TODO: minimalist alternative? https://github.com/savq/paq-nvim
  use'wbthomason/packer.nvim'  -- Packer can manage itself
  use'justinmk/vim-printf'

  -- git clone https://github.com/sunaku/dasht
  -- dasht-docsets-install python
  use'sunaku/vim-dasht'
  vim.cmd([[nnoremap <silent> gK :call Dasht([expand('<cword>'), expand('<cWORD>')])<CR>]])

  use'https://github.com/justinmk/vim-ipmotion.git'
  use'https://github.com/justinmk/vim-gtfo.git'
  use'https://github.com/justinmk/vim-dirvish.git'
  -- Disable netrw, but autoload it for `gx`.
  vim.cmd([[
    let g:loaded_netrwPlugin = 0
    nnoremap <silent> <Plug>NetrwBrowseX :call netrw#BrowseX(expand((exists("g:netrw_gx")? g:netrw_gx : '<cfile>')),netrw#CheckIfRemote())<CR>
    nmap gx <Plug>NetrwBrowseX
  ]])

  use {
    'glacambre/firenvim',
    run = function() vim.fn['firenvim#install'](0) end,
  }
  vim.cmd([[
    nnoremap <D-v> "+p
    inoremap <D-v> <esc>"+pa
  ]])

  use'https://github.com/justinmk/vim-sneak.git'
  vim.cmd([[
    let g:sneak#label = 1
    let g:sneak#use_ic_scs = 1
    let g:sneak#absolute_dir = 1
    map <M-;> <Plug>Sneak_,
  ]])

  use'tpope/vim-characterize'
  use'tpope/vim-scriptease'
  use'tpope/vim-apathy'
  use'tpope/vim-dadbod'

  use{'will133/vim-dirdiff', opt=true}
  use'tpope/vim-fugitive'
  use'junegunn/gv.vim'
  use'tpope/vim-rhubarb'

  use'tpope/vim-surround'
  vim.g.surround_indent = 0
  vim.g.surround_no_insert_mappings = 1

  use'tpope/vim-dispatch'
  vim.g.dispatch_no_tmux_make = 1  -- Prefer job strategy even in tmux.
  vim.cmd([[nnoremap mT mT:FocusDispatch NVIM_LISTEN_ADDRESS= VIMRUNTIME= TEST_FILE=<c-r>% TEST_FILTER= TEST_TAG= make functionaltest<S-Left><S-Left><S-Left><Left>]])
  -- nnoremap <silent> yr  :<c-u>set opfunc=<sid>tmux_run_operator<cr>g@
  -- xnoremap <silent> R   :<c-u>call <sid>tmux_run_operator(visualmode(), 1)<CR>

  use'tpope/vim-repeat'
  use'tpope/vim-eunuch'
  use'tpope/vim-rsi'

  use'tpope/vim-unimpaired'
  use'tommcdo/vim-lion'
  use'tommcdo/vim-exchange'

  use'haya14busa/vim-edgemotion'
  vim.cmd([[
    map <C-j> m'<Plug>(edgemotion-j)
    map <C-k> m'<Plug>(edgemotion-k)
  ]])

  use'tpope/vim-endwise'
  vim.cmd([====[
    inoremap (<CR> (<CR>)<Esc>O
    inoremap {<CR> {<CR>}<Esc>O
    inoremap {; {<CR>};<Esc>O
    inoremap {, {<CR>},<Esc>O
    inoremap [<CR> [<CR>]<Esc>O
    inoremap ([[ ([[<CR>]])<Esc>O
    inoremap ([=[ ([=[<CR>]=])<Esc>O
    inoremap [; [<CR>];<Esc>O
    inoremap [, [<CR>],<Esc>O
  ]====])

  use'tpope/vim-obsession'
  vim.g.obsession_no_bufenter = 1  -- https://github.com/tpope/vim-obsession/issues/40

  use'AndrewRadev/linediff.vim'
  vim.g.linediff_buffer_type = 'scratch'
  use{'mbbill/undotree', opt=true}

  use'tpope/vim-commentary'

  use{'guns/vim-sexp', opt=true}
  use{'guns/vim-clojure-highlight', opt=true}
  vim.g.clojure_fold = 1
  vim.g.sexp_filetypes = ''

  use{'tpope/vim-salve', opt=true}
  vim.g.salve_auto_start_repl = 1
  use{'tpope/vim-fireplace', opt=true}

  use'justinmk/nvim-repl'
  vim.cmd([[
    nmap yx       <Plug>(ReplSend)
    nmap yxx      <Plug>(ReplSendLine)
    xmap <Enter>  <Plug>(ReplSend)
    nnoremap <c-q> :Repl<CR>
  ]])

  use'udalov/kotlin-vim'
  use'leafgarland/typescript-vim'
  use{'PProvost/vim-ps1', opt=true}
  use{'chrisbra/Colorizer', opt=true}

  use{'junegunn/fzf', run='yes n | ./install'}
  use{'junegunn/fzf.vim'}
  vim.g.fzf_command_prefix = 'Fz'

  use'tpope/vim-projectionist'
  -- see derekwyatt/vim-fswitch for more C combos.
  vim.api.nvim_set_var('projectionist_heuristics', {
      ['package.json'] = {
        ['package.json'] = {['alternate'] = {'package-lock.json'}},
        ['package-lock.json'] = {['alternate'] = {'package.json'}},
      },
      ['*.sln'] = {
        ['*.cs'] = {['alternate'] = {'{}.designer.cs'}},
        ['*.designer.cs'] = {['alternate'] = {'{}.cs'}},
      },
      ['/*.c|src/*.c'] = {
        ['*.c'] = {['alternate'] = {'../include/{}.h', '{}.h'}},
        ['*.h'] = {['alternate'] = '{}.c'},
      },
      ['Makefile'] = {
        ['*Makefile'] = {['alternate'] = '{dirname}CMakeLists.txt'},
        ['*CMakeLists.txt'] = {['alternate'] = '{dirname}Makefile'},
      },
    })

  -- Eager-load these plugins so we can override their settings. {{{
  vim.cmd([[
    runtime! plugin/rsi.vim
    runtime! plugin/commentary.vim
  ]])

  -- xxx
  local idk = function()
    use'neovim/nvim-lspconfig'
    local function on_attach()
      vim.cmd([[
        nnoremap <buffer> K <cmd>lua vim.lsp.buf.hover()<cr>
        nnoremap <buffer> crq <cmd>lua vim.diagnostic.setqflist()<cr>
        nnoremap <buffer> crr <cmd>lua vim.lsp.buf.code_action()<cr>
        nnoremap <buffer> gO <cmd>lua vim.lsp.buf.document_symbol()<cr>
        nnoremap <buffer> gd <cmd>lua vim.lsp.buf.definition()<cr>
        nnoremap <buffer> gr <cmd>lua vim.lsp.buf.references()<cr>
        nnoremap <buffer> gi <cmd>lua vim.lsp.buf.implementation()<cr>
        setlocal omnifunc=v:lua.vim.lsp.omnifunc
      ]])
    end
    require'lspconfig'.clangd.setup{
      cmd = { [[/usr/local/opt/llvm/bin/clangd]] },
      on_attach = on_attach,
      on_exit = function(...)
        require'vim.lsp.log'.error('xxx on_exit: '..vim.inspect((...)))
      end,
    }
    require'lspconfig'.tsserver.setup{
      on_attach = on_attach,
    }

    use'nvim-lua/plenary.nvim'
    use'lewis6991/gitsigns.nvim'
    vim.cmd([[
      hi! link GitSignsChange Normal
    ]])
  end

  local function setup_lua_lsp()  -- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#sumneko_lua
    local system_name
    if vim.fn.has('mac') == 1 then
      system_name = 'macOS'
    elseif vim.fn.has('unix') == 1 then
      system_name = 'Linux'
    elseif vim.fn.has('win32') == 1 then
      system_name = 'Windows'
    else
      error('Unsupported system for sumneko')
    end

    local sumneko_root_path = vim.fn.expand('~')..'/dev/lua-language-server'
    local sumneko_binary = sumneko_root_path..'/bin/'..system_name..'/lua-language-server'

    if vim.fn.exepath(sumneko_binary) == '' then
      vim.cmd(string.format('autocmd UIEnter * ++once echom "sumneko_binary not found: %s"', sumneko_binary))
    end

    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, 'lua/?.lua')
    table.insert(runtime_path, 'lua/?/init.lua')

    require'lspconfig'.sumneko_lua.setup {
      cmd = {sumneko_binary, '-E', sumneko_root_path..'/main.lua'};
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT',
            -- Setup your lua path
            path = runtime_path,
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = {'vim'},
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file('', true),
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false,
          },
        },
      },
    }
  end

  idk()
  setup_lua_lsp()

end)
