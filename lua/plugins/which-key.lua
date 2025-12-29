require("which-key").add({
  {
    "<leader>-",
    mode = {"n", "v"},
    "<cmd>Yazi<cr>",
    desc = "Open yazi at the current file",
  },
  {
    "<leader>cw",
    "<cmd>Yazi<cr>",
    desc = "Open the file manager in nvim's working directory",
  },
  {
    "<c-up>",
    "<cmd>Yazi toggle<cr>",
    desc = "Resume the last yazi session",
  },
  {
    mode = { "v" },
    nowait = true,
    remap = true,
  },
  {
    mode = { "n" },
    nowait = true,
    remap = true,
    --- lsp {{{
    {"K", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "Hover object"},
    {"ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "Code actions"},
    {"gR", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "Rename an object"},
    {"gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", desc = "Go to declaration"},
    --- }}}

    --- fzf-lua {{{
    {"gd", "<cmd>lua require('fzf-lua').lsp_definitions({jump1=true})<CR>", desc = "Goto declaration"},
    {"gr", "<cmd>lua require('fzf-lua').lsp_references({jump1=true})<CR>", desc = "Goto declaration"},
    {"<leader>p", "<cmd>FzfLua oldfiles<CR>", desc = "Show recent files"},
    {"<leader>O", "<cmd>FzfLua git_files<CR>", desc = "Search for a file in project"},
    {"<leader>o", "<cmd>FzfLua files<CR>", desc = "Search for a file (ignoring git-ignore)"},
    {"<leader>i", "<cmd>FzfLua jumps<CR>", desc = "Show jumplist (previous locations)"},
    {"<leader>b", "<cmd>FzfLua git_branches<CR>", desc = "Show git branches"},
    {"<leader>f", "<cmd>FzfLua live_grep<CR>", desc = "Find a string in project"},
    {"<leader>q", "<cmd>FzfLua buffers<CR>", desc = "Show all buffers"},
    {"<leader>a", "<cmd>FzfLua<CR>", desc = "Show all commands"},
    --- }}}

    -- leader tabe{{{
    {"<leader>1", "<esc>1gt<cr>", desc = "tab 1"},
    {"<leader>2", "<esc>2gt<cr>", desc = "tab 2"},
    {"<leader>3", "<esc>3gt<cr>", desc = "tab 3"},
    {"<leader>4", "<esc>4gt<cr>", desc = "tab 4"},
    {"<leader>5", "<esc>5gt<cr>", desc = "tab 5"},
    {"<leader>6", "<esc>6gt<cr>", desc = "tab 6"},
    {"<leader>7", "<esc>7gt<cr>", desc = "tab 7"},
    {"<leader>8", "<esc>8gt<cr>", desc = "tab 8"},
    {"<leader>9", "<esc>9gt<cr>", desc = "tab 9"},
    {"<leader>0", "<esc>10gt<cr>", desc = "tab 11"}
    --}}}
  },
  {
    mode = { "i" },
    nowait = true,
    remap = true,
    {
    -- insert mode set Emacs {{{
    {"<C-a>", "<home>", desc = "Emacs home"},
    {"<C-e>", "<end>", desc = "Emacs end"},
    {"<C-d>", "<del>", desc = "Emacs del"},
    {"<C-_>", "<C-k>", desc = "Emacs C-k"},
    --- }}}
    }
  }
})
