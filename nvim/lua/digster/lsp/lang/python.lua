vim.lsp.config.python = {
    cmd = { "pyright-langserver", "--stdio" },
    root_markers = { "pyproject.toml", ".python-version", ".git" },
    filetypes = { "python" },
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true
            }
        }
    }
}

vim.lsp.enable("python")
