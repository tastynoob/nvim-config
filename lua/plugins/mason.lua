return {
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonUpdate", "MasonLog" },
    config = function()
      require("mason").setup({})
      -- ensure_installed 的极简实现：缺什么装什么，不引入额外插件
      local registry = require("mason-registry")

      local function install_missing(name, on_success)
        local ok, pkg = pcall(registry.get_package, name)
        if ok and not pkg:is_installed() and not pkg:is_installing() then
          pkg:install({}, function(success)
            if success and on_success then
              vim.schedule(on_success)
            end
          end)
        end
      end

      for _, name in ipairs({ "lua-language-server", "clangd", "stylua" }) do
        install_missing(name)
      end

      if vim.fn.executable("npm") == 1 then
        install_missing("pyright", function()
          pcall(vim.lsp.enable, "pyright")
          pcall(vim.cmd, "silent! LspStart pyright")
        end)
      end
    end,
  },
}
