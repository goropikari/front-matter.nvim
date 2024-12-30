# front-matter.nvim

`front-matter.nvim` is a Neovim plugin that parses front matter from Markdown files and returns it as a Lua table. This plugin is designed for developers who work with Markdown files containing YAML or TOML front matter.

## Features

- Parse front matter from Markdown files.
- Return parsed front matter as a Lua table.

## Installation

[lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  'goropkikari/front-matter.nvim',
  opts = {},
  build = 'make setup',
}
```
## Usage

To parse front matter from a list of file paths:

```lua
local front_matter = require('front-matter')

local result = front_matter.get({
  '/path/to/markdown1.md',
  '/path/to/markdown2.md',
})

print(vim.inspect(result))
```

### Parameters for `front_matter.get`

- **`paths`** (array of strings): A list of file paths to Markdown files.

### Return Value

The function returns a Lua table containing the parsed front matter. If an error occurs, a warning is logged, and the result is `nil`.

## License

This plugin is licensed under the MIT License.
