local M = {}

local pkg_name = 'front-matter.nvim'
local bin_name = pkg_name

local function pkg_data_path()
  ---@diagnostic disable-next-line
  return vim.fs.joinpath(vim.fn.stdpath('data'), pkg_name)
end

---@class Config
---@field front_matter_path string
local default_config = {
  front_matter_path = vim.fs.joinpath(pkg_data_path(), bin_name),
}

---@type Config
---@diagnostic disable-next-line
local config = {}

local function front_matter_path()
  return config.front_matter_path
end

local chan

local function ensure_job()
  if chan then
    return chan
  end
  chan = vim.fn.jobstart({ front_matter_path() }, { rpc = true })
  return chan
end

---@param paths string[]
---@return table<string,any>|nil
function M.get(paths)
  for i, path in ipairs(paths) do
    paths[i] = vim.fn.fnamemodify(path, ':p')
  end
  local ok, res = pcall(vim.fn.rpcrequest, ensure_job(), 'front_matter', paths)
  if not ok then
    vim.notify(res, vim.log.levels.WARN)
    return nil
  end

  return res
end

function M.setup(opts)
  config = vim.tbl_deep_extend('force', default_config, opts or {})
end

return M
