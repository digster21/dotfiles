return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
    },
    config = function()
        local popup_menu_height = 10    -- Max Items shown (scrollable)
        local popup_menu_col_width = 60 -- Max Item col width (truncated)

        vim.opt.pumheight = popup_menu_height

        local cmp = require("cmp")

        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                ["<C-j>"] = cmp.mapping.select_next_item(),
                ["<C-k>"] = cmp.mapping.select_prev_item(),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ["<C-s>"] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ["<C-Space>"] = cmp.mapping.confirm({ select = true }),
            }),
            sources = {
                { name = "nvim_lsp" },
                { name = "buffer" },
                { name = "path" },
            },
            window = {
                completion = cmp.config.window.bordered({ max_width = popup_menu_col_width }),
                documentation = cmp.config.window.bordered({ max_width = popup_menu_col_width }),
            },
            completion = {
                keyword_length = 2,
            },
        })
    end,
}
