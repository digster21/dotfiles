vim.g.mapleader = " "

local utils = require("digster.utils")

utils.keymap_set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
utils.keymap_set("s", "jk", "<ESC>", { desc = "Exit select mode with jk" })
utils.keymap_set("v", "jk", "<ESC>", { desc = "Exit visual mode with jk" })
utils.keymap_set("n", "<leader>wp", ":wincmd p<CR>", { desc = "Switch to previous window" })
utils.keymap_set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
utils.keymap_set("n", "x", '"_x', { desc = "Delete single character without copying" })
