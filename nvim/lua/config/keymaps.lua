vim.g.mapleader = " "

vim.keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
vim.keymap.set("s", "jk", "<ESC>", { desc = "Exit select mode with jk" })
vim.keymap.set("v", "jk", "<ESC>", { desc = "Exit visual mode with jk" })
vim.keymap.set("n", "<leader>wp", ":wincmd p<CR>", { desc = "Switch to previous window" })
vim.keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
vim.keymap.set("n", "x", '"_x', { desc = "Delete single character without copying" })

