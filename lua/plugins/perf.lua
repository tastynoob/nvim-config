return {
  {
    "t-troebst/perfanno.nvim",
    cond = function()
      return vim.fn.executable("perf") == 1
    end,
    cmd = {
      "PerfLoadFlat",
      "PerfLoadCallGraph",
      "PerfLoadFlameGraph",
      "PerfAnnotate",
      "PerfAnnotateFunction",
      "PerfAnnotateSelection",
      "PerfToggleAnnotations",
      "PerfHottestLines",
      "PerfHottestSymbols",
      "PerfHottestCallersFunction",
      "PerfHottestCallersSelection",
      "PerfCycleFormat",
      "PerfCacheSave",
      "PerfCacheLoad",
      "PerfCacheDelete",
      "PerfPickEvent",
      "PerfLuaProfileStart",
      "PerfLuaProfileStop",
    },
    config = function()
      require("perfanno").setup({})
    end,
  },
}
