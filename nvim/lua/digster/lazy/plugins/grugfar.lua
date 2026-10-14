local keymap_set = require("digster.utils.keymap_set")

return {
    "MagicDuck/grug-far.nvim",
    config = function()
        require("grug-far").setup({})

        keymap_set("n", "<leader>z", "<cmd>GrugFar<cr>", { desc = "Open Grug far" })
        keymap_set("v", "<leader>z", ":GrugFar<cr>", { desc = "Open Grug far (search selection)" })
        keymap_set("v", "<leader>Z", ":GrugFarWithin<cr>", { desc = "Open Grug far (search within selection)" })
    end,
}
