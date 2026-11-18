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
      vim.lsp.config("pyright", {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
            },
          },
        },
      })

      -- name: LSP 配置名；exe: 可执行文件；required: 缺失时是否提示
      local servers = {
        { name = "clangd", exe = "clangd", required = true },
        { name = "lua_ls", exe = "lua-language-server", required = true },
        { name = "pyright", exe = "pyright-langserver" },
        { name = "mlir_lsp_server", exe = "mlir-lsp-server" },
        { name = "mlir_pdll_lsp_server", exe = "mlir-pdll-lsp-server" },
        { name = "tblgen_lsp_server", exe = "tblgen-lsp-server" },
      }

      local missing = {}
      for _, server in ipairs(servers) do
        if vim.fn.executable(server.exe) == 1 then
          pcall(vim.lsp.enable, server.name)
        elseif server.required then
          missing[#missing + 1] = server.name
        end
      end

      if #missing > 0 then
        vim.notify("[lsp] " .. table.concat(missing, "/") .. " 缺失，装好后重启", vim.log.levels.WARN)
      end
    end,
  },
}
