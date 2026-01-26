local utils = require("digster.utils")

return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-ui-select.nvim" },
    config = function()
        local ts = require("telescope")
        local ts_builtin = require("telescope.builtin")
        local ts_theme = require("telescope.themes")

        utils.keymap_set("n", "<leader>a", function()
            ts_builtin.find_files({ hidden = true })
        end, {
            desc = "Find files by name",
        })

        utils.keymap_set("n", "<leader>f", function()
            if utils.is_git_repo() then
                ts_builtin.git_files({ hidden = true, show_untracked = true })
            else
                ts_builtin.find_files({ hidden = true })
            end
        end, {
            desc = "Find git files by name",
        })

        utils.keymap_set("n", "<leader>S", function()
            ts_builtin.live_grep({
                additional_args = function()
                    return { "--hidden", "--no-ignore" }
                end,
            })
        end, {
            desc = "Find content by regex (ripgrep)",
        })

        utils.keymap_set("n", "<leader>s", function()
            ts_builtin.live_grep({
                additional_args = function()
                    return { "--hidden", "--no-ignore", "--fixed-strings" }
                end,
            })
        end, {
            desc = "Find content by string (ripgrep)",
        })

        utils.keymap_set("n", "<leader>w", ts_builtin.grep_string, {
            desc = "Find content by word under cursor",
        })

        -- Jump cursor forward <C-i>
        -- Jump cursor backward <C-o>

        utils.keymap_set("n", "<leader>u", ":Telescope lsp_references<CR>", { desc = "Find usage" })

        utils.keymap_set("n", "<leader>E", ":Telescope diagnostics bufnr=0<CR>", { desc = "Show buffer diagnostics" })
        utils.keymap_set("n", "<leader>e", function()
            vim.diagnostic.open_float(nil, { scope = "line" })
        end, { desc = "Show line diagnostics" })

        utils.keymap_set("n", "<leader>d", ":Telescope lsp_definitions<CR>", { desc = "Find definition of var" })
        utils.keymap_set("n", "<leader>D", ":Telescope lsp_type_definitions<CR>",
            { desc = "Find definition of var type" })
        utils.keymap_set("n", "<leader>i", ":Telescope lsp_implementations<CR>", { desc = "Find to implementation" })

        utils.keymap_set("n", "<leader>0", ":Telescope colorscheme<CR>", { desc = "Change look using picker" })

        ts.setup({
            extensions = {
                ["ui-select"] = {
                    ts_theme.get_dropdown()
                }
            },
        })

        ts.load_extension("ui-select")
    end,
}
