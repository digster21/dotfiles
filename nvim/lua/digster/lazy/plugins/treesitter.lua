local utils = require("digster.utils")

return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            highlight = { enable = true },
            indent = { enable = true },
            ensure_installed = {
                "bash",
                "c",
                "cpp",
                "cmake",
                "diff",
                "html",
                "javascript",
                "jsdoc",
                "json",
                "jsonc",
                "lua",
                "luadoc",
                "luap",
                "markdown",
                "markdown_inline",
                "rst",
                "printf",
                "python",
                "query",
                "regex",
                "toml",
                "tsx",
                "typescript",
                "vim",
                "vimdoc",
                "xml",
                "yaml",
                "csv",
            },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        config = function()
            local ts_to = require("nvim-treesitter-textobjects.move")

            utils.keymap_set({ "n", "x", "o" }, "]m", function()
                local ok, err = pcall(function()
                    ts_to.goto_next_start("@function.outer", "textobjects")
                end)

                if not ok then
                    print(tostring(err))
                end
            end, { desc = "Go to next function start" })

            utils.keymap_set({ "n", "x", "o" }, "[m", function()
                local ok, err = pcall(function()
                    ts_to.goto_previous_start("@function.outer", "textobjects")
                end)
                if not ok then
                    print(tostring(err))
                end
            end, { desc = "Go to prev function start" })

            utils.keymap_set({ "n", "x", "o" }, "]M", function()
                local ok, err = pcall(function()
                    ts_to.goto_next_end("@function.outer", "textobjects")
                end)
                if not ok then
                    print(tostring(err))
                end
            end, { desc = "Go to next function end" })

            utils.keymap_set({ "n", "x", "o" }, "[M", function()
                local ok, err = pcall(function()
                    ts_to.goto_previous_end("@function.outer", "textobjects")
                end)
                if not ok then
                    print(tostring(err))
                end
            end, { desc = "Go to prev function end" })
        end,
    },
}
