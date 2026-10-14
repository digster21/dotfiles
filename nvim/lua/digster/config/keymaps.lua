vim.g.mapleader = " "
vim.g.maplocalleader = ","

local keymap_set = require("digster.utils.keymap_set")

keymap_set("i", "qq", "<ESC>", { desc = "Escape insert mode" })
keymap_set("s", "qq", "<ESC>", { desc = "Escape select mode" })
keymap_set("v", "qq", "<ESC>", { desc = "Escape visual mode" })
keymap_set("t", "qq", "<C-\\><C-n>", { desc = "Escape terminal insert mode" })
keymap_set("n", "x", '"_x', { desc = "Delete single character without copying" })
keymap_set("n", "<leader>$", function() vim.o.wrap = (not vim.o.wrap) end, { desc = "Toggle wrap option" });

keymap_set("n", "<leader>ch", ":nohl<CR>", { desc = "Clear search highlights" })
keymap_set(
    'n',
    '<leader>%',
    [[<cmd>vsplit | term<cr>A]],
    { desc = 'Open terminal in vertical split' }
)
keymap_set(
    'n',
    '<leader>"',
    [[<cmd>split | term<cr>A]],
    { desc = 'Open terminal in horizontal split' }
)
