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
        end,
      })

      local function enable_if_executable(server, executable)
        if vim.fn.executable(executable) == 1 then
          vim.lsp.enable(server)
        end
      end

      vim.lsp.enable("clangd")
      enable_if_executable("mlir_lsp_server", "mlir-lsp-server")
      enable_if_executable("mlir_pdll_lsp_server", "mlir-pdll-lsp-server")
      enable_if_executable("tblgen_lsp_server", "tblgen-lsp-server")
      enable_if_executable("pyright", "pyright-langserver")
      vim.lsp.enable("lua_ls")
    end,
  },
}
