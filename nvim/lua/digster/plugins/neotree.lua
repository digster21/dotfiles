local utils = require("digster.utils")


local keys = {
    { "<leader>t", "<cmd>Neotree filesystem toggle left<CR>",        desc = "Focus filesystem tree" },
    { "<leader>y", "<cmd>Neotree document_symbols toggle right<CR>", desc = "Focus document symbols" },
}

if utils.is_git_repo() then
    table.insert(keys, { "<leader>g", "<cmd>Neotree git_status toggle left<CR>", desc = "Focus gitfiles tree" })
end

return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = keys,
    opts = {
        close_if_last_window = true,
        sources = {
            "filesystem",
            "document_symbols",
            "git_status",
        },
        document_symbols = {
            follow_cursor = true,
        },
        filesystem = {
            filtered_items = {
                visible = true,
                hide_dotfiles = false,
                hide_gitignored = false,
            },
        },
    },
}
