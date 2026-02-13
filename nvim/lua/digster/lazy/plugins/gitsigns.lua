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

            -- using cmd for easier visual mode support

            -- Hunk selection with motions
            utils.keymap_set({ "o", "x" }, "ig", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Git select hunk" })

            -- Navigation
            utils.keymap_set("n", "<leader>n", gs.next_hunk, { desc = "Git goto next hunk" })
            utils.keymap_set("n", "<leader>p", gs.prev_hunk, { desc = "Git goto prev hunk" })

            -- Diffs
            utils.keymap_set("n", "<leader>H", function() gs.preview_hunk() end,
                { desc = "Git preview inline hunk" })

            -- Staging
            utils.keymap_set({ "n", "v" }, "<leader>k", ":Gitsigns stage_hunk<cr>", { desc = "Git stage/unstage hunk" })
            utils.keymap_set("n", "<leader>K", function() gs.stage_buffer() end, { desc = "Git stage buffer" })
            utils.keymap_set("n", "<leader>J", function() gs.reset_buffer_index() end, { desc = "Git unstage buffer" })

            -- Resetting
            utils.keymap_set({ "n", "v" }, "<leader>l", function() gs.reset_hunk() end, { desc = "Git reset hunk" })
            utils.keymap_set("n", "<leader>L", gs.reset_buffer, { desc = "Git reset buffer" })
        end,
    },
}
