# Neovim 配置

本仓库是一份基于 Lua 的 Neovim 配置，使用 `lazy.nvim` 管理插件，并通过 `lazy-lock.json` 锁定插件版本。

配置重点包括：

- LSP、Tree-sitter、补全、格式化等代码编辑能力。
- `fzf-lua`、GNU Global、Leap 等跳转与检索能力。
- Oil 目录编辑入口，以及 `nvim-tree.lua` 文件树侧边栏。
- `toggleterm.nvim` 底部终端栏，以及浮动和竖向终端入口。
- 可选的 tmux pane 与 Neovim 窗口方向导航。
- Git diff、搜索替换、可选的 perf 标注等辅助工具。

## 安装

执行安装脚本：

```sh
./install.sh
```

脚本会将本仓库中的配置文件复制到 Neovim 配置目录，并覆盖同名文件或目录。

## 需要自行安装的外部工具

安装脚本只复制配置文件，不安装系统软件。Neovim 插件由 `lazy.nvim` 安装，`lua-language-server`、`clangd`、`stylua` 由 `mason.nvim` 在 Neovim 内安装；存在 `npm` 时，`pyright` 也由 `mason.nvim` 安装。

以下外部命令需要用户按当前系统的包管理方式自行安装。

### 基础工具

| 程序 | 必要性 | 用途 |
| --- | --- | --- |
| Neovim | 必需 | 运行配置；需要支持 `vim.lsp.config` 与 `vim.lsp.enable`。 |
| `git` | 必需 | 首次启动时拉取 `lazy.nvim`，并支持 Git 相关检索。 |
| `curl` | 必需 | 支持 Mason 下载工具，以及 `blink.cmp` 下载预编译组件。 |
| C 编译器 | 必需 | 构建 Tree-sitter 解析器。 |
| `node` / `npm` | Python LSP | 支持 Mason 安装 `pyright`，用于 Python 补全、跳转与诊断。 |

### 功能工具

| 程序 | 相关功能 | 用途 |
| --- | --- | --- |
| `fzf` 或 `sk` | `fzf-lua` | 作为文件、缓冲区、LSP 结果选择器后端。 |
| `rg` | `fzf-lua live_grep` | 项目文本检索。 |
| `global` | GNU Global 命令 | 支持 `:GlobalTags`、`:GlobalGrep`、`:GlobalReference` 等命令。 |
| `tmux` | tmux 导航 | 支持 tmux pane 与 Neovim 窗口方向导航。 |
| 剪贴板工具 | 系统剪贴板 | 按桌面环境选择 `wl-clipboard`、`xclip` 或 `xsel`。 |
| `perf` | 性能标注 | 支持 `perfanno.nvim` 相关命令。 |
| `black` | Python 格式化 | 为 Python 文件提供格式化。 |
| MLIR / LLVM 工具 | MLIR / TableGen LSP | 提供 `mlir-lsp-server`、`mlir-pdll-lsp-server`、`tblgen-lsp-server`。 |

`fzf`、`sk`、`global`、`tmux`、`perf`、`black` 等工具未安装时，对应功能不会启用。基础编辑、通用 LSP、补全、文件树侧边栏和主题加载不依赖这些工具。

## 文档导航

| 文档 | 内容 |
| --- | --- |
| [插件说明](docs/plugins.md) | 插件管理方式、插件清单、LSP、Tree-sitter、补全来源。 |
| [快捷键说明](docs/keymaps.md) | 新增键位、覆盖键位与插件预设键位。 |
| [行为变化](docs/behavior.md) | 基础编辑选项、显示与诊断策略、文件管理行为、停用的内置插件。 |
| [命令说明](docs/commands.md) | Mason、FzfLua、GNU Global、NvimTree、GrugFar、Diffview、Perf 相关命令。 |

## 配置入口

| 路径 | 作用 |
| --- | --- |
| `init.lua` | 配置入口，加载基础设置与插件管理配置。 |
| `lua/settings/normal.lua` | 基础选项、自动命令、诊断显示策略、内置插件停用策略。 |
| `lua/config/lazy.lua` | `lazy.nvim` 启动、插件导入、Leader 键设置。 |
| `lua/plugins/init.lua` | 插件模块导入列表。 |
| `lua/plugins/*.lua` | 单插件或相关插件组的声明、选项与插件命令。 |
| `lua/keymaps/which-key.lua` | 由 `which-key.nvim` 注册的主要快捷键。 |

## 快速约定

- Leader 与 LocalLeader 均为 `\`。
- 插件模块入口维护在 `lua/plugins/init.lua`。
- 单插件配置维护在 `lua/plugins/*.lua`。
- 主要快捷键集中维护在 `lua/keymaps/which-key.lua`。
- 插件版本变更后更新 `lazy-lock.json`。
