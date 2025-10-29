local utils = require("digster.utils")

local cmd = { "clangd", "--clang-tidy" }
local compile_cmd_dir =
    utils
    .find_file_dir("compile_commands.json", vim.loop.cwd(), 6)

if compile_cmd_dir then
    table
        .insert(cmd, "--compile-commands-dir=" .. compile_cmd_dir)

    vim.lsp.config.clangd =
    {
        root_markers = { ".git" },
        filetypes = { "c", "cpp", "h", "hpp" },
        cmd = cmd,
    }

    vim.lsp.enable("clangd")
end
