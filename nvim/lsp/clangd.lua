return {
    filetypes = { "c", "cpp", "h", "hpp" },
    cmd = { "clangd", "--clang-tidy", "--function-arg-placeholders=0" },
}
