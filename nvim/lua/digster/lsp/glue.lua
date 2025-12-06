-- LSP configuration based on https://github.com/onosendi/dotfiles

-- Global LSP configurations
require("digster.lsp.common")

-- Language specific configuration/support
require("digster.lsp.lang.lua")
require("digster.lsp.lang.bash")
require("digster.lsp.lang.clangd")
require("digster.lsp.lang.json")
--require("digster.lsp.lang.eslint")
require("digster.lsp.lang.python")
--require("digster.lsp.lang.typescript")
