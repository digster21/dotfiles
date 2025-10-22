return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
    },
    config = function()
        local cmp = require("cmp")

        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                ["<C-j>"] = cmp.mapping.select_next_item(),
                ["<C-k>"] = cmp.mapping.select_prev_item(),
                ["<C-Space>"] = cmp.mapping.confirm({ select = true }),
                ["<C-TAB>"] = cmp.mapping.complete(),
            }),
            sources = {
                { name = "nvim_lsp" },
                { name = "buffer" },
                { name = "path" },
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            completion = {
                keyword_length = 2,
            },
            formatting = {
                max_item_count = 10,
            },
        })
    end,
}
