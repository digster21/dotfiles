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
    { import = "digster.plugins.mason" },
    { import = "digster.plugins.treesitter" },
    { import = "digster.plugins.telescope" },
    { import = "digster.plugins.neotree" },
    { import = "digster.plugins.cmp" },
    { import = "digster.plugins.conform" },
    { import = "digster.plugins.theme" },
    { import = "digster.plugins.sensible" },
    { import = "digster.plugins.autopairs" },
    { import = "digster.plugins.gitsigns" },
    { import = "digster.plugins.indent" },
})
