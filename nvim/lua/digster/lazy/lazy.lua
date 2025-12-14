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
    { import = "digster.lazy.plugins.mason" },
    { import = "digster.lazy.plugins.treesitter" },
    { import = "digster.lazy.plugins.telescope" },
    { import = "digster.lazy.plugins.neotree" },
    { import = "digster.lazy.plugins.cmp" },
    { import = "digster.lazy.plugins.conform" },
    { import = "digster.lazy.plugins.sensible" },
    { import = "digster.lazy.plugins.autopairs" },
    { import = "digster.lazy.plugins.gitsigns" },
    { import = "digster.lazy.plugins.indent" },
    { import = "digster.lazy.plugins.eyeliner" },
    { import = "digster.lazy.plugins.comment" },
    { import = "digster.lazy.themes.tokyonight" },
    { import = "digster.lazy.themes.kanagawa" },
})

vim.cmd.colorscheme("tokyonight")
