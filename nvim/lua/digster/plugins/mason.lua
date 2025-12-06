return {
    {
        "mason-org/mason.nvim",
        dependencies = {
            "mason-org/mason-lspconfig.nvim",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "bashls",
                    "jsonls",
                    "lua_ls",
                    "pyright",
                    "clangd",
                    "eslint",
                    "ts_ls",
                },
                automatic_installation = true,
            })
        end
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "mason-org/mason.nvim" },
        config = function()
            require("mason-tool-installer").setup({
                ensure_installed = { "black" },
                auto_update = true,
                run_on_start = true,
            })
        end,
    },
}
