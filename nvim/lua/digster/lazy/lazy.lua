local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    { import = "digster.lazy.plugins" },
    { import = "digster.lazy.themes" },
}, {
    change_detection = {
        notify = false,
    },
})

vim.cmd.colorscheme("kanagawa")
