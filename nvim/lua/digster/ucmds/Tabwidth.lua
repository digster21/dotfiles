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

---@class TabwidthState
---@field default? TabwidthConfig
---@field buffers table<integer, TabwidthConfig>
---@field filetypes table<string, TabwidthConfig>
local state = {
    default = nil,
    buffers = {},
    filetypes = {},
}

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
    local parts = {}
    for k, v in pairs(cfg) do
        table.insert(parts, k .. "=" .. v)
    end
    print(prefix .. table.concat(parts, ", "))
end

--- Resolve the effective config for a buffer using priority:
--- buffer > filetype > default
--- @param buf integer buffer id
--- @return TabwidthConfig?
function TabwidthAPI.resolve(buf)
    local ft = vim.bo[buf].filetype
    return state.buffers[buf]
        or state.filetypes[ft]
        or state.default
        or nil
end

--- Apply the resolved tabwidth config to a buffer.
--- @param buf integer buffer id
function TabwidthAPI.apply(buf)
    local cfg = TabwidthAPI.resolve(buf)
    if not cfg then
        return
    end

    local sw = cfg.shiftwidth or cfg.width
    local ts = cfg.tabstop or cfg.width
    local sts = cfg.softtabstop or cfg.width

    if sw then
        vim.bo[buf].shiftwidth = sw
    end
    if ts then
        vim.bo[buf].tabstop = ts
    end
    if sts then
        vim.bo[buf].softtabstop = sts
    end
end

--- Get the effective tabwidth config for a buffer.
--- @param buf integer
--- @return TabwidthConfig
function TabwidthAPI.get_buffer(buf)
    return TabwidthAPI.consolidate_cfg({
        shiftwidth = vim.bo[buf].shiftwidth,
        tabstop = vim.bo[buf].tabstop,
        softtabstop = vim.bo[buf].softtabstop,
    })
end

--- Get the default tabwidth config.
--- @return TabwidthConfig
function TabwidthAPI.get_default()
    return state.default or TabwidthAPI.consolidate_cfg({
        shiftwidth = vim.o.shiftwidth,
        tabstop = vim.o.tabstop,
        softtabstop = vim.o.softtabstop,
    })
end

--- Set the default tabwidth config and propagate to non-overridden buffers.
--- @param cfg TabwidthConfig
function TabwidthAPI.set_default(cfg)
    state.default = TabwidthAPI.consolidate_cfg(cfg)

    -- Propagate to buffers without explicit overrides
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
            local ft = vim.bo[buf].filetype
            if not state.buffers[buf] and not state.filetypes[ft] then
                TabwidthAPI.apply(buf)
            end
        end
    end
end

--- Print the default tabwidth config.
function TabwidthAPI.print_default()
    local cfg = TabwidthAPI.get_default()
    TabwidthAPI.print_cfg("default: ", cfg)
end

--- Set the configured tabwidth for a buffer.
--- @param buf integer buffer id
--- @param cfg TabwidthConfig
function TabwidthAPI.set_buffer(buf, cfg)
    state.buffers[buf] = TabwidthAPI.consolidate_cfg(cfg)
    TabwidthAPI.apply(buf)
end

--- Clear the explicit buffer override and reapply inherited config.
--- @param buf integer buffer id
function TabwidthAPI.clear_buffer(buf)
    state.buffers[buf] = nil
    TabwidthAPI.apply(buf)
end

--- Print the indentation config for a buffer.
--- @param buf integer buffer id
function TabwidthAPI.print_buffer(buf)
    local cfg = TabwidthAPI.get_buffer(buf)
    local source = state.buffers[buf] and "buffer (explicit)"
        or state.filetypes[vim.bo[buf].filetype] and "buffer (filetype)"
        or state.default and "buffer (default)"
        or "buffer (vim)"
    TabwidthAPI.print_cfg(string.format("%s [%d]: ", source, buf), cfg)
