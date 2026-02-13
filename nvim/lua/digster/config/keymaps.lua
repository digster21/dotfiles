vim.g.mapleader = " "
vim.g.maplocalleader = ","

local utils = require("digster.utils")

utils.keymap_set("i", "qq", "<ESC>", { desc = "Escape insert mode" })
utils.keymap_set("s", "qq", "<ESC>", { desc = "Escape select mode" })
utils.keymap_set("v", "qq", "<ESC>", { desc = "Escape visual mode" })
utils.keymap_set("t", "qq", "<C-\\><C-n>", { desc = "Escape terminal insert mode" })
utils.keymap_set("n", "x", '"_x', { desc = "Delete single character without copying" })

utils.keymap_set("n", "<leader>c", ":nohl<CR>", { desc = "Clear search highlights" })
utils.keymap_set(
    'n',
    '<leader>%',
    [[<cmd>vsplit | term<cr>A]],
    { desc = 'Open terminal in vertical split' }
)
utils.keymap_set(
    'n',
    '<leader>"',
    [[<cmd>split | term<cr>A]],
    { desc = 'Open terminal in horizontal split' }
)
