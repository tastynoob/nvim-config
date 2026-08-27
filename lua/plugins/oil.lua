return {
  {
    "stevearc/oil.nvim",
    -- 需要接管目录 buffer（nvim .），官方不推荐懒加载；netrw 已在 settings 中禁用
    lazy = false,
    config = function()
      require("oil").setup({ columns = {} })
      vim.keymap.set("n", "-", function()
        require("oil").open()
      end, { desc = "Open parent directory (oil)" })
    end,
  },
}
