-- Minimal init used for headless tests (simplified)
local cwd = vim.fn.getcwd()
package.path = package.path .. ";" .. cwd .. "/?.lua"
vim.cmd([[let &rtp.=','.getcwd()]])

-- Prefer plugins exposed under the project .devenv/profile (common devenv layout)
local function add_profile_paths()
  local profile_candidate = cwd .. '/.devenv/profile'
  local resolved = nil
  if vim.fn.isdirectory(profile_candidate) == 1 then
    resolved = vim.fn.resolve(profile_candidate)
  else
    local devroot = os.getenv('DEVENV_ROOT')
    if devroot and devroot ~= '' then
      local p = devroot .. '/.devenv/profile'
      if vim.fn.isdirectory(p) == 1 then
        resolved = vim.fn.resolve(p)
      end
    end
  end

  if resolved and resolved ~= '' then
    local lua_path = resolved .. '/lua'
    if vim.fn.isdirectory(lua_path) == 1 then
      package.path = package.path .. ';' .. lua_path .. '/?.lua;' .. lua_path .. '/?/init.lua'
    end
    vim.cmd(('set rtp+=%s'):format(resolved))
  end
end

add_profile_paths()

-- Configure nvim-treesitter if available (do not attempt installs)
pcall(function()
  local ok, ts = pcall(require, 'nvim-treesitter')
  if ok and ts and type(ts.setup) == 'function' then
    ts.setup()
  end
end)

-- Setup mini.test if available
if #vim.api.nvim_list_uis() == 0 then
  local okm, m = pcall(require, 'mini.test')
  if okm and type(m.setup) == 'function' then
    m.setup()
  end
end