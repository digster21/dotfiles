-- Line numbers
vim.opt.relativenumber = false
vim.opt.number = true

-- Indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true

-- Scroll behaviour
vim.opt.wrap = false
vim.opt.sidescrolloff = 2
vim.opt.scrolloff = 8

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
