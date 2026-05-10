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
function Tabwidth.set_opt(width)
    Tabwidth.opt.width = width

    vim.o.shiftwidth = width
    vim.o.tabstop = width
    vim.o.softtabstop = width
end

--- Set the configured indentation
---@param filetype string
---@param width number
function Tabwidth.set_ft(filetype, width)
    Tabwidth.opt.ft[filetype] = width
end

--- Setup Tabwidth.
---@param opts? {width?: number} Setup options
function Tabwidth.setup(opts)
    -- Setup Tabwidth state
    Tabwidth.opt = {}
    Tabwidth.opt.ft = {}

    -- Configure Tabwidth options
    if opts then
        Tabwidth.set_opt(opts.width)
    end

    -- Configure User command
    vim.api.nvim_create_user_command("Tabwidth", function(options)
        local width = tonumber(options.args)
        if width then
            Tabwidth.set_opt(width)
        else
            Tabwidth.print()
        end
    end, {
        nargs = "?"
    })
end

return Tabwidth
