return {
  {
    "ibhagwan/fzf-lua",
    cond = function()
      return vim.fn.executable("sk") == 1 or vim.fn.executable("fzf") == 1
    end,
    cmd = function()
      local cmds = { "FzfLua" }
      if vim.fn.executable("global") == 1 then
        vim.list_extend(cmds, {
          "GlobalTags",
          "GlobalTagsInFilename",
          "GlobalGrep",
          "GlobalReference",
          "GlobalDefinition",
          "GlobalUpdate",
        })
      end
      return cmds
    end,
    config = function()
      local fzf_lua = require("fzf-lua")
      local builtin_previewer = require("fzf-lua.previewer.builtin")
      local global_previewer = builtin_previewer.buffer_or_file:extend()

      -- `global -x --encode-path=' :'` 输出格式: "symbol  line  encoded-path  context"
      -- 路径中的空格/冒号被 %XX 编码，字段可用 %S+ 安全切分
      local function urldecode(s)
        return (s:gsub("%%(%x%x)", function(h)
          return string.char(tonumber(h, 16))
        end))
      end

      local function parse_entry(entry_str)
        local _, line, path = entry_str:match("^(%S+)%s+(%d+)%s+(%S+)")
        if not line then
          return {}
        end
        return { path = urldecode(path), line = tonumber(line), col = 1 }
      end

      function global_previewer:new(o, opts, fzf_win)
        global_previewer.super.new(self, o, opts, fzf_win)
        setmetatable(self, global_previewer)
        return self
      end

      function global_previewer:parse_entry(entry_str)
        return parse_entry(entry_str)
      end

      local function global_update()
        vim.system({ "global", "-u" }, { text = true }, function(obj)
          if obj.code ~= 0 then
            vim.schedule(function()
              vim.notify("global -u failed: " .. (obj.stderr or ""), vim.log.levels.ERROR)
            end)
          end
        end)
      end

      local function create_user_command(user_command, global_opts, nargs)
        local base_cmd = "global " .. global_opts .. " --encode-path=' :' "
        local complete_argv = { "global" }
        vim.list_extend(complete_argv, vim.split(global_opts, " ", { trimempty = true }))
        table.insert(complete_argv, "-c")

        vim.api.nvim_create_user_command(user_command, function(opts)
          -- 只还原 cmdline 补全对空格的转义（\ ␣）；正则转义（\b \. 等）原样保留
          local args = opts.args:gsub("\\ ", " ")
          fzf_lua.files({
            cmd = base_cmd .. vim.fn.shellescape(args),
            prompt = user_command .. "> ",
            actions = {
              ["default"] = function(selected)
                local entry = parse_entry(selected[1])
                if not entry.path then
                  return
                end
                vim.cmd.edit(vim.fn.fnameescape(entry.path))
                -- 跳转到命中行（GTAGS 可能过期，行号钳制到缓冲区内）
                if entry.line then
                  local last = vim.api.nvim_buf_line_count(0)
                  vim.api.nvim_win_set_cursor(0, { math.min(entry.line, last), 0 })
                  vim.cmd("normal! zz")
                end
              end,
            },
            previewer = global_previewer,
          })
        end, {
          nargs = nargs,
          complete = function(arg_lead)
            -- systemlist 的 list 形式不走 shell，无注入风险
            local argv = vim.list_extend(vim.deepcopy(complete_argv), { arg_lead })
            local candidates = vim.fn.systemlist(argv)
            if vim.v.shell_error == 0 then
              return candidates
            end
          end,
        })
      end

      if vim.fn.executable("global") == 1 then
        create_user_command("GlobalTagsInFilename", "-x -P", 1)
        create_user_command("GlobalTags", "-x", 1)
        create_user_command("GlobalGrep", "-x -E", 1)
        create_user_command("GlobalReference", "-x -r", 1)
        create_user_command("GlobalDefinition", "-x -d", 1)

        vim.api.nvim_create_user_command("GlobalUpdate", function()
          global_update()
        end, { nargs = 0 })
      end

      local fzf_bin = vim.fn.executable("sk") == 1 and "sk" or "fzf"
      require("fzf-lua").setup({
        fzf_bin = fzf_bin,
        defaults = {
          file_icons = false,
          git_icons = false,
        },
      })
    end,
  },
}
