local utils = require("digster.utils")

vim.diagnostic.config({
    virtual_text = { current_line = true },
    underline = true,
    update_in_insert = true,
    severity_sort = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
        },
    },
    float = {
        border = "rounded",
        source = "if_many",
    },
})

utils.keymap_set("n", "<leader>v", function()
    require("conform").format({
        bufnr = vim.api.nvim_get_current_buf(),
        async = true,
    })
end, { desc = "Format buffer" })

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("digster.lsp", { clear = true }),
    callback = function()
        utils.keymap_set("n", "<leader>r", vim.lsp.buf.rename, { desc = "Rename symbol" })
        utils.keymap_set("n", "<leader>h", vim.lsp.buf.hover, { desc = "Hover docs" })
    end,
})

vim.lsp.config("*", {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
})
