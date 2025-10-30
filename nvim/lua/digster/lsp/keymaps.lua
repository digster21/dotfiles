local utils = require("digster.utils")

local function set_global_keymaps(client, buffer)
    if client:supports_method("textDocument/declaration") then
        utils.keymap_set("n", "<leader>lp", vim.lsp.buf.declaration, { desc = "LSP go to declaration" })
    end

    utils.keymap_set("n", "<leader>lh", vim.lsp.buf.signature_help, { desc = "LSP show signature help" })
    utils.keymap_set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "LSP rename symbol" })
    utils.keymap_set("n", "<leader>ls", vim.lsp.buf.hover, { desc = "LSP show hover information" })
    utils.keymap_set("n", "<leader>le", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

    utils.keymap_set("n", "<leader>dk", function()
        vim.diagnostic.jump({ count = -1 })
    end, { buffer = buffer, desc = "Previous diagnostic" })

    utils.keymap_set("n", "<leader>dj", function()
        vim.diagnostic.jump({ count = 1 })
    end, { buffer = buffer, desc = "Next diagnostic" })

    utils.keymap_set("n", "<leader>F", function()
        vim.lsp.buf.format({ async = true })
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