end

--- Set the configured tabwidth for a filetype and apply to matching buffers.
--- @param ft string filetype
--- @param cfg TabwidthConfig
function TabwidthAPI.set_filetype(ft, cfg)
    state.filetypes[ft] = TabwidthAPI.consolidate_cfg(cfg)

    -- Apply to all loaded buffers with this filetype
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == ft then
            if not state.buffers[buf] then
                TabwidthAPI.apply(buf)
            end
        end
    end
end

--- Clear the explicit filetype override and reapply inherited config.
--- @param ft string filetype
function TabwidthAPI.clear_filetype(ft)
    state.filetypes[ft] = nil

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == ft then
            if not state.buffers[buf] then
                TabwidthAPI.apply(buf)
            end
        end
    end
end

--- Print the indentation config for a filetype.
--- @param ft string filetype
function TabwidthAPI.print_filetype(ft)
    local cfg = state.filetypes[ft]
    if cfg then
        TabwidthAPI.print_cfg(string.format("filetype (%s): ", ft), cfg)
    else
        print(string.format("filetype (%s): no override", ft))
    end
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

    vim.api.nvim_create_augroup("Tabwidth", { clear = true })

    -- Apply config when filetype is detected or changed
    vim.api.nvim_create_autocmd("FileType", {
        group = "Tabwidth",
        callback = function(ev)
            -- Only apply if buffer has no explicit override
            if not state.buffers[ev.buf] then
                TabwidthAPI.apply(ev.buf)
            end
        end,
    })

    -- Clean up buffer state on delete
    vim.api.nvim_create_autocmd("BufDelete", {
        group = "Tabwidth",
        callback = function(ev)
            state.buffers[ev.buf] = nil
        end,
    })

    -- Configure User command
    vim.api.nvim_create_user_command("Tabwidth", function(options)
        local argc = #options.fargs

        -- Validate args
        if argc < 1 or argc > 2 then
            vim.notify("Invalid usage. Expects :Tabwidth <default|buffer|filetype> <width?>", vim.log.levels.ERROR)
            return
        end

        local scope = options.fargs[1]

        if not (scope == "default" or scope == "buffer" or scope == "filetype") then
            vim.notify(string.format("Invalid usage. Expects 'default', 'buffer', or 'filetype', got: '%s'", scope),
                vim.log.levels.ERROR)
            return
        end

        -- Configure tabwidth
        local buf = vim.api.nvim_get_current_buf()
        if argc == 1 then
            if scope == "default" then
                TabwidthAPI.print_default()
            elseif scope == "buffer" then
                TabwidthAPI.print_buffer(buf)
            elseif scope == "filetype" then
                local ft = vim.bo[buf].filetype
                TabwidthAPI.print_filetype(ft)
            end
        elseif argc == 2 then
            local width = TabwidthAPI.sanitize_width(tonumber(options.fargs[2]))
            if not width then
                vim.notify("Invalid usage. Expects <width> to be a positive integer", vim.log.levels.ERROR)
                return
            end
            if scope == "default" then
                TabwidthAPI.set_default({ width = width })
            elseif scope == "buffer" then
                TabwidthAPI.set_buffer(buf, { width = width })
            elseif scope == "filetype" then
                local ft = vim.bo[buf].filetype
                TabwidthAPI.set_filetype(ft, { width = width })
            end
        end
    end, {
        nargs = "*",
        desc = "Preview or set the default tabwidth",
        complete = function(arg, line)
            local args = vim.split(line, "%s+", { trimempty = true })
            local argc = #args

            -- Add completion for scope
            if argc == 1 or (argc == 2 and not line:match("%s$")) then
                local candidates = { "default", "buffer", "filetype" }
                return vim.tbl_filter(function(c)
                    return c:find(arg, 1, true) == 1
                end, candidates)
            end

            return {}
        end
    })
end

return TabwidthAPI
