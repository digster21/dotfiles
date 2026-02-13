return {
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        event = "VeryLazy",
        cmd = "CopilotChat",
        keys = {
            { "<leader>a", "<cmd>CopilotChat<cr>" },
            { "<leader>A", "<cmd>CopilotChatModels<cr>" },
        },
        dependencies = {
            { "nvim-lua/plenary.nvim", branch = "master" },
        },
        build = "make tiktoken",
        opts = {
        },
    },
}
