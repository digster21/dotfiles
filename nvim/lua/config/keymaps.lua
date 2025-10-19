-- Set <leader>
vim.g.mapleader = " "

-- Mode control
vim.keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
vim.keymap.set("s", "jk", "<ESC>", { desc = "Exit select mode with jk" })
vim.keymap.set("v", "jk", "<ESC>", { desc = "Exit visual mode with jk" })

-- Clear search highlights
vim.keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- Delete single character without copying into register
vim.keymap.set("n", "x", '"_x')

