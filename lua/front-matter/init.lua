local M = {}

local pkg_name = 'front-matter.nvim'
local bin_name = pkg_name

local default_config = {
  data_path = vim.fs.joinpath(vim.fn.stdpath('data'), pkg_name),
  front_matter_path = vim.fs.joinpath(vim.fn.stdpath('data'), pkg_name, bin_name),
}
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
---@return table<string,any>
function M.get(paths)
  for i, path in ipairs(paths) do
    paths[i] = vim.fn.fnamemodify(path, ':p')
  end
  local ok, res = pcall(vim.fn.rpcrequest, ensure_job(), 'front_matter', paths)
  if not ok then
    vim.notify(res, vim.log.levels.WARN)
  end

  return res
end

function M.setup(opts)
  config = vim.tbl_deep_extend('force', default_config, opts or {})
  vim.fn.mkdir(config.data_path, 'p')
end

return M
