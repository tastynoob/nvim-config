return {
  {
    "aserowy/tmux.nvim",
    cond = function()
      return vim.fn.executable("tmux") == 1 and vim.env.TMUX ~= nil
    end,
    keys = { "<C-h>", "<C-j>", "<C-k>", "<C-l>" },
    config = function()
      return require("tmux").setup({
        navigation = { enable_default_keybindings = true },
      })
    end,
  },
}
