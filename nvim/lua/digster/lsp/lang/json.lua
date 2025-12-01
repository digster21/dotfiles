vim.lsp.config.json = {
    cmd = { "vscode-json-language-server", "--stdio" },
    filetypes = { "json", "jsonc" },
    init_options = {
        provideFormatter = true,
    },

    -- Add custom command to format entire document
    commands = {
        Format = {
            function()
                vim.lsp.buf.format({ range = { { 0, 0 }, { vim.fn.line("$"), 0 } } })
            end
        }
    }
}

vim.lsp.enable("json")
