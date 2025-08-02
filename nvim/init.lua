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

local map = vim.keymap.set
map("i", "jj", "<Esc>")
map("v", "jj", "<Esc>")
map("s", "jj", "<Esc>")
map("o", "jj", "<Esc>")


-- Visual mode copy to sys clipboard
map("v", "<C-c>", '"y :let @+=@*<CR>', { expr = true })


require("nvim-treesitter.configs").setup({
    highlight = { enabled = true },
    indent = { enabled = true },
})


vim.cmd.colorscheme("tokyonight")



