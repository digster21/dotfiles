local utils = require("digster.utils")

return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local telescope = require("telescope.builtin")

        utils.keymap_set("n", "<leader>fa", function()
            telescope.find_files({ hidden = true })
        end, {
            desc = "Find files by name",
        })

        utils.keymap_set("n", "<leader>ff", function()
            local ret = pcall(function()
                telescope.git_files({ hidden = true, show_untracked = true })
            end)
            if not ret then
                telescope.find_files({ hidden = true })
            end
        end, {
            desc = "Find git files by name",
        })

        utils.keymap_set("n", "<leader>fr", function()
            telescope.live_grep({
                additional_args = function()
                    return { "--hidden", "--no-ignore" }
                end,
            })
        end, {
            desc = "Find content by regex (ripgrep)",
        })

        utils.keymap_set("n", "<leader>fs", function()
            telescope.live_grep({
                additional_args = function()
                    return { "--hidden", "--no-ignore", "--fixed-strings" }
                end,
            })
        end, {
            desc = "Find content by string (ripgrep)",
        })

        utils.keymap_set("n", "<leader>fw", telescope.grep_string, {
            desc = "Find content by word under cursor",
        })

        utils.keymap_set("n", "<leader>fd", ":Telescope lsp_definitions<CR>", { desc = "Find definition" })
        utils.keymap_set("n", "<leader>fu", ":Telescope lsp_references<CR>", { desc = "Find usage" })

        utils.keymap_set("n", "<leader>ft", ":Telescope lsp_type_definitions<CR>", { desc = "Find type definition" })
        utils.keymap_set("n", "<leader>fi", ":Telescope lsp_implementations<CR>", { desc = "LSP go to implementation" })

        utils.keymap_set("n", "<leader>fe", ":Telescope diagnostics bufnr=0<CR>", { desc = "Show buffer diagnostics" })
    end,
}
