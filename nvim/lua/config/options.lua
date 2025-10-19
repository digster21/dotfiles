-- Line numbers
vim.opt.relativenumber = true
vim.opt.number = true

-- Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

-- Line wrapping
vim.opt.wrap = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true -- re-enables case sensitive search automatically

-- Cursor line
vim.opt.cursorline = true

-- Appearance
vim.opt.background = "dark"
vim.opt.signcolumn = "yes"

-- Backspace
vim.opt.backspace = "indent,eol,start"

-- Clipboard
vim.opt.clipboard:append("unnamedplus")

-- View
vim.opt.splitright = true
vim.opt.splitbelow = true
