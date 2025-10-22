local utils = require("digster.utils")

return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        signs = {
            add          = { text = '┃' },
            change       = { text = '┃' },
            delete       = { text = '_' },
            topdelete    = { text = '‾' },
            changedelete = { text = '~' },
            untracked    = { text = '┆' },
        },
        signs_staged = {
            add          = { text = '┃' },
            change       = { text = '┃' },
            delete       = { text = '_' },
            topdelete    = { text = '‾' },
            changedelete = { text = '~' },
            untracked    = { text = '┆' },
        },
        on_attach = function(buffer)
            local gs = package.loaded.gitsigns

            -- Hunk selection with motions
            utils.keymap_set({ "o", "x" }, "ig", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Git select hunk" })

            -- Hunk keybinds
            utils.keymap_set("n", "<leader>hn", function()
                if vim.wo.diff then
                    vim.cmd.normal({ "]c", bang = true })
                else
                    gs.nav_hunk("next")
                end
            end, { desc = "Git next hunk" })
            utils.keymap_set("n", "<leader>hp", function()
                if vim.wo.diff then
                    vim.cmd.normal({ "[c", bang = true })
                else
                    gs.nav_hunk("prev")
                end
            end, { desc = "Git previous hunk" })
            utils.keymap_set("n", "<leader>hf", function() gs.nav_hunk("last") end, { desc = "Git last hunk" })
            utils.keymap_set("n", "<leader>hl", function() gs.nav_hunk("first") end, { desc = "Git first hunk" })

            utils.keymap_set({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", { desc = "Git stage hunk" })
            utils.keymap_set({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", { desc = "Git reset hunk" })
            utils.keymap_set("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Git unstage hunk" })
            utils.keymap_set("n", "<leader>hp", gs.preview_hunk_inline, { desc = "Git preview inline hunk" })

            -- Buffer keybinds
            utils.keymap_set("n", "<leader>gs", gs.stage_buffer, { desc = "Git stage buffer" })
            utils.keymap_set("n", "<leader>gr", gs.reset_buffer, { desc = "Git reset buffer" })
            utils.keymap_set("n", "<leader>gl", function() gs.blame_line({ full = true }) end, { desc = "Git blame line" })
            utils.keymap_set("n", "<leader>gb", function() gs.blame() end, { desc = "Git blame buffer" })
            utils.keymap_set("n", "<leader>gds", gs.diffthis, { desc = "Git diff staged" })
            utils.keymap_set("n", "<leader>gdh", function() gs.diffthis("~") end, { desc = "Git diff HEAD~" })
        end,
    },
}
