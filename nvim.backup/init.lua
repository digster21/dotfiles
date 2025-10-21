-- Local functions
local function find_file(filename, dir, depth)
    depth = depth or 4
    local function search(d, current_depth)
        if current_depth > depth then return nil end

        local fd = vim.loop.fs_scandir(d)
        if not fd then return nil end

        while true do
            local name, type = vim.loop.fs_scandir_next(fd)
            if not name then break end

            local path = d .. "/" .. name
            if name == filename then
                return path
            elseif type == "directory" then
                if vim.loop.fs_realpath(path) == path then
                    local found = search(path, current_depth + 1)
                    if found then return found end
                end
            end
        end
        return nil
    end

    return search(dir, 0)
end

-- Set <leader>
vim.g.mapleader = " "

-- Initialize LAZY plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Install plugs with LAZY
require("lazy").setup({
    "tpope/vim-sensible",
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons",
            lazy = false,
        },
    },
    "neovim/nvim-lspconfig",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                c = { "clang-format" },
                cpp = { "clang-format" },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
        },
    },
    "folke/tokyonight.nvim",
})

-- Configure VIM settings
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.clipboard = "unnamedplus"
vim.cmd("syntax on")

-- Remap escape for insert, visual, and select mode
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })
vim.keymap.set("v", "jk", "<Esc>", { noremap = true, silent = true })
vim.keymap.set("s", "jk", "<Esc>", { noremap = true, silent = true })

-- Map keybinding for formatting
vim.keymap.set("n", "<leader>F", function() require("conform").format({ async = true }) end,
    { desc = "Run formatter for current buffer", noremap = true, silent = true })

-- Telescope config
local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", telescope.find_files,
    { desc = "Telescope find files by name", noremap = true, silent = true })
vim.keymap.set("n", "<leader>fg", telescope.git_files,
    { desc = "Telescope find files by name (git)", noremap = true, silent = true })
vim.keymap.set("n", "<leader>fr",
    function() telescope.live_grep({ additional_args = function() return { "--hidden", "--no-ignore" } end, }) end,
    { desc = "Telescope find file by contents (ripgrep regex)", noremap = true, silent = true })
vim.keymap.set("n", "<leader>fs",
    function() telescope.live_grep({ additional_args = function() return { "--hidden", "--no-ignore", "--fixed-strings" } end, }) end,
    { desc = "Telescope find file by contents (ripgrep string)", noremap = true, silent = true })
vim.keymap.set("n", "<leader>fw", telescope.grep_string,
    { desc = "Telescope find file using stirng under cursor", noremap = true, silent = true })
-- NeoTree config
require("neo-tree").setup({
    window = {
        position = "float",
    },
    filesystem = {
        filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = false,
        },
    },
})
vim.keymap.set("n", "<leader>tt", ":Neotree filesystem focus<CR>",
    { desc = "Neotree focus filesystem tree", noremap = true, silent = true })
vim.keymap.set("n", "<leader>tg", ":Neotree git_status focus<CR>",
    { desc = "Neotree focus git status tree", noremap = true, silent = true })
vim.keymap.set("n", "<leader>tx", ":Neotree close<CR>", { desc = "Neotree close", noremap = true, silent = true })

-- IntelliSense config (cmp)
local cmp = require("cmp")
cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<TAB>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
    }),
    sources = {
        { name = "nvim_lsp" },
    },
})

-- Language Servers (lsp)
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local cmd = { "clangd", "--clang-tidy" }

local compile_commands = find_file("compile_commands.json", vim.loop.cwd(), 6)
if compile_commands then
    table.insert(cmd, "--compile-commands-dir=" .. vim.fn.fnamemodify(compile_commands, ":h"))
end

lspconfig.clangd.setup({
    capabilities = capabilities,
    cmd = cmd,
})
lspconfig.pyright.setup({ capabilities = capabilities })

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float,
    { desc = "Language Server show diagnostic message", noremap = true, silent = true })

-- Theme
vim.cmd.colorscheme("tokyonight")
