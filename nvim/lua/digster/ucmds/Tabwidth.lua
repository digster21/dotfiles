local Tabwidth = {}

--- Print the configured indentation (shiftwidth, tabstop, and softtabstop).
--- If they are all the same, only prints the shiftwidth.
function Tabwidth.print()
    local sw = vim.opt.shiftwidth:get()
    local ts = vim.opt.tabstop:get()
    local sts = vim.opt.softtabstop:get()
    if sw == ts and sw == sts then
        print(sw)
    else
        print(sw, ts, sts)
    end
end

--- Set the configured indentation (shiftwidth, tabstop, softtabstop) to a given value.
---@param width number Width to configure.
function Tabwidth.set(width)
    vim.opt.shiftwidth = width
    vim.opt.tabstop = width
    vim.opt.softtabstop = width
end

--- Setup Tabwidth.
---@param initial_width number Initial width to configure
function Tabwidth.setup(initial_width)
    -- Configure initial width
    Tabwidth.set(initial_width)

    -- Configure User command
    vim.api.nvim_create_user_command("Tabwidth", function(opts)
        local width = tonumber(opts.args)
        if width then
            Tabwidth.set(width)
        else
            Tabwidth.print()
        end
    end, {
        nargs = "?"
    })
end

return Tabwidth
