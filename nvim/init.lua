vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.clipboard = "unnamedplus"
vim.cmd("syntax on")


local map = vim.keymap.set
map("i", "hh", "<Esc>")
map("v", "hh", "<Esc>")
map("s", "hh", "<Esc>")
map("o", "hh", "<Esc>")


-- Visual mode copy to sys clipboard
map("v", "<C-c>", '"y :let @+=@*<CR>', { expr = true })
