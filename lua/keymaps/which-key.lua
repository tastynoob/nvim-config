local wk = require("which-key")

local function executable(name)
  return vim.fn.executable(name) == 1
end

local has_fzf = executable("sk") or executable("fzf")

local maps = {
  {
    "<leader>F",
    mode = { "n", "v" },
    ":Neoformat<cr>",
    desc = "Format buffer / selection",
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
    { "K", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "Hover object" },
    { "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "Code actions" },
    { "gR", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "Rename an object" },
    { "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", desc = "Go to declaration" },
    { "<leader>1", "<esc>1gt", desc = "tab 1" },
    { "<leader>2", "<esc>2gt", desc = "tab 2" },
    { "<leader>3", "<esc>3gt", desc = "tab 3" },
    { "<leader>4", "<esc>4gt", desc = "tab 4" },
    { "<leader>5", "<esc>5gt", desc = "tab 5" },
    { "<leader>6", "<esc>6gt", desc = "tab 6" },
    { "<leader>7", "<esc>7gt", desc = "tab 7" },
    { "<leader>8", "<esc>8gt", desc = "tab 8" },
    { "<leader>9", "<esc>9gt", desc = "tab 9" },
    { "<leader>0", "<esc>10gt", desc = "tab 10" },
    { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" },
    { "<leader>E", "<cmd>NvimTreeFindFile<CR>", desc = "Reveal current file in tree" },
    { "<leader>t", group = "Terminal" },
    { "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "Toggle terminal panel" },
    { "<leader>tt", "<cmd>ToggleTerm direction=float<CR>", desc = "Toggle floating terminal" },
    { "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", desc = "Toggle vertical terminal" },
  },
  {
    mode = { "i" },
    nowait = true,
    remap = true,
    { "<C-a>", "<home>", desc = "Emacs home" },
    { "<C-e>", "<end>", desc = "Emacs end" },
    { "<C-d>", "<del>", desc = "Emacs del" },
    { "<C-_>", "<C-k>", desc = "Emacs C-k" },
  },
}

if has_fzf then
  vim.list_extend(maps, {
    { "gd", "<cmd>FzfLua lsp_definitions jump1=true<CR>", desc = "Goto definition", mode = { "n" }, remap = true },
    { "gr", "<cmd>FzfLua lsp_references jump1=true<CR>", desc = "Goto references", mode = { "n" }, remap = true },
    { "<leader>p", "<cmd>FzfLua oldfiles<CR>", desc = "Show recent files" },
    { "<leader>O", "<cmd>FzfLua git_files<CR>", desc = "Search for a file in project" },
    { "<leader>o", "<cmd>FzfLua files<CR>", desc = "Search for a file" },
    { "<leader>i", "<cmd>FzfLua jumps<CR>", desc = "Show jumplist" },
    { "<leader>b", "<cmd>FzfLua git_branches<CR>", desc = "Show git branches" },
    { "<leader>q", "<cmd>FzfLua buffers<CR>", desc = "Show all buffers" },
    { "<leader>a", "<cmd>FzfLua<CR>", desc = "Show all commands" },
  })

  if executable("rg") then
    table.insert(maps, { "<leader>f", "<cmd>FzfLua live_grep<CR>", desc = "Find a string in project" })
  end
else
  vim.list_extend(maps, {
    { "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", desc = "Goto definition", mode = { "n" }, remap = true },
    { "gr", "<cmd>lua vim.lsp.buf.references()<CR>", desc = "Goto references", mode = { "n" }, remap = true },
  })
end

if not (executable("tmux") and vim.env.TMUX ~= nil) then
  vim.list_extend(maps, {
    { "<C-h>", "<C-w>h", desc = "Move to left window", mode = { "n" }, remap = true },
    { "<C-j>", "<C-w>j", desc = "Move to lower window", mode = { "n" }, remap = true },
    { "<C-k>", "<C-w>k", desc = "Move to upper window", mode = { "n" }, remap = true },
    { "<C-l>", "<C-w>l", desc = "Move to right window", mode = { "n" }, remap = true },
  })
end

wk.add(maps)
