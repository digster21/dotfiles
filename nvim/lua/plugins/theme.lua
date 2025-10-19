return {
  "folke/tokyonight.nvim",
  lazy = false,
  config = function()
    require("tokyonight").setup({
      style = "moon",          -- "storm", "night", "day", "moon"
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
      },
    })

    -- set colorscheme
    vim.cmd.colorscheme("tokyonight")
  end,
}
