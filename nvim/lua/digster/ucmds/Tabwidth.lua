local Tabwidth = {}

--- Print the configured indentation (shiftwidth, tabstop, and softtabstop).
--- If they are all the same, only prints the shiftwidth.
function Tabwidth.print()
    local sw = vim.o.shiftwidth
    local ts = vim.o.tabstop
    local sts = vim.o.softtabstop
    if sw == ts and sw == sts then
        print(sw)
    else
        print(sw, ts, sts)
    end
end

--- Set the configured indentation (shiftwidth, tabstop, softtabstop) to a given value.
---@param width number Width to configure.
function Tabwidth.set(width)
    vim.o.shiftwidth = width
    vim.o.tabstop = width
    vim.o.softtabstop = width
end

--- Setup Tabwidth.
---@param opts? {width?: number} Setup options
function Tabwidth.setup(opts)
    if opts then
        -- Configure initial width
        Tabwidth.set(opts.width)
    end

    -- Configure User command
    vim.api.nvim_create_user_command("Tabwidth", function(options)
        local width = tonumber(options.args)
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
