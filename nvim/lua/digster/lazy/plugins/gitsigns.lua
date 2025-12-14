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
        current_line_blame = true,
        current_line_blame_opts = {
            virt_text_pos = "right_align",
        },
        attach_to_untracked = true,
        on_attach = function()
            if not utils.is_git_repo() then
                return
            end

            local gs = package.loaded.gitsigns

            -- Hunk selection with motions
            utils.keymap_set({ "o", "x" }, "ig", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Git select hunk" })

            -- Diffs
            utils.keymap_set("n", "<leader>p", gs.preview_hunk_inline, { desc = "Git preview inline hunk" })
            utils.keymap_set("n", "<leader>o", function() gs.diffthis("~") end, { desc = "Git diff HEAD~" })
            utils.keymap_set("n", "<leader>O", gs.diffthis, { desc = "Git diff staged" })

            -- Unstaging
            utils.keymap_set("n", "<leader>j", gs.undo_stage_hunk, { desc = "Git unstage hunk" })
            utils.keymap_set("n", "<leader>J", function()
                local file = vim.fn.expand("%:p")
                vim.cmd("silent !git reset HEAD " .. file)
            end, { desc = "Git unstage buffer" })

            -- Staging
            utils.keymap_set("n", "<leader>k", ":Gitsigns stage_hunk<CR>", { desc = "Git stage hunk" })
            utils.keymap_set("n", "<leader>K", gs.stage_buffer, { desc = "Git stage buffer" })

            -- Resetting
            utils.keymap_set("n", "<leader>l", ":Gitsigns reset_hunk<CR>", { desc = "Git reset hunk" })
            utils.keymap_set("n", "<leader>L", gs.reset_buffer, { desc = "Git reset buffer" })
        end,
    },
}
