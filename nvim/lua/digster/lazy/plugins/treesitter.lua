return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        highlight = { enable = true },
        indent = { enable = true },
        ensure_installed = {
            "lua",
            "vim",
            "cmake",
            "c",
            "cpp",
            "python",
            "bash",
            "markdown",
            "json",
            "yaml",
            "csv",
        },
    },
    config = function()
        -- Kickstart language highlighting
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
            pattern = "*",
            callback = function()
                local buf = vim.api.nvim_get_current_buf()
                if not vim.treesitter.highlighter.active[buf] then
                    pcall(vim.treesitter.start, buf)
                end
            end
        })
    end,
}
