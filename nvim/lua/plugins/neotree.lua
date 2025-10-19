return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  keys = {
    { "<leader>tt", "<cmd>Neotree filesystem focus<CR>", desc = "Focus filesystem tree" },
    { "<leader>tg", "<cmd>Neotree git_status focus<CR>", desc = "Focus gitfiles tree" },
    { "<leader>tb", "<cmd>Neotree buffers focus<CR>",    desc = "Focus buffers" },
    { "<leader>tx", "<cmd>Neotree close<CR>",           desc = "Close tree" },
  },
  opts = {
    filesystem = {
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    },
    window = {
      position = "left",
    },
  },
}
