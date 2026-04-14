vim.lsp.config.clangd = {
    filetypes = { "c", "cpp", "h", "hpp" },
    cmd = { "clangd", "--clang-tidy", "--function-arg-placeholders=0" },
}

vim.lsp.enable("clangd")
