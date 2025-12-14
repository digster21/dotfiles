return {
    "rebelot/kanagawa.nvim",
    lazy = true,
    config = function()
        require("kanagawa").setup({
            theme = "lotus", -- wave, dragon, lotus
        })
    end,
}
