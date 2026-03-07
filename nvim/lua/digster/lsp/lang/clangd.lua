vim.lsp.config.clangd = {
    filetypes = { "c", "cpp", "h", "hpp" },
    cmd = { "clangd", "--clang-tidy" },
}

vim.lsp.enable("clangd")
