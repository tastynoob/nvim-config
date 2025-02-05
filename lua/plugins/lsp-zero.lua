local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(
  function(client, bufnr)
    lsp_zero.on_attach({buffer=bufnr})
  end
)

lsp_zero.extend_lspconfig({
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

local metals_config = require("metals").bare_config()
metals_config.capabilities = lsp_zero.get_capabilities()

local metals_augroup = vim.api.nvim_create_augroup('nvim-metals',{clear=true})
vim.api.nvim_create_autocmd('FileType',{
  group = metals_augroup,
  pattern = {'scala', 'sbt', 'java'},
  callback = function ()
    require('metals').initialize_or_attach(metals_config)
  end
})

require("neoconf").setup({})
require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {},
  handlers = {
    lsp_zero.default_setup,
    lua_ls = function ()
      local lua_opts = lsp_zero.nvim_lua_ls()
      require('lspconfig').lua_ls.setup(lua_opts)
    end,
    hls=function ()
      require('lspconfig').hls.setup({
        single_file_support = false,
        on_attach = function (client, bufnr)
          print('hello hls')
        end
      })
    end
  },
})

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()
local cmp_select = {behavior = cmp.SelectBehavior.Select}

require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
  sources = {
    {name = 'path'},
    {name = 'nvim_lsp'},
    {name = 'nvim_lua'},
    {name = 'luasnip', keyword_length = 2},
    {name = 'buffer', keyword_length = 3},
  },
  formatting = lsp_zero.cmp_format(),
  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp_action.luasnip_supertab(),
    ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<CR>'] = cmp.mapping.confirm({select = false}),
  })
})

