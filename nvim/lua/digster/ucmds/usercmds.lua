-- Import commands
require("digster.ucmds.Tabwidth").setup({
    default = {
        shiftwidth = 4,
        softtabstop = 4,
        tabstop = 4,
    },
    filetype = {
        markdown = {
            shiftwidth = 2,
            softtabstop = 2,
            tabstop = 2,
        }
    }
})
