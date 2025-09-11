# vscode-snippets

These snippets are extracted from [Visual Studio Code](https://github.com/microsoft/vscode).

# Setup

[mini.snippets](https://github.com/nvim-mini/mini.snippets)

```lua
local gen_loader = require('mini.snippets').gen_loader
require('mini.snippets').setup({
  snippets = {
    gen_loader.from_lang({
      lang_patterns = {
        javascriptreact = { 'javascript.json' },
        jsx = { 'javascript.json' },
        typescriptreact = { 'typescript.json' },
        tsx = { 'typescript.json' },
        markdown_inline = { 'markdown.json' },
      }
    }),
  },
})
```

# LICENSE

The snippets are extracted from [Visual Studio Code](https://github.com/microsoft/vscode) and are licensed under the MIT License.
