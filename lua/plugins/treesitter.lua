return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      -- 不在启动时批量安装 parser：需要某个语言的高亮时按需安装即可：
      --   :TSInstall <lang>
      -- 安装 parser 需要外部 tree-sitter CLI（0.26.1+），未安装时不影响启动，
      -- Neovim 自带的 parser 仍然可以正常使用。

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

          -- parser 不存在时 language.add 返回 nil，这里直接跳过，不报错
          if vim.treesitter.language.add(language) then
            vim.treesitter.start(args.buf, language)
          end
        end,
        desc = "Enable Tree-sitter highlighting for configured languages",
      })
    end,
  },
}
