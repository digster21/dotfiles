-- ============================================================================
-- TABWIDTH
-- ============================================================================

-- ============================================================================
-- Types
-- ============================================================================

---@class TabwidthConfig
---@field shiftwidth? integer
---@field tabstop? integer
---@field softtabstop? integer

---@class TabwidthOpts
---@field global? TabwidthConfig
---@field buffer? table<number,TabwidthConfig>
---@field filetype? table<string, TabwidthConfig>


-- ============================================================================
-- Global State
-- ============================================================================

local TabwidthAPI = {}

-- ============================================================================
-- Functions
-- ============================================================================

--- Validate input width as a positive integer or nil.
---@param width? number Width to sanitize
---@return integer? width
function TabwidthAPI.sanitize_width(width)
    vim.validate({
        width = { width, "number", true },
    })

    -- Ensure that width is a positive integer
    if width == nil or width % 1 ~= 0 or width < 1 then
        return nil
    end

    return width
end

--- Validate input config.
--- @param cfg TabwidthConfig
--- @return TabwidthConfig
function TabwidthAPI.sanitize_config(cfg)
    local out = {}

    if cfg.tabstop then
        local ts = TabwidthAPI.sanitize_width(cfg.tabstop)
        if ts then
            out.tabstop = ts
        end
    end

    if cfg.softtabstop then
        local sts = TabwidthAPI.sanitize_width(cfg.softtabstop)
        if sts then
            out.softtabstop = sts
        end
    end

    if cfg.shiftwidth then
        local sw = TabwidthAPI.sanitize_width(cfg.shiftwidth)
        if sw then
            out.shiftwidth = sw
        end
    end

    return out
end

--- Get the configured tabwidth
--- @param opt vim.api.keyset.option
--- @return TabwidthConfig
function TabwidthAPI.get_cfg(opt)
    return {
        shiftwidth = vim.api.nvim_get_option_value("shiftwidth", opt),
        tabstop = vim.api.nvim_get_option_value("tabstop", opt),
        softtabstop = vim.api.nvim_get_option_value("softtabstop", opt),
    }
end

--- Set the configured tabwidth
--- @param cfg TabwidthConfig
--- @param opt vim.api.keyset.option
function TabwidthAPI.set_cfg(cfg, opt)
    -- Validate config
    local safe_cfg = TabwidthAPI.sanitize_config(cfg)

    -- Change values if they exist
    if safe_cfg.shiftwidth then
        vim.api.nvim_set_option_value("shiftwidth", safe_cfg.shiftwidth, opt)
    end

    if safe_cfg.tabstop then
        vim.api.nvim_set_option_value("tabstop", safe_cfg.tabstop, opt)
    end

    if safe_cfg.softtabstop then
        vim.api.nvim_set_option_value("softtabstop", safe_cfg.softtabstop, opt)
    end
end

--- Print the configured tabwidth
--- @param prefix string
--- @param cfg TabwidthConfig
function TabwidthAPI.print_cfg(prefix, cfg)
    if cfg.shiftwidth == cfg.tabstop and cfg.shiftwidth == cfg.softtabstop then
        print(prefix .. cfg.shiftwidth)
        return
    end

    -- Fallback to printing entire config obj
    local parts = {}
    for k, v in pairs(cfg) do
        table.insert(parts, k .. "=" .. v)
    end
    print(prefix .. table.concat(parts, ", "))
end

--- Set the configured tabwidth.
--- @param cfg TabwidthConfig
function TabwidthAPI.set_global(cfg)
    TabwidthAPI.set_cfg(cfg, { scope = "global" })
end

--- Print the global indentation config.
function TabwidthAPI.print_global()
    local cfg = TabwidthAPI.get_cfg({ scope = "global" })
    TabwidthAPI.print_cfg("global: ", cfg)
end

--- Set the configured tabwidth for a buffer.
--- @param buf integer buffer id
--- @param cfg TabwidthConfig
function TabwidthAPI.set_buffer(buf, cfg)
    TabwidthAPI.set_cfg(cfg, { buf = buf })
end

--- Print the indentation config for a buffer.
--- @param buf integer buffer id
function TabwidthAPI.print_buffer(buf)
    local cfg = TabwidthAPI.get_cfg({ buf = buf })
    TabwidthAPI.print_cfg(string.format("buffer (%d): ", buf), cfg)
end

--- Set the configured tabwidth for a filetype.
--- @param ft string filetype
--- @param cfg TabwidthConfig
function TabwidthAPI.set_filetype(ft, cfg)
    -- should be a wrapper around buffer with auto commands
end

--- Print the indentation config for a filetype.
--- @param ft string filetype
function TabwidthAPI.print_filetype(ft)
    -- should be a wrapper around buffer with auto commands
end

--- Parse command arguments
--- @param width integer
--- @return TabwidthConfig
function TabwidthAPI.width_to_cfg(width)
    return {
        shiftwidth = width,
        softtabstop = width,
        tabstop = width,
    }
end

--- Setup Tabwidth.
--- @param opts TabwidthOpts
function TabwidthAPI.setup(opts)
    -- Configure Tabwidth options
    if opts then
        if opts.global then
            TabwidthAPI.set_global(opts.global)
        end

        for k, v in pairs(opts.buffer or {}) do
            TabwidthAPI.set_buffer(k, v)
        end

        for k, v in pairs(opts.filetype or {}) do
            TabwidthAPI.set_filetype(k, v)
        end
    end

    -- Configure User command
    vim.api.nvim_create_user_command("Tabwidth", function(options)
        local argc = #options.fargs

        if argc == 0 then
            TabwidthAPI.print_global()
            return
        end

        if argc > 1 then
            vim.notify("Invalid usage. Expects :Tabwidth <width?>", vim.log.levels.ERROR)
            return
        end

        local width = TabwidthAPI.sanitize_width(tonumber(options.fargs[1]))

        if not width then
            vim.notify("Invalid usage. Expects <width> to be a positive integer", vim.log.levels.ERROR)
            return
        end

        TabwidthAPI.set_global(TabwidthAPI.width_to_cfg(width))
    end, {
        nargs = "*"
    })
end

return TabwidthAPI
