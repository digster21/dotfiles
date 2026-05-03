-- Line numbers
vim.o.relativenumber = false
vim.o.number = true

-- Indentation
vim.o.expandtab = true
vim.o.autoindent = true

-- Scroll behaviour
vim.o.wrap = false
vim.o.sidescrolloff = 2
vim.o.scrolloff = 8

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Cursor line
vim.o.cursorline = true

-- Appearance
vim.o.background = "dark"
vim.o.signcolumn = "yes"

-- Backspace
vim.o.backspace = "indent,eol,start"

-- Clipboard
vim.opt.clipboard:append("unnamedplus")

-- View
vim.o.splitright = true
vim.o.splitbelow = true
