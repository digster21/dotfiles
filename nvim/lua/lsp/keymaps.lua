local function set_global_keymaps(client, bufnr)
    local map = function(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
    end

    map("<leader>LR", ":LspRestart<CR>", "LSP restart server")
    map("<leader>la", vim.lsp.buf.code_action, "LSP show code actions")
    map("<leader>ld", ":Telescope lsp_definitions<CR>", "LSP go to definition")
    map("<leader>le", ":Telescope lsp_references<CR>", "LSP go to references")

    if client:supports_method("textDocument/declaration") then
        map("<leader>lf", vim.lsp.buf.declaration, "LSP go to declaration")
    end

    map("<leader>lt", ":Telescope lsp_type_definitions<CR>", "LSP go to type definition")
    map("<leader>ls", vim.lsp.buf.hover, "LSP show hover information")
    map("<leader>li", ":Telescope lsp_implementations<CR>", "LSP go to implementation")
    map("<leader>lh", vim.lsp.buf.signature_help, "LSP show signature help")
    map("<leader>lr", vim.lsp.buf.rename, "LSP rename symbol")

    map("<leader>dl", vim.diagnostic.open_float, "Show line diagnostics")
    map("<leader>ds", ":Telescope diagnostics bufnr=0<CR>", "Show buffer diagnostics")

    vim.keymap.set("n", "<leader>dp", function()
        vim.diagnostic.jump({ count = -1 })
    end, { buffer = bufnr, desc = "Previous diagnostic" })

    vim.keymap.set("n", "<leader>dn", function()
        vim.diagnostic.jump({ count = 1 })
    end, { buffer = bufnr, desc = "Next diagnostic" })

    vim.keymap.set("n", "<leader>F", function()
        vim.lsp.buf.format({ async = true })
    end, { buffer = bufnr, desc = "Format buffer" })
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
