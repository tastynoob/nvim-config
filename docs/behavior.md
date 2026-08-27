# 行为变化

本文档说明基础编辑选项、显示与诊断策略、文件管理行为，以及停用的内置插件。

## 基础编辑行为

| 类别 | 行为 |
| --- | --- |
| 缩进 | 默认使用空格缩进，`shiftwidth=2`，`tabstop=2`，启用 `autoindent` 与文件类型缩进；关闭全局 `smartindent` 启发式规则。 |
| Python | Python 文件使用 4 空格缩进；补全、跳转与类型诊断由 `pyright` 提供，类型检查级别为 `basic`，格式化由 `black` 提供。 |
| Makefile | `make` 文件类型使用真实 tab。 |
| 撤销 | 启用持久化撤销历史。 |
| 编码 | 文件编码与编辑器编码设置为 UTF-8。 |
| 剪贴板 | 使用系统剪贴板寄存器 `unnamedplus`。 |
| 文件结尾 | 写入文件时保留末尾换行。 |
| 搜索 | 启用 `ignorecase` 与 `smartcase`，大小写敏感规则由搜索词自动决定。 |
| 括号 | 关闭匹配括号显示，避免输入闭合括号时光标短暂跳转。 |
| 补全触发 | 输入 `[`、`]` 时不自动打开补全菜单；字母、下划线及其他有效触发字符仍按 Blink 配置处理。 |
| 分屏 | 水平分屏向下打开，垂直分屏向右打开。 |
| 命令补全 | 启用 `wildmenu`，`wildmode=longest:full,full`。 |
| 滚动 | 光标上下保留 8 行上下文。 |
| 拼写 | 默认关闭拼写检查；`markdown`、`gitcommit`、`text`、`typst` 文件类型启用英语拼写检查。 |
| 注释排版 | `formatoptions=tcqj`，允许 `gq` 排版注释并在合并行时处理注释前缀。 |
| TableGen | `*.td` 文件自动设置为 `tablegen` 文件类型。 |

## 显示行为

| 类别 | 行为 |
| --- | --- |
| 主题 | 使用深色 `gruvbox`，启用真彩色。 |
| 行号 | 显示行号。 |
| 不可见字符 | 启用 `list` 显示。 |
| 状态栏 | `laststatus=2`，始终显示状态栏。 |
| 命令区 | `cmdheight=1`，启用 `showcmd` 与 `ruler`。 |
| 符号列 | `signcolumn=yes`，固定显示符号列。 |
| 图标策略 | 不声明 Nerd Font 图标插件；补全、文件检索、目录浏览、快捷键菜单使用文本或普通字符图标显示。 |
| 快捷键菜单 | `which-key.nvim` 关闭映射图标，特殊键名称使用文本显示。 |

## 诊断行为

| 类别 | 行为 |
| --- | --- |
| 虚拟文本 | 仅显示 `WARN` 及以上级别。 |
| 符号与下划线 | 启用 signs 与 underline。 |
| 插入模式更新 | 插入模式中更新诊断显示。 |
| 排序 | 按严重程度排序。 |
| 浮窗 | 使用圆角边框，并显示诊断来源。 |

## 文件管理行为

`netrw` 系列插件已停用。目录 buffer 由 `oil.nvim` 接管，普通模式 `-` 打开父级目录。Oil 不显示图标列。

左侧文件树由 `nvim-tree.lua` 提供。`<leader>e` 打开或关闭文件树，`<leader>E` 在文件树中定位当前文件。文件树使用普通字符区分文件、文件夹、空文件夹、软链接与修改状态，目录名显示尾部 `/`。

## 停用的内置插件

| 类别 | 插件 |
| --- | --- |
| 文件浏览器 | `netrw`、`netrwPlugin`、`netrwSettings`、`netrwFileHandlers` |
| 压缩包 | `gzip`、`zip`、`zipPlugin`、`tar`、`tarPlugin` |
| 脚本与辅助功能 | `getscript`、`getscriptPlugin`、`vimball`、`vimballPlugin`、`2html_plugin`、`logipat`、`rrhelper`、`spellfile_plugin`、`matchit` |
