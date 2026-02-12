local utils = require("digster.utils")

local function set_global_keymaps(client, buffer)
    utils.keymap_set("n", "<leader>r", vim.lsp.buf.rename, { desc = "Rename symbol" })
    utils.keymap_set("n", "<leader>h", vim.lsp.buf.hover, { desc = "Hover docs" })

    utils.keymap_set("n", "<leader>v", function()
        local conform = require("conform")

        local conform_fmtrs = conform.formatters_by_ft[vim.bo.filetype]

        if conform_fmtrs and #conform_fmtrs > 0 then
            conform.format()
        else
            vim.lsp.buf.format()
        end
    end, { buffer = buffer, desc = "Format buffer" })
end

local function configure_diagnostics()
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
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("digster.lsp", { clear = true }),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        local bufnr = args.buf
        set_global_keymaps(client, bufnr)
        configure_diagnostics()
    end,
})

vim.lsp.config("*", {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
})
