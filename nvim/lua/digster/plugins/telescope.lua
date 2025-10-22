return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local telescope = require("telescope.builtin")

        vim.keymap.set("n", "<leader>fa", function()
            telescope.find_files({ hidden = true })
        end, {
            desc = "Find files by name",
        })

        vim.keymap.set("n", "<leader>ff", function()
            telescope.git_files({ hidden = true, show_untracked = true })
        end, {
            desc = "Find git files by name",
        })

        vim.keymap.set("n", "<leader>fr", function()
            telescope.live_grep({
                additional_args = function()
                    return { "--hidden", "--no-ignore" }
                end,
            })
        end, {
            desc = "Find content by regex (ripgrep)",
        })

        vim.keymap.set("n", "<leader>fs", function()
            telescope.live_grep({
                additional_args = function()
                    return { "--hidden", "--no-ignore", "--fixed-strings" }
                end,
            })
        end, {
            desc = "Find content by string (ripgrep)",
        })

        vim.keymap.set("n", "<leader>fw", telescope.grep_string, {
            desc = "Find content by word under cursor",
        })
    end,
}
