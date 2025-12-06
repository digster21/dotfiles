local utils = require("digster.utils")

return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local telescope = require("telescope.builtin")

        utils.keymap_set("n", "<leader>a", function()
            telescope.find_files({ hidden = true })
        end, {
            desc = "Find files by name",
        })

        utils.keymap_set("n", "<leader>f", function()
            if utils.is_git_repo() then
                telescope.git_files({ hidden = true, show_untracked = true })
            else
                telescope.find_files({ hidden = true })
            end
        end, {
            desc = "Find git files by name",
        })

        utils.keymap_set("n", "<leader>S", function()
            telescope.live_grep({
                additional_args = function()
                    return { "--hidden", "--no-ignore" }
                end,
            })
        end, {
            desc = "Find content by regex (ripgrep)",
        })

        utils.keymap_set("n", "<leader>s", function()
            telescope.live_grep({
                additional_args = function()
                    return { "--hidden", "--no-ignore", "--fixed-strings" }
                end,
            })
        end, {
            desc = "Find content by string (ripgrep)",
        })

        utils.keymap_set("n", "<leader>w", telescope.grep_string, {
            desc = "Find content by word under cursor",
        })

        -- Jump cursor forward <C-i>
        -- Jump cursor backward <C-o>

        utils.keymap_set("n", "<leader>u", ":Telescope lsp_references<CR>", { desc = "Find usage" })
        utils.keymap_set("n", "<leader>e", ":Telescope diagnostics bufnr=0<CR>", { desc = "Show buffer diagnostics" })

        utils.keymap_set("n", "<leader>d", ":Telescope lsp_definitions<CR>", { desc = "Find definition of var" })
        utils.keymap_set("n", "<leader>D", ":Telescope lsp_type_definitions<CR>",
            { desc = "Find definition of var type" })
        utils.keymap_set("n", "<leader>i", ":Telescope lsp_implementations<CR>", { desc = "Find to implementation" })
    end,
}
