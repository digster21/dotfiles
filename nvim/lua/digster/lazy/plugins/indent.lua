return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        scope = {
            show_start = false,
            show_end = false,
        }
    },
}
