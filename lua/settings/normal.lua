local opt, o, g = vim.opt, vim.o, vim.g

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.autoindent = true
opt.smartindent = false
vim.cmd("filetype plugin indent on")

-- 缩进的 filetype 例外：Python 4 空格，Makefile 必须真 tab
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python" },
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "make" },
  callback = function()
    vim.bo.expandtab = false
  end,
})

opt.undofile = true        -- 持久化撤销历史
opt.termguicolors = true   -- 真彩色（gruvbox 等主题需要）

opt.ignorecase = true
opt.joinspaces = false
opt.smartcase = true
opt.showmatch = false

opt.splitbelow = true
opt.splitright = true

opt.wildmenu = true
opt.wildmode = "longest:full,full"

-- Default Plugins {{{
local disabled_built_ins = {
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "gzip",
  "zip",
  "zipPlugin",
  "tar",
  "tarPlugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "2html_plugin",
  "logipat",
  "rrhelper",
  "spellfile_plugin",
  "matchit",
}

for _, plugin in pairs(disabled_built_ins) do
  g["loaded_" .. plugin] = 1
end

-- display
o.list = true
o.number = true
o.laststatus = 2
o.cmdheight = 1
o.showcmd = true
o.ruler = true

-- Encode {{{
o.fileencoding = "utf-8"
o.encoding = "utf-8"
--o.termencoding="utf-8"
--}}}

-- 拼写检查只对文本类文件开启，代码里太吵
opt.spell = false
opt.spelllang = { "en_us" }
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "gitcommit", "text", "typst" },
  callback = function()
    vim.opt_local.spell = true
  end,
})
opt.scrolloff = 8

-- Clipboard {{{
vim.opt.clipboard = "unnamedplus" -- Use system clipboard
vim.opt.fixeol = true            -- 保留文件末尾换行（POSIX 文本文件约定）
-- }}}

-- 格式化策略：j 合并注释行、q 允许 gq 排版注释；不含 o/r，o/O 不自动续注释
opt.formatoptions = "tcqj"

-- 诊断显示策略：virtual_text 只显示 WARN+，INFO/HINT 进 float/signs，避免刷屏
vim.diagnostic.config({
  virtual_text = { severity = { min = vim.diagnostic.severity.WARN } },
  signs = true,
  underline = true,
  update_in_insert = true,
  severity_sort = true,
  float = { border = "rounded", source = true },
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.td",
  callback = function()
    vim.bo.filetype = "tablegen"
  end,
})

vim.o.signcolumn = "yes"
