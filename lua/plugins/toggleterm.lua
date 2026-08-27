return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    init = function()
      vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { silent = true, desc = "Exit terminal mode" })
    end,
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<C-\\>", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal panel" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "Toggle terminal panel" },
      { "<leader>tt", "<cmd>ToggleTerm direction=float<CR>", desc = "Toggle floating terminal" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", desc = "Toggle vertical terminal" },
    },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        end
        return math.floor(vim.o.columns * 0.4)
      end,
      open_mapping = [[<c-\>]],
      direction = "horizontal",
      start_in_insert = true,
      persist_size = true,
      shade_terminals = false,
      float_opts = {
        border = "single",
        width = function()
          return math.floor(vim.o.columns * 0.85)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.8)
        end,
      },
    },
  },
}
