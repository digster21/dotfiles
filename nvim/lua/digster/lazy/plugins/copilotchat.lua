return {
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        event = "VeryLazy",
        cmd = "CopilotChat",
        keys = {
            { "<leader>a", "<cmd>CopilotChat<cr>",       desc = "Open CopilotChat" },
            { "<leader>A", "<cmd>CopilotChatModels<cr>", desc = "Open CopilotChat Model Selection" },
        },
        dependencies = {
            { "nvim-lua/plenary.nvim", branch = "master" },
        },
        build = "make tiktoken",
        opts = {
        },
    },
}
