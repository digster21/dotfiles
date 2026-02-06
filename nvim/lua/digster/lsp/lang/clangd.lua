vim.lsp.config.clangd = {
    root_markers = { "compile_commands.json" },
    workspace_required = true,
    filetypes = { "c", "cpp", "h", "hpp" },
    cmd = { "clangd", "--clang-tidy" },
}

vim.lsp.enable("clangd")
