return {
  {
    "sbdchd/neoformat",
    cmd = "Neoformat",
    init = function()
      -- stylua 由 mason 安装，优先级提到默认列表最前
      vim.g.neoformat_enabled_lua = { "stylua" }
      vim.g.neoformat_enabled_python = { "black" }
    end,
  },
}
