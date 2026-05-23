-- ============================================================================
-- TABWIDTH
-- ============================================================================

-- ============================================================================
-- Types
-- ============================================================================

---@class TabwidthConfig
---@field width? integer Default value of shiftwidth, tabstop, and softtabstop.
---@field shiftwidth? integer Override width with custom shiftwidth
---@field tabstop? integer Override width with custom tabstop
---@field softtabstop? integer Override width with custom tabstop

---@class TabwidthOpts
---@field default? TabwidthConfig
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

--- Reduce configured options if possible.
--- @param cfg TabwidthConfig
--- @return TabwidthConfig
function TabwidthAPI.consolidate_cfg(cfg)
    local out = {}

    if cfg.width then
        local w = TabwidthAPI.sanitize_width(cfg.width)
        if w then
            out.width = w
        end
    end

    if cfg.shiftwidth then
        local sw = TabwidthAPI.sanitize_width(cfg.shiftwidth)
        if sw and sw ~= cfg.width then
            out.shiftwidth = sw
        end
    end

    if cfg.tabstop then
        local ts = TabwidthAPI.sanitize_width(cfg.tabstop)
        if ts and ts ~= cfg.width then
            out.tabstop = ts
        end
    end

    if cfg.softtabstop then
        local sts = TabwidthAPI.sanitize_width(cfg.softtabstop)
        if sts and sts ~= cfg.width then
            out.softtabstop = sts
        end
    end

    return out
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

--- Get the default tabwidth config.
--- @return TabwidthConfig
function TabwidthAPI.get_default()
    return TabwidthAPI.consolidate_cfg({
        shiftwidth = vim.o.shiftwidth,
        tabstop = vim.o.tabstop,
        softtabstop = vim.o.softtabstop,
    })
end

--- Set the default tabwidth config.
--- @param cfg TabwidthConfig
function TabwidthAPI.set_default(cfg)
    local safe_cfg = TabwidthAPI.consolidate_cfg(cfg)

    -- Change values if they exist
    if safe_cfg.shiftwidth or safe_cfg.width then
        vim.o.shiftwidth = safe_cfg.shiftwidth or safe_cfg.width
    end

    if safe_cfg.tabstop or safe_cfg.width then
        vim.o.tabstop = safe_cfg.tabstop or safe_cfg.width
    end

    if safe_cfg.softtabstop or safe_cfg.width then
        vim.o.softtabstop = safe_cfg.softtabstop or safe_cfg.width
    end
end

--- Print the default tabwidth config.
function TabwidthAPI.print_default()
    local cfg = TabwidthAPI.get_default()
    TabwidthAPI.print_cfg("default: ", cfg)
end

--- Get the buffers tabwidth config.
--- @param buf integer
--- @return TabwidthConfig
function TabwidthAPI.get_buffer(buf)
    return TabwidthAPI.consolidate_cfg({
        shiftwidth = vim.bo[buf].shiftwidth,
        tabstop = vim.bo[buf].tabstop,
        softtabstop = vim.bo[buf].softtabstop,
    })
end

--- Set the configured tabwidth for a buffer.
--- @param buf integer buffer id
--- @param cfg TabwidthConfig
function TabwidthAPI.set_buffer(buf, cfg)
    local safe_cfg = TabwidthAPI.consolidate_cfg(cfg)

    -- Change values if they exist
    if safe_cfg.shiftwidth or safe_cfg.width then
        vim.bo[buf].shiftwidth = safe_cfg.shiftwidth or safe_cfg.width
    end

    if safe_cfg.tabstop or safe_cfg.width then
        vim.bo[buf].tabstop = safe_cfg.tabstop or safe_cfg.width
    end

    if safe_cfg.softtabstop or safe_cfg.width then
        vim.bo[buf].softtabstop = safe_cfg.softtabstop or safe_cfg.width
    end
end

--- Print the indentation config for a buffer.
--- @param buf integer buffer id
function TabwidthAPI.print_buffer(buf)
    local cfg = TabwidthAPI.get_buffer(buf)
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

--- Setup Tabwidth.
--- @param opts TabwidthOpts
function TabwidthAPI.setup(opts)
    -- Configure Tabwidth options
    if opts then
        if opts.default then
            TabwidthAPI.set_default(opts.default)
        end

        for k, v in pairs(opts.buffer or {}) do
            TabwidthAPI.set_buffer(k, v)
        end

        for k, v in pairs(opts.filetype or {}) do
            TabwidthAPI.set_filetype(k, v)
        end
    end

    -- Configure User command
    vim.api.nvim_create_user_command("TabwidthDefault", function(options)
        local argc = #options.fargs

        if argc == 0 then
            TabwidthAPI.print_default()
            return
        end

        if argc > 1 then
            vim.notify("Invalid usage. Expects :TabwidthDefault <width?>", vim.log.levels.ERROR)
            return
        end

        local width = TabwidthAPI.sanitize_width(tonumber(options.fargs[1]))

        if not width then
            vim.notify("Invalid usage. Expects <width> to be a positive integer", vim.log.levels.ERROR)
            return
        end

        TabwidthAPI.set_default({ width = width })
    end, {
        nargs = "*",
        desc = "Preview or set the default tabwidth"
    })

    -- Configure User command
    vim.api.nvim_create_user_command("TabwidthBuf", function(options)
        local argc = #options.fargs

        local buf = vim.api.nvim_get_current_buf()

        if argc == 0 then
            TabwidthAPI.print_buffer(buf)
            return
        end

        if argc > 1 then
            vim.notify("Invalid usage. Expects :TabwidthBuf <width?>", vim.log.levels.ERROR)
            return
        end

        local width = TabwidthAPI.sanitize_width(tonumber(options.fargs[1]))

        if not width then
            vim.notify("Invalid usage. Expects <width> to be a positive integer", vim.log.levels.ERROR)
            return
        end



        TabwidthAPI.set_buffer(buf, { width = width })
    end, {
        nargs = "*",
        desc = "Preview or set the default tabwidth of the current buffer"
    })
end

return TabwidthAPI
