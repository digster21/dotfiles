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
            local gs = package.loaded.gitsigns

            -- Hunk selection with motions
            utils.keymap_set({ "o", "x" }, "ig", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Git select hunk" })

            utils.keymap_set({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", { desc = "Git stage hunk" })
            utils.keymap_set({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", { desc = "Git reset hunk" })
            utils.keymap_set("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Git unstage hunk" })
            utils.keymap_set("n", "<leader>gp", gs.preview_hunk_inline, { desc = "Git preview inline hunk" })

            -- Buffer keybinds
            utils.keymap_set("n", "<leader>gS", gs.stage_buffer, { desc = "Git stage buffer" })
            utils.keymap_set("n", "<leader>gR", gs.reset_buffer, { desc = "Git reset buffer" })
            utils.keymap_set("n", "<leader>gD", gs.diffthis, { desc = "Git diff staged" })
            utils.keymap_set("n", "<leader>gH", function() gs.diffthis("~") end, { desc = "Git diff HEAD~" })
        end,
    },
}
