return {
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        event = "VeryLazy",
        cmd = "CopilotChat",
        keys = {
            { "<leader>y", "<cmd>CopilotChat<cr>",       desc = "Open CopilotChat" },
            { "<leader>Y", "<cmd>CopilotChatModels<cr>", desc = "Open CopilotChat Model Selection" },
        },
        dependencies = {
            { "nvim-lua/plenary.nvim", branch = "master" },
        },
        build = "make tiktoken",
        opts = {
            model = "auto",
        },
    },
}
