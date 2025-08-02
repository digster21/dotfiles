vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.clipboard = "unnamedplus"
vim.cmd("syntax on")


local map = vim.keymap.set
map("i", "jj", "<Esc>")
map("v", "jj", "<Esc>")
map("s", "jj", "<Esc>")
map("o", "jj", "<Esc>")


-- Visual mode copy to sys clipboard
map("v", "<C-c>", '"y :let @+=@*<CR>', { expr = true })
