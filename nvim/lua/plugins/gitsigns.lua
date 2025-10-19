return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    signs = {
      add          = { text = '┃' },
      change       = { text = '┃' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
    signs_staged = {
      add          = { text = '┃' },
      change       = { text = '┃' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc, silent = true })
      end

      -- Hunk selection with motions
      map({ "o", "x" }, "ig", ":<C-U>Gitsigns select_hunk<CR>", "Git select hunk")

      -- Hunk keybinds
      map("n", "<leader>hn", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next")
        end
      end, "Git next hunk")
      map("n", "<leader>hp", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end, "Git previous hunk")
      map("n", "<leader>hf", function() gs.nav_hunk("last") end, "Git last hunk")
      map("n", "<leader>hl", function() gs.nav_hunk("first") end, "Git first hunk")

      map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", "Git stage hunk")
      map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", "Git reset hunk")
      map("n", "<leader>hu", gs.undo_stage_hunk, "Git unstage hunk")
      map("n", "<leader>hp", gs.preview_hunk_inline, "Git preview inline hunk")

      -- Buffer keybinds
      map("n", "<leader>gs", gs.stage_buffer, "Git stage buffer")
      map("n", "<leader>gr", gs.reset_buffer, "Git reset buffer")
      map("n", "<leader>gl", function() gs.blame_line({ full = true }) end, "Git blame line")
      map("n", "<leader>gb", function() gs.blame() end, "Git blame buffer")
      map("n", "<leader>gds", gs.diffthis, "Git diff staged")
      map("n", "<leader>gdh", function() gs.diffthis("~") end, "Git diff HEAD~")
    end,
  },
}
