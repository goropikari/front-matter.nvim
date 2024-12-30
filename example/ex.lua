-- luafile %
vim.print(require('front-matter').get({ 'yaml.md', 'toml.md' }))

local res = require('front-matter').get({ 'yaml.md', 'non_exist.md' })
vim.print(type(res))
