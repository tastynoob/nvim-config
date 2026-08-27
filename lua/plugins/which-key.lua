return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      icons = {
        mappings = false,
        keys = {
          Up = "Up ",
          Down = "Down ",
          Left = "Left ",
          Right = "Right ",
          C = "C-",
          M = "M-",
          D = "D-",
          S = "S-",
          CR = "Enter ",
          Esc = "Esc ",
          ScrollWheelDown = "ScrollDown ",
          ScrollWheelUp = "ScrollUp ",
          NL = "Enter ",
          BS = "BS ",
          Space = "Space ",
          Tab = "Tab ",
          F1 = "F1 ",
          F2 = "F2 ",
          F3 = "F3 ",
          F4 = "F4 ",
          F5 = "F5 ",
          F6 = "F6 ",
          F7 = "F7 ",
          F8 = "F8 ",
          F9 = "F9 ",
          F10 = "F10 ",
          F11 = "F11 ",
          F12 = "F12 ",
        },
      },
    },
    config = function(_, opts)
      require("which-key").setup(opts)
      require("keymaps.which-key")
    end,
  },
}
