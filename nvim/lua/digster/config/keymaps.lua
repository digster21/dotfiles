vim.g.mapleader = " "

local utils = require("digster.utils")

utils.keymap_set("i", "<leader>q", "<ESC>", { desc = "Exit insert mode" })
utils.keymap_set("s", "<leader>q", "<ESC>", { desc = "Exit select mode" })
utils.keymap_set("v", "<leader>q", "<ESC>", { desc = "Exit visual mode" })
utils.keymap_set("n", "<leader>wp", ":wincmd p<CR>", { desc = "Switch to previous window" })
utils.keymap_set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
utils.keymap_set("n", "x", '"_x', { desc = "Delete single character without copying" })
