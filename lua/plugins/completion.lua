return {
  {
    "Saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      keymap = {
        preset = "super-tab",
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
        default = { "lsp", "snippets", "path", "buffer" },
        per_filetype = {
          lua = { inherit_defaults = true, "lazydev" },
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
        max_typos = function(keyword)
          return math.floor(#keyword / 4)
        end,
        sorts = {
          "exact",
          "score",
          "sort_text",
        },
      },
      cmdline = {
        keymap = { preset = "inherit" },
        completion = { menu = { auto_show = true } },
      },
    },
    opts_extend = { "sources.default" },
  },
}
