return {
  {
    "nvim-tree/nvim-tree.lua",
    cmd = {
      "NvimTreeToggle",
      "NvimTreeOpen",
      "NvimTreeClose",
      "NvimTreeFocus",
      "NvimTreeFindFile",
      "NvimTreeRefresh",
    },
    opts = {
      disable_netrw = true,
      hijack_netrw = true,
      view = {
        side = "left",
        width = 32,
      },
      renderer = {
        add_trailing = true,
        group_empty = true,
        indent_markers = {
          enable = true,
        },
        icons = {
          web_devicons = {
            file = {
              enable = false,
              color = false,
            },
            folder = {
              enable = false,
              color = false,
            },
          },
          padding = {
            icon = " ",
            folder_arrow = " ",
          },
          glyphs = {
            default = "F",
            symlink = "L",
            modified = "M",
            folder = {
              arrow_closed = ">",
              arrow_open = "v",
              default = "D",
              open = "O",
              empty = "E",
              empty_open = "e",
              symlink = "L",
              symlink_open = "l",
            },
          },
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = false,
            modified = true,
            diagnostics = false,
            bookmarks = false,
          },
        },
      },
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      filters = {
        dotfiles = false,
      },
    },
  },
}
