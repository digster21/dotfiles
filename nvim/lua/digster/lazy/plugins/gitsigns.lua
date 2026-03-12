local utils = require("digster.utils")

return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        signs = {
            add          = { text = '┃' },
            change       = { text = '┃' },
            delete       = { text = '󰞒' },
            topdelete    = { text = '󰞕' },
            changedelete = { text = '~' },
            untracked    = { text = '┆' },
        },
        signs_staged = {
            add          = { text = '┃' },
            change       = { text = '┃' },
            delete       = { text = '󰞒' },
            topdelete    = { text = '󰞕' },
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

            -- using cmd in some places for easier visual mode support

            -- Hunk selection with motions
            utils.keymap_set({ "o", "x" }, "ig", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Git select hunk" })

            -- Navigation
            utils.keymap_set("n", "<leader>n", function() gs.nav_hunk("next", { target = "all" }) end,
                { desc = "Git goto next hunk" })
            utils.keymap_set("n", "<leader>N", function() gs.nav_hunk("prev", { target = "all" }) end,
                { desc = "Git goto prev hunk" })

            -- Diffs
            utils.keymap_set("n", "<leader>pp", function() gs.preview_hunk() end,
                { desc = "Git preview hunk inline" })

            utils.keymap_set("n", "<leader>ph", function() gs.diffthis("HEAD") end,
                { desc = "Git diff HEAD" })

            utils.keymap_set("n", "<leader>pw", function() gs.toggle_word_diff() end,
                { desc = "Git toggle word diff" })

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
