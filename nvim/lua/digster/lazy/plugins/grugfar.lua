local utils = require("digster.utils")

return {
    "MagicDuck/grug-far.nvim",
    config = function()
        require("grug-far").setup({})

        utils.keymap_set("n", "<leader>z", "<cmd>GrugFar<cr>", { desc = "Open Grug far" })
        utils.keymap_set("v", "<leader>z", ":GrugFar<cr>", { desc = "Open Grug far (search selection)" })
        utils.keymap_set("v", "<leader>Z", ":GrugFarWithin<cr>", { desc = "Open Grug far (search within selection)" })
    end,
}
