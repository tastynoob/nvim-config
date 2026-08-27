# 快捷键说明

本文档说明本配置新增、覆盖与插件预设引入的快捷键。

依赖外部命令的快捷键按需注册。缺少 `fzf`/`sk`、`rg` 等命令时，对应快捷键不会出现在 `which-key` 菜单中。

## 全局前缀

| 键 | 作用 |
| --- | --- |
| `\` | Leader。 |
| `\` | LocalLeader。 |

## 普通模式与可视模式

| 模式 | 键 | 动作 |
| --- | --- | --- |
| 普通、可视 | `<leader>F` | 执行 `:Neoformat`，格式化当前缓冲区或选区；Python 文件使用 `black`。 |

## 普通模式

| 键 | 动作 |
| --- | --- |
| `K` | 显示 LSP hover 信息。 |
| `ga` | 执行 LSP code action。 |
| `gR` | 执行 LSP rename。 |
| `gD` | 跳转到 LSP declaration。 |
| `<leader>e` | 打开或关闭左侧文件树。 |
| `<leader>E` | 在左侧文件树中定位当前文件。 |
| `<C-\>` | 打开或关闭底部终端栏。 |
| `<leader>th` | 打开或关闭底部终端栏。 |
| `<leader>tt` | 打开或关闭浮动终端。 |
| `<leader>tv` | 打开或关闭竖向终端。 |
| `gd` | 存在 `fzf` 或 `sk` 时通过 `FzfLua lsp_definitions` 跳转；缺少时使用内置 LSP definition。 |
| `gr` | 存在 `fzf` 或 `sk` 时通过 `FzfLua lsp_references` 查看引用；缺少时使用内置 LSP references。 |
| `<leader>p` | 打开最近文件列表；仅在存在 `fzf` 或 `sk` 时注册。 |
| `<leader>O` | 搜索 Git 跟踪的项目文件；仅在存在 `fzf` 或 `sk` 时注册。 |
| `<leader>o` | 搜索文件；仅在存在 `fzf` 或 `sk` 时注册。 |
| `<leader>i` | 打开 jumplist；仅在存在 `fzf` 或 `sk` 时注册。 |
| `<leader>b` | 查看 Git 分支；仅在存在 `fzf` 或 `sk` 时注册。 |
| `<leader>f` | 项目内 live grep；仅在同时存在 `fzf`/`sk` 与 `rg` 时注册。 |
| `<leader>q` | 查看缓冲区列表；仅在存在 `fzf` 或 `sk` 时注册。 |
| `<leader>a` | 打开 `FzfLua` 命令总览；仅在存在 `fzf` 或 `sk` 时注册。 |
| `<leader>1` 到 `<leader>9` | 跳转到第 1 到第 9 个 tab。 |
| `<leader>0` | 跳转到第 10 个 tab。 |
| `-` | 使用 Oil 打开父级目录。 |
| `s` | Leap 向前跳转。 |
| `S` | Leap 向后跳转。 |
| `gs` | Leap 双向跳转。 |
| `<C-h>` | 位于 tmux 会话时向左切换 Neovim 窗口或 tmux pane；其他环境中切换到左侧 Neovim 窗口。 |
| `<C-j>` | 位于 tmux 会话时向下切换 Neovim 窗口或 tmux pane；其他环境中切换到下方 Neovim 窗口。 |
| `<C-k>` | 位于 tmux 会话时向上切换 Neovim 窗口或 tmux pane；其他环境中切换到上方 Neovim 窗口。 |
| `<C-l>` | 位于 tmux 会话时向右切换 Neovim 窗口或 tmux pane；其他环境中切换到右侧 Neovim 窗口。 |

## 可视模式与操作符等待模式

| 键 | 动作 |
| --- | --- |
| `s` | Leap 向前跳转。 |
| `S` | Leap 向后跳转。 |
| `gs` | Leap 双向跳转。 |

## 插入模式

| 键 | 动作 |
| --- | --- |
| `<C-a>` | 移动到行首。 |
| `<C-e>` | 移动到行尾；补全菜单上下文中先由 `blink.cmp` 处理取消动作。 |
| `<C-d>` | 删除光标后字符。 |
| `<C-_>` | 发送 `<C-k>`。 |

## 终端模式

| 键 | 动作 |
| --- | --- |
| `<Esc><Esc>` | 返回普通模式，终端保持打开。 |

## 补全预设

`blink.cmp` 启用 `super-tab` 预设；命令行补全继承同一组顶层补全键位。

| 键 | 补全上下文动作 |
| --- | --- |
| `<C-Space>` | 显示补全菜单、显示文档、隐藏文档。 |
| `<C-e>` | 取消补全，随后回退到后续映射。 |
| `<Esc>` | 补全菜单可见时取消补全；补全菜单不可见时执行默认 `Esc` 行为。 |
| `<Tab>` | 接受当前补全项或片段跳转，随后回退。 |
| `<S-Tab>` | 片段反向跳转，随后回退。 |
| `<Up>`、`<Down>` | 选择上一个或下一个补全项。 |
| `<C-p>`、`<C-n>` | 选择上一个或下一个补全项，并允许回退到已有映射。 |
| `<C-b>`、`<C-f>` | 向上或向下滚动补全文档。 |
| `<C-k>` | 显示或隐藏签名帮助，随后回退。 |

## 键位覆盖

配置未显式执行 `vim.keymap.del` 或 `unmap`。键位变化主要来自新增映射、插件默认映射和对已有默认动作的覆盖。

| 项目 | 变化 |
| --- | --- |
| `<leader>` | 从 Neovim 默认的反斜杠前缀显式固定为 `\`。 |
| `-` | 普通模式下交给 Oil 打开父级目录。 |
| `<leader>e`、`<leader>E` | 普通模式下交给 `nvim-tree.lua` 文件树侧边栏。 |
| `s`、`S` | 普通、可视、操作符等待模式下交给 Leap 跳转。 |
| `K` | 普通模式下固定为 LSP hover。 |
| `gd`、`gD`、`gr` | 普通模式下交给 LSP 与可选的 `fzf-lua` 跳转能力处理。 |
| `<C-h>`、`<C-j>`、`<C-k>`、`<C-l>` | 位于 tmux 会话时交给 `tmux.nvim` 处理方向导航；其他环境中映射为 Neovim 窗口导航。 |
| `<C-a>`、`<C-e>`、`<C-d>`、`<C-_>` | 插入模式下增加类 Emacs 编辑键位。 |
