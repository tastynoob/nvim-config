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
}
