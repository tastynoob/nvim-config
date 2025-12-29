local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  if col == 0 then
    return false
  end

  local text = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
  return text:sub(col, col):match("%s") == nil
end

return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.config("clangd", {
        on_attach = function()
          print("clangd server now running")
        end
      })
      vim.lsp.config("mlir", {
        on_attach = function()
          print("mlir server now running")
        end
      })
      vim.lsp.config("mlir_pdll", {
        on_attach = function()
          print("mlir_pdll server now running")
        end
      })
      vim.lsp.config("tblgen", {
        on_attach = function()
          print("tblgen server now running")
        end
      })
      vim.lsp.enable('clangd')
      vim.lsp.enable('mlir_lsp_server')
      vim.lsp.enable('mlir_pdll_lsp_server')
      vim.lsp.enable('tblgen_lsp_server')
      vim.lsp.enable('pyright')
    end
  },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        terminal_colors = true, -- add neovim terminal colors
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = true,
          emphasis = true,
          comments = true,
          operators = false,
          folds = true,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true, -- invert background for search, diffs, statuslines and errors
        contrast = "", -- can be "hard", "soft" or empty string
        palette_overrides = {},
        overrides = {},
        dim_inactive = false,
        transparent_mode = false,
      })
      vim.o.background = "dark"
      vim.cmd("colorscheme gruvbox")
    end,
  },
  -- TreeSitter config copy from lazyvim {{{
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        init = function()
          require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
          load_textobjects = true
        end,
      },
    },
    opts = {
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        use_languagetree = false,
        disable = function(_, bufnr)
          local buf_name = vim.api.nvim_buf_get_name(bufnr)
          local file_size = vim.api.nvim_call_function("getfsize", { buf_name })
          return file_size > 256 * 1024
        end,
      },
      indent = { enable = true },
      ensure_installed = {
        "bash",
        "c",
        "json",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "vim",
        "vimdoc",
        "yaml",
        "scala",
      },
      incremental_selection = {
        enable = false,
      },
    },
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        ---@type table<string, boolean>
        local added = {}
        opts.ensure_installed = vim.tbl_filter(function(lang)
          if added[lang] then
            return false
          end
          added[lang] = true
          return true
        end, opts.ensure_installed)
      end
      require("nvim-treesitter.configs").setup(opts)

      if load_textobjects then
        -- PERF: no need to load the plugin, if we only need its queries for mini.ai
        if opts.textobjects then
          for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
            if opts.textobjects[mod] and opts.textobjects[mod].enable then
              local Loader = require("lazy.core.loader")
              Loader.disabled_rtp_plugins["nvim-treesitter-textobjects"] = nil
              local plugin = require("lazy.core.config").plugins["nvim-treesitter-textobjects"]
              require("lazy.core.loader").source_runtime(plugin.dir, "plugin")
              break
            end
          end
        end
      end
    end,
  },
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    config = function()
      require('mason').setup({})
    end
  },
  {
    "Saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "L3MON4D3/LuaSnip"
    },
    build = 'cargo build --release',
    opts = {
      keymap = {
        preset = 'super-tab',
      },
      appearance = {
        nerd_font_variant = 'mono'
      },
      completion = {documentation = { auto_show = false }},
      sources = {
--        default = { 'lsp', 'path', 'snippets', 'buffer' },
        default = { 'lsp', 'snippets', 'path', 'buffer' },
      },
      fuzzy = {
        implementation = "prefer_rust_with_warning",
        max_typos = function(keyword) return math.floor(#keyword / 4) end,
        sorts = {
          'exact',
        }
      },
      snippets = {
        preset = 'luasnip'
      },
      cmdline = {
        keymap = { preset = 'inherit'},
        completion = { menu = { auto_show = true } },
      },
    },
    opts_extend = { "sources.default" }
  },
  {
    "smjonas/inc-rename.nvim",
    config = function()
      require("inc_rename").setup()
    end
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local fzf_lua = require("fzf-lua")
      fzf_bin = 'sk'
      local builtin_previewer = require("fzf-lua.previewer.builtin")
      local global_previewer = builtin_previewer.buffer_or_file:extend()
      local function split(str, reps)
        local resultStrList = {}
        string.gsub(str, "[^" .. reps .. "]+", function(w)
          table.insert(resultStrList, w)
        end)
        return resultStrList
      end

      function global_previewer:new(o, opts, fzf_win)
        global_previewer.super.new(self, o, opts, fzf_win)
        setmetatable(self, global_previewer)
        return self
      end

      function global_previewer:parse_entry(entry_str)
        local selected_split = split(entry_str, " ")
        local file_path = selected_split[3]
        local file_lines = selected_split[2]
        return { path = file_path, line = file_lines, col = 1 }
      end

      local function global_update()
        local handle = io.popen("global -u")
        handle:close()
      end

      local function create_user_command(user_command, shell_command, nargs)
        vim.api.nvim_create_user_command(user_command, function(opts)
          fzf_lua.files({
            cmd = shell_command .. opts.args,
            prompt = user_command .. "> ",
            actions = {
              ["default"] = function(selected, o)
                local selected_split = split(selected[1], " ")
                local file = fzf_lua.path.entry_to_file(selected_split[3], o)
                local cmd = string.format("edit %s", file.path)
                vim.cmd(cmd)
              end,
            },
            previewer = global_previewer,
          })
        end, {
          nargs = nargs,
          complete = function(opts)
            local branches = vim.fn.systemlist(shell_command .. " -c " .. opts)
            if vim.v.shell_error == 0 then
              return branches
            end
          end,
        })
      end

      create_user_command("GlobalTagsInFilename", "global -x -P ", 1)
      -- not support search tags in files
      -- create_user_command("GlobalTagsInFiles", "global -x -f ", 1)
      create_user_command("GlobalTags", "global -x ", 1)
      create_user_command("GlobalGrep", "global -x -E ", 1)
      create_user_command("GlobalReference", "global -x -r ", 1)
      create_user_command("GlobalDefinition", "global -x -d ", 1)

      vim.api.nvim_create_user_command("GlobalUpdate", function()
        global_update()
      end, { nargs = 0 })

      -- calling `setup` is optional for customization
      require("fzf-lua").setup({})
    end,
  },
  -- Neoformat
  {
    "sbdchd/neoformat",
  },
  -- Tmux
  -- set keybinding in tmux and nvim
  {
    "aserowy/tmux.nvim",
    configs = function()
      return require("tmux").setup()
    end,
  },
  {
    "stevearc/oil.nvim",
    opts = function() end,
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "ggandor/leap.nvim",
    dependencies = {
      "tpope/vim-repeat",
    },
  },

  {
    "folke/lazydev.nvim",
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function ()
      require("plugins.which-key")
    end
  },
  -- enhance open file from terminal
  {
    "willothy/flatten.nvim",
    config = true,
    lazy = false,
    priority = 1001,
  },
  {
    "t-troebst/perfanno.nvim",
    config = function()
      require("perfanno").setup({})
    end,
  },
  {
    "smjonas/inc-rename.nvim",
    config = function()
      require("inc_rename").setup()
    end,
  },
--  {
--    "scalameta/nvim-metals",
--    dependencies = {
--      "nvim-lua/plenary.nvim",
--    },
--    ft = { "scala", "sbt", "java" },
--    opts = function()
--      local metals_config = require("metals").bare_config()
--        metals_config.on_attach = function(client, bufnr)
--        -- your on_attach function
--      end
--
--      return metals_config
--    end,
--    config = function(self, metals_config)
--      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
--      vim.api.nvim_create_autocmd("FileType", {
--        pattern = self.ft,
--        callback = function()
--          require("metals").initialize_or_attach(metals_config)
--        end,
--        group = nvim_metals_group,
--      })
--    end
--  },
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    -- @type YaziConfig
    opts = {
      open_for_directories = false,
      keymaps = {
        show_help = "<f2>",
      }
    }
  },
  {
    'MagicDuck/grug-far.nvim',
    config = function ()
      require("grug-far").setup({
      });
    end
  },
}
