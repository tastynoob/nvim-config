# 插件说明

本文档说明插件管理方式、插件清单、LSP、Tree-sitter 与补全配置。

## 插件管理

`lazy.nvim` 在首次启动时自动安装到 Neovim 数据目录。插件配置由 `lua/config/lazy.lua` 导入 `lua/plugins/init.lua`。

插件更新检查关闭：

```lua
checker = { enabled = false }
```

首次安装插件时使用 `gruvbox` 作为安装阶段配色方案。

部分插件依赖外部命令。外部命令不存在时，相关插件不会启用；基础编辑功能继续可用。

## 运行依赖

外部程序清单见 [README](../README.md#需要自行安装的外部工具)。

`mason.nvim` 会检查并安装 `lua-language-server`、`clangd`、`stylua`、`ty`。MLIR、PDLL 与 TableGen 相关语言服务器需要由运行环境提供。

## 插件清单

| 插件 | 加载方式 | 作用 |
| --- | --- | --- |
| `folke/lazy.nvim` | 启动阶段 | 插件管理与自动安装。 |
| `neovim/nvim-lspconfig` | `BufReadPre`、`BufNewFile` | LSP 客户端配置与启用。 |
| `Saghen/blink.cmp` | `InsertEnter`、`CmdlineEnter` | 补全引擎，启用 `super-tab` 键位预设，并使用 release 预编译组件。 |
| `rafamadriz/friendly-snippets` | `blink.cmp` 依赖 | 通用代码片段来源。 |
| `ellisonleao/gruvbox.nvim` | 高优先级启动 | 深色 `gruvbox` 主题。 |
| `nvim-treesitter/nvim-treesitter` | 启动阶段 | Tree-sitter 解析器安装与高亮启用。 |
| `mason-org/mason.nvim` | 文件读取、新文件、Mason 命令 | 外部工具与语言服务器安装管理。 |
| `ibhagwan/fzf-lua` | 存在 `fzf` 或 `sk` 时启用 | 文件、缓冲区、LSP、文本检索界面。 |
| `sbdchd/neoformat` | `Neoformat` 命令 | 格式化命令，Lua 格式化优先使用 `stylua`。 |
| `aserowy/tmux.nvim` | 位于 tmux 会话且存在 `tmux` 时启用 | Neovim 窗口与 tmux pane 方向导航。 |
| `stevearc/oil.nvim` | 启动阶段 | 目录编辑器，接管目录 buffer。 |
| `nvim-tree/nvim-tree.lua` | NvimTree 命令 | 左侧文件树侧边栏，不依赖外部文件管理器。 |
| `andyg/leap.nvim` | `s`、`S`、`gs` | 快速双字符跳转。 |
| `tpope/vim-repeat` | `leap.nvim` 依赖 | 支持重复执行插件动作。 |
| `folke/lazydev.nvim` | Lua 文件 | Neovim Lua 开发补全增强。 |
| `folke/which-key.nvim` | `VeryLazy` | 快捷键注册与提示。 |
| `willothy/flatten.nvim` | 启动阶段 | 从终端打开文件时复用现有 Neovim 实例。 |
| `t-troebst/perfanno.nvim` | 存在 `perf` 时启用 | perf 数据加载、热点行与符号标注。 |
| `MagicDuck/grug-far.nvim` | `GrugFar` 命令 | 项目内搜索与替换。 |
| `dlyongemallo/diffview-plus.nvim` | Diffview 命令 | Git diff、文件历史与目录比较界面。 |

`lazy-lock.json` 还记录了 `plenary.nvim`。当前启用配置未直接声明该插件；注释中的 Metals 配置曾引用它。

## LSP 配置

全局 LSP capabilities 由 `blink.cmp` 注入。当前启用的语言服务器如下：

| 服务器 | 说明 |
| --- | --- |
| `clangd` | C/C++ LSP；连接后输出 `clangd server now running`。 |
| `mlir_lsp_server` | MLIR LSP；存在 `mlir-lsp-server` 时启用。 |
| `mlir_pdll_lsp_server` | MLIR PDLL LSP；存在 `mlir-pdll-lsp-server` 时启用。 |
| `tblgen_lsp_server` | LLVM TableGen LSP；存在 `tblgen-lsp-server` 时启用。 |
| `ty` | Python 类型检查相关 LSP，由 Mason 安装。 |
| `lua_ls` | Lua LSP。 |

`pyrefly` 配置保留为注释，当前未启用。

## Tree-sitter

配置会安装以下解析器：

`bash`、`c`、`cpp`、`json`、`lua`、`luadoc`、`luap`、`markdown`、`markdown_inline`、`mlir`、`python`、`query`、`regex`、`scala`、`tablegen`、`vim`、`vimdoc`、`yaml`。

高亮按文件类型自动启用，覆盖 `sh`、`c`、`cpp`、`json`、`jsonc`、`lua`、`markdown`、`mlir`、`python`、`query`、`sbt`、`scala`、`tablegen`、`vim`、`yaml`。

## 补全配置

补全来源顺序为：

1. `lsp`
2. `snippets`
3. `path`
4. `buffer`

Lua 文件额外启用 `lazydev` 来源，并将其排序分数提高。补全文档默认不自动弹出。

模糊匹配优先使用 Rust 实现；允许错字数量按关键字长度的四分之一向下取整计算。排序顺序为 `exact`、`score`、`sort_text`。

补全菜单显示补全标签、描述与 kind 文本，不显示 Nerd Font 图标。

命令行补全菜单自动显示，并继承顶层补全键位。
