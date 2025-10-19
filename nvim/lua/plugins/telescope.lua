return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local telescope = require("telescope.builtin")

    vim.keymap.set("n", "<leader>ff", telescope.find_files, {
      desc = "Find Files by name",
    })

    vim.keymap.set("n", "<leader>fg", telescope.git_files, {
      desc = "Find Git files by name",
    })

    vim.keymap.set("n", "<leader>fr", function()
      telescope.live_grep({
        additional_args = function()
          return { "--hidden", "--no-ignore" }
        end,
      })
    end, {
      desc = "Find content by Regex (ripgrep)",
    })

    vim.keymap.set("n", "<leader>fs", function()
      telescope.live_grep({
        additional_args = function()
          return { "--hidden", "--no-ignore", "--fixed-strings" }
        end,
      })
    end, {
      desc = "Find content by String (ripgrep)",
    })

    vim.keymap.set("n", "<leader>fw", telescope.grep_string, {
      desc = "Find content by Word under cursor",
    })
  end,
}

