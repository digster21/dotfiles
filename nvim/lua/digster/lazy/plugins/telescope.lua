local is_git_repo = require("digster.utils.is_git_repo")
local keymap_set = require("digster.utils.keymap_set")

return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-ui-select.nvim" },
    config = function()
        local in_git_repo = is_git_repo()

        local ts = require("telescope")
        local ts_builtin = require("telescope.builtin")
        local ts_theme = require("telescope.themes")

        keymap_set("n", "<leader>f", function()
            if in_git_repo then
                ts_builtin.git_files({ hidden = true, show_untracked = true })
            else
                ts_builtin.find_files({ hidden = true })
            end
        end, {
            desc = "Find git files by name",
        })

        if in_git_repo then
            keymap_set("n", "<leader>g", function()
                ts_builtin.git_status()
            end, {
                desc = "Find git files by name",
            })
        end

        keymap_set("n", "<leader>s", function()
            ts_builtin.live_grep({
                additional_args = function()
                    return { "--hidden", "--fixed-strings" }
                end,
            })
        end, {
            desc = "Find content by string (ripgrep)",
        })

        keymap_set("n", "<leader>S", function()
            ts_builtin.live_grep({
                additional_args = function()
                    return { "--hidden" }
                end,
            })
        end, {
            desc = "Find content by regex (ripgrep)",
        })

        keymap_set("n", "<leader>w", ts_builtin.grep_string, {
            desc = "Find content by word under cursor",
        })

        keymap_set("n", "<leader>W", ts_builtin.spell_suggest, {
            desc = "Find content by word under cursor",
        })

        -- Jump cursor forward <C-i>
        -- Jump cursor backward <C-o>

        keymap_set("n", "<leader>u", ":Telescope lsp_references<CR>", { desc = "Find usage" })
        keymap_set("n", "<leader>d", ":Telescope lsp_definitions<CR>", { desc = "Find definition of var" })
        keymap_set("n", "<leader>i", ":Telescope lsp_implementations<CR>", { desc = "Find to implementation" })

        keymap_set("n", "<leader>E", ":Telescope diagnostics bufnr=0<CR>", { desc = "Show buffer diagnostics" })
        keymap_set("n", "<leader>e", function()
            vim.diagnostic.open_float(nil, { scope = "line" })
        end, { desc = "Show line diagnostics" })

        keymap_set("n", "<leader>0", ":Telescope colorscheme<CR>", { desc = "Change look using picker" })

        ts.setup({
            defaults = {
                path_display = { "filename_first" },
            },
            extensions = {
                ["ui-select"] = {
                    ts_theme.get_dropdown()
                }
            },
        })

        ts.load_extension("ui-select")
    end,
}
