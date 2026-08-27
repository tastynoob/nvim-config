return {
  {
    url = "https://codeberg.org/andyg/leap.nvim",
    dependencies = {
      "tpope/vim-repeat",
    },
    -- leap 只定义 <Plug> 映射，必须自己绑键（默认不占用任何键）
    keys = {
      { "s", "<Plug>(leap-forward)", mode = { "n", "x", "o" } },
      { "S", "<Plug>(leap-backward)", mode = { "n", "x", "o" } },
      { "gs", "<Plug>(leap)", mode = { "n", "x", "o" } },
    },
  },
}
