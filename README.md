<!-- cspell:ignore orcid -->

# Translate plugin using argos-translate

A NeoVim plugin to translate using argos 

## Installation

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "cxwx/argosTrans.nvim",
    opts = {},
    keys = {
        { "<leader>t1", ":TransArgosInsert<CR>", mode = "v", desc = "insert" },
        { "<leader>t2", ":TransArgosShow<CR>", mode = "v", desc = "show" },
    }
},
```

## Requirement

* `argos-translate`

```
pip install argostranslate
argospm install translate-en_zh
```


## Feature

* Trans English to Chinese


## Commands

The plugin provides the user command `:TransArgosInsert`, `:TransArgosShow`.
Invoke it when the cursor is on the name of a repo.

## TODO

- [ ] other engine(ollama?)
- [ ] language configure
