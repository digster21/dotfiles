vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then 
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    "tpope/vim-sensible",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim",
    "folke/tokyonight.nvim",
})

vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.clipboard = "unnamedplus"
vim.cmd("syntax on")

-- Remap escape for insert, visual, and select mode
vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("v", "jk", "<Esc>")
vim.keymap.set("s", "jk", "<Esc>")

-- Telescope mapping
vim.keymap.set("n", "<leader>f", require("telescope.builtin").find_files)

-- Tree sitter config
require("nvim-treesitter.configs").setup({
    highlight = { enabled = true },
    indent = { enabled = true },
})

vim.cmd.colorscheme("tokyonight")

