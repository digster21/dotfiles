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
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
    end,
}
