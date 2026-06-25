return {
    "stevearc/conform.nvim",
    opts = {
        formatters_by_ft = {
            python = { "black" },
            sh = { "beautysh" },
            bash = { "beautysh" },
            zsh = { "beautysh" },
            yaml = { "prettier" },
            markdown = { "prettier" },
            javascript = { "prettier" },
            typescript = { "prettier" },
            typescriptreact = { "prettier" },
            javascriptreact = { "prettier" },
        },
        default_format_opts = {
            lsp_format = "fallback",
        },
        formatters = {
            prettier = {
                prepend_args = function(_, ctx)
                    local bo = vim.bo[ctx.buf]
                    local sw = bo.shiftwidth > 0 and bo.shiftwidth or bo.tabstop
                    return {
                        "--tab-width", tostring(sw),
                        "--use-tabs", tostring(not bo.expandtab),
                    }
                end,
            },
        },
    },
}
