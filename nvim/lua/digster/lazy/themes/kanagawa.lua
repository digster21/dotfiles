return {
    "rebelot/kanagawa.nvim",
    lazy = true,
    config = function()
        require("kanagawa").setup({
            theme = "wave", -- wave, dragon, lotus
        })
    end,
}
