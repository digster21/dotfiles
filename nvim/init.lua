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
        branch = 'master',
        lazy = false, 
        build = ":TSUpdate",
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

-- Telescope config
local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", telescope.git_files, { desc = "Telescope find files by name", noremap = true, silent = true })
vim.keymap.set("n", "<leader>fr", function() telescope.live_grep({ additional_args = function() return { "--hidden", "--no-ignore" } end, }) end, { desc = "Telescope find file by contents (ripgrep regex)", noremap = true, silent = true })
vim.keymap.set("n", "<leader>fs", function() telescope.live_grep({ additional_args = function() return { "--hidden", "--no-ignore", "--fixed-strings", "-i" } end, }) end, { desc = "Telescope find file by contents (ripgrep insensitive string)", noremap = true, silent = true })

-- NeoTree config
require("neo-tree").setup({
    close_if_last_window = true,
    filesystem = {
        filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = false,
        },
    },
})
vim.keymap.set("n", "<leader>tt", ":Neotree filesystem toggle<CR>", { desc = "Neotree Toggle filesystem tree", noremap = true, silent = true })
vim.keymap.set("n", "<leader>tg", ":Neotree git_status toggle<CR>", { desc = "Neotree Toggle git status tree", noremap = true, silent = true })

-- Treesitter config
require("nvim-treesitter.configs").setup({
    highlight = { enabled = true },
    indent = { enabled = true },
})

-- IntelliSense config (cmp)
local cmp = require("cmp")
cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
    }),
    sources = {
        {name = "nvim_lsp" },
    },
})

-- Language Servers (lsp)
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local compile_commands = find_file("compile_commands.json", vim.loop.cwd(), 6)
lspconfig.clangd.setup({
    capabilities = capabilities,
    cmd = (compile_commands and { "clangd", "--compile-commands-dir=" .. compile_commands } or nil),
})
lspconfig.pyright.setup({ capabilities = capabilities })

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Language Server show diagnostic message", noremap = true, silent = true })

-- Theme
vim.cmd.colorscheme("tokyonight")

