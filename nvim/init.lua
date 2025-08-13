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
    {
        "nvim-treesitter/nvim-treesitter", 
        branch = 'master',
        lazy = false, 
        build = ":TSUpdate",
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons",
            lazy = false,
        },
    },
    "folke/tokyonight.nvim",
})

vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.clipboard = "unnamedplus"
vim.cmd("syntax on")

-- Remap escape for insert, visual, and select mode
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })
vim.keymap.set("v", "jk", "<Esc>", { noremap = true, silent = true })
vim.keymap.set("s", "jk", "<Esc>", { noremap = true, silent = true })

-- Telescope config
local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", telescope.git_files, { desc = "Telescope find file by name (git ls-files)", noremap = true, silent = true }) 
vim.keymap.set("n", "<leader>fr", function() telescope.live_grep{ additional_args = function() return { "--hidden", "--no-ignore" } end, } end, { desc = "Telescope find file by contents (ripgrep regex)", noremap = true, silent = true })
vim.keymap.set("n", "<leader>fs", function() telescope.live_grep{ additional_args = function() return { "--hidden", "--no-ignore", "--fixed-strings", "-i" } end, } end, { desc = "Telescope find file by contents (ripgrep insensitive string)", noremap = true, silent = true })
-- NeoTree config
require("neo-tree").setup({
    close_if_last_window = true,
    filesystem = {
        filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = false,
        },
    },
})
vim.keymap.set("n", "<leader>tt", ":Neotree filesystem toggle<CR>", { desc = "Neotree Toggle filesystem tree", noremap = true, silent = true })
vim.keymap.set("n", "<leader>tg", ":Neotree git_status toggle<CR>", { desc = "Neotree Toggle git status tree", noremap = true, silent = true })

-- Treesitter config
require("nvim-treesitter.configs").setup({
    highlight = { enabled = true },
    indent = { enabled = true },
})

vim.cmd.colorscheme("tokyonight")

