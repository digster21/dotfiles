-- Set neovim keymap.
--
-- Convenience wrapper around `vim.keymap.set`.
--
-- Custom Args:
--      mops(table): Custom options
--
-- Returns:
--      `vim.keymap.set(...)`
return function(mode, lhs, rhs, opts, mops)
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

    return vim.keymap.set(mode, lhs, rhs, opts)
end
