local Tabwidth = {}

--- Print the configured indentation (shiftwidth, tabstop, and softtabstop).
--- If they are all the same, only prints the shiftwidth.
function Tabwidth.print()
    print(vim.inspect(Tabwidth.cfg))
end

--- Validate input width as a positive integer or nil.
---@param width? number Width to sanitize
---@return integer? width
function Tabwidth.sanitize_width(width)
    vim.validate({
        width = { width, "number", true },
    })

    -- Ensure that width is a positive integer
    if width == nil or width % 1 ~= 0 or width < 1 then
        return nil
    end

    return width
end

--- Set the configured indentation (shiftwidth, tabstop, softtabstop) to a given value.
---@param width integer Width to configure.
function Tabwidth.set_default(width)
    Tabwidth.cfg.width = width

    vim.o.shiftwidth = width
    vim.o.tabstop = width
    vim.o.softtabstop = width
end

--- Set the configured indentation
---@param filetype string
---@param width integer
function Tabwidth.set_ft(filetype, width)
    Tabwidth.cfg.ft[filetype] = width
end

--- Setup Tabwidth.
---@param opts? {default?: integer} Setup options
function Tabwidth.setup(opts)
    -- Setup Tabwidth state
    Tabwidth.cfg = {}
    Tabwidth.cfg.ft = {}

    -- Configure Tabwidth options
    if opts then
        -- Set default width
        opts.default = Tabwidth.sanitize_width(opts.default)
        if opts.default then
            Tabwidth.set_default(opts.default)
        end
    end

    -- Configure User command
    vim.api.nvim_create_user_command("Tabwidth", function(options)
        local argc = #options.fargs

        if argc == 0 then
            Tabwidth.print()
            return
        end

        if argc ~= 2 then
            vim.notify("Invalid usage. Expects :Tabwidth <scope> <width>", vim.log.levels.ERROR)
            return
        end

        local scope = options.fargs[1]
        local width = Tabwidth.sanitize_width(tonumber(options.fargs[2]))

        if width == nil then
            vim.notify("Invalid usage. Expects <width> to be a positive integer", vim.log.levels.ERROR)
            return
        end

        if scope == "default" then
            Tabwidth.set_default(width)
        elseif scope == "ft" then
            Tabwidth.set_ft(vim.bo.filetype, width)
        else
            vim.notify("Invalid usage. Expects <scope> to be 'default' or 'ft'", vim.log.levels.ERROR)
            return
        end
    end, {
        nargs = "*"
    })
end

return Tabwidth
