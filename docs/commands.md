# 命令说明

本文档说明本配置引入的用户命令。

依赖外部命令的插件按需启用。外部命令不存在时，对应命令不会注册。

## 插件命令

| 命令 | 来源 | 作用 |
| --- | --- | --- |
| `:Mason`、`:MasonInstall`、`:MasonUpdate` 等 | `mason.nvim` | 管理外部工具与语言服务器。 |
| `:Neoformat` | `neoformat` | 格式化当前缓冲区或选区；Python 文件使用 `black`。 |
| `:FzfLua` | `fzf-lua` | 打开 fzf-lua 功能选择器；需要 `fzf` 或 `sk`。 |
| `:NvimTreeToggle`、`:NvimTreeFindFile`、`:NvimTreeFocus` 等 | `nvim-tree.lua` | 打开、定位和聚焦左侧文件树。 |
| `:GrugFar`、`:GrugFarWithin` | `grug-far.nvim` | 搜索与替换。 |
| `:DiffviewOpen`、`:DiffviewFileHistory`、`:DiffviewLog` 等 | `diffview-plus.nvim` | Git diff、历史与比较界面。 |
| `:PerfLoadFlat`、`:PerfAnnotate`、`:PerfHottestLines` 等 | `perfanno.nvim` | 加载 perf 数据并进行性能热点标注；需要 `perf`。 |

## GNU Global 命令

存在 `global` 且 `fzf-lua` 已启用时，以下命令由配置自行注册，并使用 `fzf-lua` 展示结果：

| 命令 | 作用 |
| --- | --- |
| `:GlobalTags {symbol}` | 使用 GNU Global 查找 tag。 |
| `:GlobalTagsInFilename {pattern}` | 使用 GNU Global 按文件名模式查找 tag。 |
| `:GlobalGrep {regex}` | 使用 GNU Global 正则检索。 |
| `:GlobalReference {symbol}` | 使用 GNU Global 查找引用。 |
| `:GlobalDefinition {symbol}` | 使用 GNU Global 查找定义。 |
| `:GlobalUpdate` | 异步执行 `global -u` 更新 tag 数据库。 |

GNU Global 查询结果使用 `global -x --encode-path=' :'` 输出格式。配置会解析路径与行号，打开文件后跳转到命中行并居中显示。
