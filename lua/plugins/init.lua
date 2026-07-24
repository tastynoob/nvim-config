return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    -- blink 必须在 LSP 客户端启动前加载，capabilities 才能注入首次协商
    dependencies = { "Saghen/blink.cmp", "mason-org/mason.nvim" },
    config = function()
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })
      vim.lsp.config("clangd", {
        on_attach = function()
          print("clangd server now running")
        end
      })
      local function enable_if_executable(server, executable)
        if vim.fn.executable(executable) == 1 then
          vim.lsp.enable(server)
        end
      end

      vim.lsp.enable('clangd')
      enable_if_executable('mlir_lsp_server', 'mlir-lsp-server')
      enable_if_executable('mlir_pdll_lsp_server', 'mlir-pdll-lsp-server')
      enable_if_executable('tblgen_lsp_server', 'tblgen-lsp-server')
--      vim.lsp.enable('pyrefly')
      vim.lsp.enable('ty')
      vim.lsp.enable('lua_ls')
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
    branch = 'main',
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })
      ts.install({
        "bash",
        "c",
        "cpp",
        "json",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "mlir",
        "python",
        "query",
        "regex",
        "scala",
        "tablegen",
        "vim",
        "vimdoc",
        "yaml",
      })

      local highlight_languages = {
        sh = "bash",
        c = "c",
        cpp = "cpp",
        json = "json",
        jsonc = "json",
        lua = "lua",
        markdown = "markdown",
        mlir = "mlir",
        python = "python",
        query = "query",
        sbt = "scala",
        scala = "scala",
        tablegen = "tablegen",
        vim = "vim",
        yaml = "yaml",
      }

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("config-treesitter-highlighting", { clear = true }),
        pattern = vim.tbl_keys(highlight_languages),
        callback = function(args)
          local language = highlight_languages[vim.bo[args.buf].filetype]
          if not language or vim.treesitter.highlighter.active[args.buf] then
            return
          end

          if vim.treesitter.language.add(language) then
            vim.treesitter.start(args.buf, language)
          end
        end,
        desc = "Enable Tree-sitter highlighting for configured languages",
      })
    end,
  },
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonUpdate", "MasonLog" },
    config = function()
      require('mason').setup({})
      -- ensure_installed 的极简实现：缺什么装什么，不引入额外插件
      local registry = require('mason-registry')
      for _, name in ipairs({ 'lua-language-server', 'clangd', 'stylua', 'ty' }) do
        local ok, pkg = pcall(registry.get_package, name)
        if ok and not pkg:is_installed() then
          pkg:install()
        end
      end
    end
  },
  {
    "Saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      keymap = {
        preset = 'super-tab',
      },
      completion = {
        documentation = { auto_show = false },
        menu = {
          draw = {
            columns = { { "label", "label_description", gap = 1 }, { "kind" } },
          },
        },
      },
      sources = {
--        default = { 'lsp', 'path', 'snippets', 'buffer' },
        default = { 'lsp', 'snippets', 'path', 'buffer' },
        per_filetype = {
          lua = { inherit_defaults = true, 'lazydev' },
        },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- 让 lazydev 的补全排在最前
            score_offset = 100,
          },
        },
      },
      fuzzy = {
        implementation = "prefer_rust_with_warning",
        max_typos = function(keyword) return math.floor(#keyword / 4) end,
        sorts = {
          'exact',
          'score',
          'sort_text',
        }
      },
      cmdline = {
        keymap = { preset = 'inherit'},
        completion = { menu = { auto_show = true } },
      },
    },
    opts_extend = { "sources.default" },
  },
  {
    "ibhagwan/fzf-lua",
    cond = function()
      return vim.fn.executable("sk") == 1 or vim.fn.executable("fzf") == 1
    end,
    cmd = function()
      local cmds = { "FzfLua" }
      if vim.fn.executable("global") == 1 then
        vim.list_extend(cmds, {
          "GlobalTags", "GlobalTagsInFilename", "GlobalGrep",
          "GlobalReference", "GlobalDefinition", "GlobalUpdate",
        })
      end
      return cmds
    end,
    config = function()
      local fzf_lua = require("fzf-lua")
      local builtin_previewer = require("fzf-lua.previewer.builtin")
      local global_previewer = builtin_previewer.buffer_or_file:extend()
      -- `global -x --encode-path=' :'` 输出格式: "symbol  line  encoded-path  context"
      -- 路径中的空格/冒号被 %XX 编码，字段可用 %S+ 安全切分
      local function urldecode(s)
        return (s:gsub("%%(%x%x)", function(h)
          return string.char(tonumber(h, 16))
        end))
      end

      local function parse_entry(entry_str)
        local _, line, path = entry_str:match("^(%S+)%s+(%d+)%s+(%S+)")
        if not line then
          return {}
        end
        return { path = urldecode(path), line = tonumber(line), col = 1 }
      end

      function global_previewer:new(o, opts, fzf_win)
        global_previewer.super.new(self, o, opts, fzf_win)
        setmetatable(self, global_previewer)
        return self
      end

      function global_previewer:parse_entry(entry_str)
        return parse_entry(entry_str)
      end

      local function global_update()
        vim.system({ "global", "-u" }, { text = true }, function(obj)
          if obj.code ~= 0 then
            vim.schedule(function()
              vim.notify("global -u failed: " .. (obj.stderr or ""), vim.log.levels.ERROR)
            end)
          end
        end)
      end

      local function create_user_command(user_command, global_opts, nargs)
        local base_cmd = "global " .. global_opts .. " --encode-path=' :' "
        local complete_argv = { "global" }
        vim.list_extend(complete_argv, vim.split(global_opts, " ", { trimempty = true }))
        table.insert(complete_argv, "-c")

        vim.api.nvim_create_user_command(user_command, function(opts)
          -- 只还原 cmdline 补全对空格的转义（\ ␣）；正则转义（\b \. 等）原样保留
          local args = opts.args:gsub("\\ ", " ")
          fzf_lua.files({
            cmd = base_cmd .. vim.fn.shellescape(args),
            prompt = user_command .. "> ",
            actions = {
              ["default"] = function(selected)
                local entry = parse_entry(selected[1])
                if not entry.path then
                  return
                end
                vim.cmd.edit(vim.fn.fnameescape(entry.path))
                -- 跳转到命中行（GTAGS 可能过期，行号钳制到缓冲区内）
                if entry.line then
                  local last = vim.api.nvim_buf_line_count(0)
                  vim.api.nvim_win_set_cursor(0, { math.min(entry.line, last), 0 })
                  vim.cmd("normal! zz")
                end
              end,
            },
            previewer = global_previewer,
          })
        end, {
          nargs = nargs,
          complete = function(arg_lead)
            -- systemlist 的 list 形式不走 shell，无注入风险
            local argv = vim.list_extend(vim.deepcopy(complete_argv), { arg_lead })
            local candidates = vim.fn.systemlist(argv)
            if vim.v.shell_error == 0 then
              return candidates
            end
          end,
        })
      end

      if vim.fn.executable("global") == 1 then
        create_user_command("GlobalTagsInFilename", "-x -P", 1)
        -- not support search tags in files
        -- create_user_command("GlobalTagsInFiles", "-x -f", 1)
        create_user_command("GlobalTags", "-x", 1)
        create_user_command("GlobalGrep", "-x -E", 1)
        create_user_command("GlobalReference", "-x -r", 1)
        create_user_command("GlobalDefinition", "-x -d", 1)

        vim.api.nvim_create_user_command("GlobalUpdate", function()
          global_update()
        end, { nargs = 0 })
      end

      -- calling `setup` is optional for customization
      local fzf_bin = vim.fn.executable("sk") == 1 and "sk" or "fzf"
      require("fzf-lua").setup({
        fzf_bin = fzf_bin,
        defaults = {
          file_icons = false,
          git_icons = false,
        },
      })
    end,
  },
  -- Neoformat
  {
    "sbdchd/neoformat",
    cmd = "Neoformat",
    init = function()
      -- stylua 由 mason 安装，优先级提到默认列表最前
      vim.g.neoformat_enabled_lua = { "stylua" }
    end,
  },
  -- Tmux
  -- set keybinding in tmux and nvim
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
  {
    "stevearc/oil.nvim",
    -- 需要接管目录 buffer（nvim .），官方不推荐懒加载；netrw 已在 settings 中禁用
    lazy = false,
    config = function()
      require("oil").setup({ columns = {} })
      vim.keymap.set("n", "-", function() require("oil").open() end, { desc = "Open parent directory (oil)" })
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    cmd = {
      "NvimTreeToggle", "NvimTreeOpen", "NvimTreeClose",
      "NvimTreeFocus", "NvimTreeFindFile", "NvimTreeRefresh",
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

  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {},
  },
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
    cond = function()
      return vim.fn.executable("perf") == 1
    end,
    cmd = {
      "PerfLoadFlat", "PerfLoadCallGraph", "PerfLoadFlameGraph",
      "PerfAnnotate", "PerfAnnotateFunction", "PerfAnnotateSelection",
      "PerfToggleAnnotations", "PerfHottestLines", "PerfHottestSymbols",
      "PerfHottestCallersFunction", "PerfHottestCallersSelection",
      "PerfCycleFormat", "PerfCacheSave", "PerfCacheLoad", "PerfCacheDelete",
      "PerfPickEvent", "PerfLuaProfileStart", "PerfLuaProfileStop",
    },
    config = function()
      require("perfanno").setup({})
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
    'MagicDuck/grug-far.nvim',
    cmd = { "GrugFar", "GrugFarWithin" },
    config = function ()
      require("grug-far").setup({
      });
    end
  },
  {
    "dlyongemallo/diffview-plus.nvim",
    version = "*",
    cmd = {
      "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles",
      "DiffviewRefresh", "DiffviewFileHistory", "DiffviewLog",
      "DiffviewDiffDirs", "DiffviewDiffFiles", "DiffviewMergeFiles", "DiffviewToggle",
    },
  }
}
