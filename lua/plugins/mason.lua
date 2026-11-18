return {
  {
    "mason-org/mason.nvim",
    -- 启动时加载：自动刷新 registry，并在后台补装缺失工具
    lazy = false,
    config = function()
      require("mason").setup({})

      local registry = require("mason-registry")
      local packages = {
        "lua-language-server",
        "clangd",
        "stylua",
      }
      if vim.fn.executable("npm") == 1 then
        table.insert(packages, "pyright")
      end

      registry.refresh(function()
        for _, name in ipairs(packages) do
          local ok, pkg = pcall(registry.get_package, name)
          if ok and not pkg:is_installed() and not pkg:is_installing() then
            pkg:install()
          end
        end
      end)
    end,
  },
}
