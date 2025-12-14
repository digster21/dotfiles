return {
    "folke/tokyonight.nvim",
    lazy = true,
    config = function()
        require("tokyonight").setup({
            style = "moon", -- storm, night, day, moon
            styles = {
                functions = { bold = true },
            },
        })
    end,
}
