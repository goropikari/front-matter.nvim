-- luafile %
vim.print(require('front-matter').get({ 'yaml.md', 'toml.md' }))
