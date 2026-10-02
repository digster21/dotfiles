local utils = require("digster.utils")

return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        opts = {},
        config = function(_, opts)
            local ts = require("nvim-treesitter")
            ts.setup()

            ts.install({
                "bash",
                "c",
                "cpp",
                "cmake",
                "diff",
                "html",
                "javascript",
                "jsdoc",
                "json",
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
            })

            -- Kickstart highlighting
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("digster.treesitter", { clear = true }),
                callback = function(args)
                    if pcall(vim.treesitter.start, args.buf) then
                        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })
        end
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        config = function()
            local ts_to = require("nvim-treesitter-textobjects.move")

            utils.keymap_set({ "n", "x", "o" }, "]M", function()
                local ok, err = pcall(function()
                    ts_to.goto_previous_end("@function.outer", "textobjects")
                end)
                if not ok then
                    print(tostring(err))
                end
            end, { desc = "Go to prev function end" })


            utils.keymap_set({ "n", "x", "o" }, "[m", function()
                local ok, err = pcall(function()
                    ts_to.goto_previous_start("@function.outer", "textobjects")
                end)
                if not ok then
                    print(tostring(err))
                end
            end, { desc = "Go to prev function start" })

            utils.keymap_set({ "n", "x", "o" }, "]m", function()
                local ok, err = pcall(function()
                    ts_to.goto_next_end("@function.outer", "textobjects")
                end)
                if not ok then
                    print(tostring(err))
                end
            end, { desc = "Go to next function end" })


            utils.keymap_set({ "n", "x", "o" }, "[M", function()
                local ok, err = pcall(function()
                    ts_to.goto_next_start("@function.outer", "textobjects")
                end)

                if not ok then
                    print(tostring(err))
                end
            end, { desc = "Go to next function start" })
        end,
    },
}
