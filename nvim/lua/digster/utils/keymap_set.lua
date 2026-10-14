---@class digster.KeymapSetMops
---@field debug? boolean Log the mapping and its call site via `vim.notify`.

--- Set neovim keymap.
---
--- Convenience wrapper around `vim.keymap.set`.
---
---@param mode string|string[] Mode short-name(s), see `vim.keymap.set`.
---@param lhs string Left-hand side of the mapping.
---@param rhs string|function Right-hand side of the mapping.
---@param opts? vim.keymap.set.Opts Options passed to `vim.keymap.set`.
---@param mops? digster.KeymapSetMops Custom options.
local function keymap_set(mode, lhs, rhs, opts, mops)
    opts = opts or {}
    mops = (type(mops) == "table" and mops) or {}
    local debug_enabled = mops.debug or false

    if debug_enabled then
        local trace = debug.getinfo(2, "Sl")
        local info = string.format(
            "[keymap] mode=%s lhs=%s rhs=%s opts=%s @ %s:%d",
            vim.inspect(mode),
            vim.inspect(lhs),
            type(rhs) == "string" and rhs or "<function>",
            vim.inspect(opts),
            trace.short_src,
            trace.currentline
        )
        vim.notify(info, vim.log.levels.DEBUG)
    end

    vim.keymap.set(mode, lhs, rhs, opts)
end

return keymap_set
